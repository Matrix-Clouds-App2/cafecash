import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/storage/pending_deletion_repo.dart';
import '../../customers/data/customers_repo.dart';
import '../../items/data/items_repo.dart';
import '../../orders/data/orders_repo.dart';
import '../../shift/data/models/shift_entity.dart';
import '../../shift/data/shift_repo.dart';
import 'bootstrap_merger.dart';
import 'models/bootstrap_merge_plan.dart';
import 'models/bootstrap_snapshot.dart';
import 'models/sync_image_ref.dart';
import 'models/sync_progress.dart';
import 'models/sync_upload_result.dart';
import 'sync_payload_builder.dart';

List<int> gzipJsonBytes(List<int> jsonBytes) =>
    GZipEncoder().encode(jsonBytes)!;

List<int> buildImagesZip(List<SyncImageRef> refs) {
  final archive = Archive();
  for (final ref in refs) {
    final file = File(ref.localPath);
    if (!file.existsSync()) continue;
    final bytes = file.readAsBytesSync();
    archive.addFile(ArchiveFile(ref.imageKey, bytes.length, bytes));
  }
  return ZipEncoder().encode(archive)!;
}

void debugLogSyncPayload(Map<String, dynamic> json) {
  if (!kDebugMode) return;
  debugPrint('╔ Sync payload (data.json, before gzip) ════════════════════');
  const JsonEncoder.withIndent('  ')
      .convert(json)
      .split('\n')
      .forEach((line) => debugPrint('║ $line'));
  debugPrint('╚════════════════════════════════════════════════════════════');
}

void debugLogImageRefs(List<SyncImageRef> refs) {
  if (!kDebugMode) return;
  if (refs.isEmpty) {
    debugPrint('╟ Sync images.zip: no image_key referenced, no images part sent');
    return;
  }
  debugPrint('╔ Sync images.zip contents (before zipping) ════════════════');
  for (final ref in refs) {
    final exists = File(ref.localPath).existsSync();
    debugPrint(
        '║ ${exists ? 'OK     ' : 'MISSING'}  ${ref.imageKey}  <-  ${ref.localPath}');
  }
  debugPrint('╚════════════════════════════════════════════════════════════');
}

class SyncRepo {
  SyncRepo({
    required DioClient dio,
    required SyncPayloadBuilder payloadBuilder,
    required BootstrapMerger bootstrapMerger,
    required ShiftRepo shiftRepo,
    required OrdersRepo ordersRepo,
    required CustomersRepo customersRepo,
    required ItemsRepo itemsRepo,
    required PendingDeletionRepo pendingDeletionRepo,
  })  : _dio = dio,
        _payloadBuilder = payloadBuilder,
        _bootstrapMerger = bootstrapMerger,
        _shiftRepo = shiftRepo,
        _ordersRepo = ordersRepo,
        _customersRepo = customersRepo,
        _itemsRepo = itemsRepo,
        _pendingDeletionRepo = pendingDeletionRepo;

  final DioClient _dio;
  final SyncPayloadBuilder _payloadBuilder;
  final BootstrapMerger _bootstrapMerger;
  final ShiftRepo _shiftRepo;
  final OrdersRepo _ordersRepo;
  final CustomersRepo _customersRepo;
  final ItemsRepo _itemsRepo;
  final PendingDeletionRepo _pendingDeletionRepo;

  Future<SyncUploadResult> uploadShift(
    ShiftEntity shift, {
    required void Function(SyncProgress) onProgress,
  }) async {
    onProgress(const SyncProgress(phase: SyncPhase.preparing));

    if (shift.pendingSyncUuid == null || shift.pendingSyncUuid!.isEmpty) {
      shift.pendingSyncUuid = const Uuid().v4();
      _shiftRepo.save(shift);
    }
    final syncUuid = shift.pendingSyncUuid!;

    final payload = _payloadBuilder.build(shift, syncUuid: syncUuid);
    debugLogSyncPayload(payload.json);
    debugLogImageRefs(payload.imageRefs);
    final jsonBytes = utf8.encode(jsonEncode(payload.json));

    onProgress(const SyncProgress(phase: SyncPhase.compressing));
    final gzBytes = await compute(gzipJsonBytes, jsonBytes);
    if (kDebugMode) {
      debugPrint(
          '╟ sync_data.json.gz: ${jsonBytes.length} bytes -> ${gzBytes.length} bytes gzipped');
    }

    List<int>? zipBytes;
    if (payload.imageRefs.isNotEmpty) {
      onProgress(const SyncProgress(phase: SyncPhase.zippingImages));
      final builtZip = await compute(buildImagesZip, payload.imageRefs);
      zipBytes = builtZip;
      if (kDebugMode) {
        debugPrint('╟ images.zip: ${builtZip.length} bytes');
      }
    }

    final form = FormData();
    form.files.add(MapEntry(
      'data',
      MultipartFile.fromBytes(gzBytes, filename: 'sync_data.json.gz'),
    ));
    if (zipBytes != null && zipBytes.isNotEmpty) {
      form.files.add(MapEntry(
        'images',
        MultipartFile.fromBytes(zipBytes, filename: 'images.zip'),
      ));
    }

    final startedAt = DateTime.now();

    try {
      final response = await _dio.postForm(
        ApiEndpoints.syncUpload,
        form,
        onSendProgress: (sent, total) {
          if (total <= 0) return;
          final elapsedSeconds =
              DateTime.now().difference(startedAt).inMilliseconds / 1000.0;
          final speed = elapsedSeconds > 0 ? sent / elapsedSeconds : 0;
          final remaining = total - sent;
          final etaSeconds = speed > 0 ? remaining / speed : null;
          onProgress(SyncProgress(
            phase: SyncPhase.uploading,
            current: sent,
            total: total,
            eta: etaSeconds == null
                ? null
                : Duration(seconds: etaSeconds.round()),
          ));
        },
      );

      final body = response.data;
      final data = body is Map
          ? (body['data'] as Map?)?.cast<String, dynamic>()
          : null;
      final result = SyncUploadResult.fromJson(data ?? const {});

      _customersRepo.markSynced(payload.customersToMarkSynced);
      _itemsRepo.markCategoriesSynced(payload.categoriesToMarkSynced);
      _itemsRepo.markItemsSynced(payload.itemsToMarkSynced);
      _ordersRepo.markSynced(payload.ordersToMarkSynced);
      _pendingDeletionRepo.removeMany(payload.deletionIdsToConsume);

      shift
        ..synced = true
        ..syncedAt = DateTime.now()
        ..pendingSyncUuid = null;
      if (result.shiftUuid != null &&
          result.shiftUuid!.isNotEmpty &&
          result.shiftUuid != shift.uuid) {
        if (kDebugMode) {
          debugPrint(
              '╟ sync/upload returned a different shift_uuid: sent=${shift.uuid} server=${result.shiftUuid} — aligning local to server value');
        }
        shift.uuid = result.shiftUuid!;
      }
      _shiftRepo.save(shift);

      return result;
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<BootstrapSnapshot> downloadBootstrap({
    required void Function(SyncProgress) onProgress,
  }) async {
    onProgress(const SyncProgress(phase: SyncPhase.downloading));
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.syncBootstrap,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = (response.data as List<int>?) ?? const <int>[];
      onProgress(const SyncProgress(phase: SyncPhase.merging));
      final snapshot = BootstrapSnapshot.fromResponseBytes(bytes);
      if (kDebugMode) {
        debugPrint('╟ bootstrap: ${bytes.length} bytes -> '
            'cats=${snapshot.categories.length} items=${snapshot.menuItems.length} '
            'customers=${snapshot.customers.length} orders=${snapshot.orders.length} '
            'treasury=${snapshot.treasury.length}');
      }
      return snapshot;
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<void> hydrateShift(ShiftEntity shift) async {
    final remoteId = shift.remoteId;
    if (remoteId == null) {
      throw const NetworkException('shift has no remote id yet');
    }
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.shiftDetails(remoteId),
      );
      final body = response.data;
      final shiftJson = body is Map
          ? ((body['data'] as Map?)?['shift'] as Map?)?.cast<String, dynamic>()
          : null;
      if (shiftJson != null) {
        final snapshot = BootstrapSnapshot.fromJson(shiftJson);
        final imported = _bootstrapMerger.importShiftData(snapshot, shift);
        if (kDebugMode) {
          debugPrint('╟ hydrateShift ${shift.uuid}: imported $imported orders');
        }
      }
      shift.remoteOnly = false;
      _shiftRepo.save(shift);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  BootstrapMergePlan planBootstrap(BootstrapSnapshot snapshot) =>
      _bootstrapMerger.plan(snapshot);

  Future<BootstrapMergeResult> applyBootstrap(
    BootstrapMergePlan plan,
    Map<String, BootstrapConflictChoice> choices,
  ) =>
      _bootstrapMerger.apply(plan, choices);
}
