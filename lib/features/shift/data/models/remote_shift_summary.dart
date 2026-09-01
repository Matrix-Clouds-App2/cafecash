import 'package:equatable/equatable.dart';

import 'shift_entity.dart';

class RemoteShiftSummary extends Equatable {
  const RemoteShiftSummary({
    required this.uuid,
    required this.status,
    required this.openingBalance,
    this.remoteId,
    this.closingBalance,
    this.startedAt,
    this.closedAt,
    this.syncedAt,
  });

  final int? remoteId;
  final String uuid;
  final String status;
  final double openingBalance;
  final double? closingBalance;
  final DateTime? startedAt;
  final DateTime? closedAt;
  final DateTime? syncedAt;

  bool get isClosed => status == 'closed';

  ShiftStatus get statusEnum =>
      status == 'closed' ? ShiftStatus.closed : ShiftStatus.open;

  factory RemoteShiftSummary.fromJson(Map<String, dynamic> json) =>
      RemoteShiftSummary(
        remoteId: json['id'] is num ? (json['id'] as num).toInt() : null,
        uuid: json['uuid'] as String,
        status: json['status'] as String? ?? 'open',
        openingBalance: double.tryParse('${json['opening_balance']}') ?? 0,
        closingBalance: json['closing_balance'] == null
            ? null
            : double.tryParse('${json['closing_balance']}'),
        startedAt: _parseLocal(json['started_at'] as String?),
        closedAt: _parseLocal(json['closed_at'] as String?),
        syncedAt: _parseLocal(json['synced_at'] as String?),
      );

  static DateTime? _parseLocal(String? iso) =>
      iso == null ? null : DateTime.tryParse(iso)?.toLocal();

  @override
  List<Object?> get props => [
        remoteId,
        uuid,
        status,
        openingBalance,
        closingBalance,
        startedAt,
        closedAt,
        syncedAt,
      ];
}
