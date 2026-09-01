import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/storage/object_box/local_box.dart';
import '../../../core/storage/object_box/object_box_storage.dart';
import 'models/remote_shift_summary.dart';
import 'models/shift_entity.dart';

class ShiftRepo {
  ShiftRepo({required ObjectBoxStorage storage, required DioClient dio})
      : _box = storage.box<ShiftEntity>(),
        _dio = dio;

  final LocalBox<ShiftEntity> _box;
  final DioClient _dio;

  ShiftEntity? getActiveShift() {
    final all = _box.getAll();
    for (final shift in all) {
      if (shift.statusEnum == ShiftStatus.open) return shift;
    }
    return null;
  }

  List<ShiftEntity> getUnsyncedClosedShifts() => _box
      .getAll()
      .where((shift) =>
          shift.statusEnum == ShiftStatus.closed &&
          !shift.synced &&
          !shift.remoteOnly)
      .toList();

  Stream<ShiftEntity?> watchActiveShift() => _box.watchAll().map((all) {
        for (final shift in all) {
          if (shift.statusEnum == ShiftStatus.open) return shift;
        }
        return null;
      });

  List<ShiftEntity> getHistory() => _historyFrom(_box.getAll());

  Stream<List<ShiftEntity>> watchHistory() => _box.watchAll().map(_historyFrom);

  List<ShiftEntity> _historyFrom(List<ShiftEntity> all) {
    final closed =
        all.where((shift) => shift.statusEnum == ShiftStatus.closed).toList();
    closed.sort((a, b) =>
        (b.closedAt ?? DateTime(0)).compareTo(a.closedAt ?? DateTime(0)));
    return closed;
  }

  ShiftEntity startShift({required double openingBalance}) {
    final active = getActiveShift();
    if (active != null) return active;

    final shift = ShiftEntity(
      openingBalance: openingBalance,
      startedAt: DateTime.now(),
      uuid: const Uuid().v4(),
    );
    shift.id = _box.put(shift);
    return shift;
  }

  void closeShift(ShiftEntity shift, {required double closingBalance}) {
    shift
      ..statusEnum = ShiftStatus.closed
      ..closedAt = DateTime.now()
      ..closingBalance = closingBalance;
    _box.put(shift);
  }

  void save(ShiftEntity shift) => _box.put(shift);

  Future<List<RemoteShiftSummary>> fetchRemoteShifts() async {
    try {
      final response = await _dio.get(ApiEndpoints.shifts);
      final data = response.data;
      final list = data is Map ? (data['data']?['shifts'] as List?) : null;
      return (list ?? const [])
          .map((e) => RemoteShiftSummary.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<void> reconcileWithRemote() async {
    final remoteShifts = await fetchRemoteShifts();
    _dedupeLocalShiftsByUuid();

    final localByUuid = <String, ShiftEntity>{
      for (final s in _box.getAll())
        if (s.uuid.isNotEmpty) s.uuid: s,
    };

    for (final remote in remoteShifts) {
      if (!remote.isClosed) continue;

      final local = localByUuid[remote.uuid];
      if (local != null) {
        final needsId = local.remoteId != remote.remoteId && remote.remoteId != null;
        if (!local.synced || needsId) {
          if (!local.synced) {
            local
              ..synced = true
              ..syncedAt = remote.syncedAt ?? DateTime.now();
          }
          if (needsId) local.remoteId = remote.remoteId;
          _box.put(local);
        }
        continue;
      }

      final stub = ShiftEntity(
        uuid: remote.uuid,
        remoteId: remote.remoteId,
        openingBalance: remote.openingBalance,
        closingBalance: remote.closingBalance,
        status: remote.statusEnum.index,
        startedAt: remote.startedAt,
        closedAt: remote.closedAt,
        synced: true,
        syncedAt: remote.syncedAt,
        remoteOnly: true,
      );
      stub.id = _box.put(stub);
      localByUuid[remote.uuid] = stub;
    }
  }

  void _dedupeLocalShiftsByUuid() {
    final groups = <String, List<ShiftEntity>>{};
    for (final shift in _box.getAll()) {
      if (shift.uuid.isEmpty) continue;
      groups.putIfAbsent(shift.uuid, () => []).add(shift);
    }

    final idsToRemove = <int>[];
    for (final group in groups.values) {
      if (group.length <= 1) continue;
      group.sort((a, b) {
        if (a.remoteOnly != b.remoteOnly) return a.remoteOnly ? 1 : -1;
        return a.id.compareTo(b.id);
      });
      idsToRemove.addAll(group.skip(1).map((s) => s.id));
    }

    if (idsToRemove.isNotEmpty) _box.removeMany(idsToRemove);
  }
}
