import 'package:equatable/equatable.dart';

enum SubscriptionUiState { none, active, expired, pending }

class SubscriptionModel extends Equatable {
  final String status;
  final String? type;
  final String? plan;
  final String? planCode;
  final String? planPrice;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final bool isTrial;
  final bool isActive;
  final bool isExpired;
  final bool isPending;
  final int daysRemaining;
  final DateTime? cancelledAt;
  final String? notes;
  final DateTime? createdAt;

  const SubscriptionModel({
    required this.status,
    this.type,
    this.plan,
    this.planCode,
    this.planPrice,
    this.startsAt,
    this.endsAt,
    this.isTrial = false,
    this.isActive = false,
    this.isExpired = false,
    this.isPending = false,
    this.daysRemaining = 0,
    this.cancelledAt,
    this.notes,
    this.createdAt,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionModel(
        status: json['status'] as String? ?? '',
        type: json['type'] as String?,
        plan: json['plan'] as String?,
        planCode: json['plan_code'] as String?,
        planPrice: json['plan_price']?.toString(),
        startsAt: _parseDate(json['starts_at']),
        endsAt: _parseDate(json['ends_at']),
        isTrial: json['is_trial'] as bool? ?? false,
        isActive: json['is_active'] as bool? ?? false,
        isExpired: json['is_expired'] as bool? ?? false,
        isPending: json['is_pending'] as bool? ?? false,
        daysRemaining: (json['days_remaining'] as num?)?.toInt() ?? 0,
        cancelledAt: _parseDate(json['cancelled_at']),
        notes: json['notes'] as String?,
        createdAt: _parseDate(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'type': type,
        'plan': plan,
        'plan_code': planCode,
        'plan_price': planPrice,
        'starts_at': startsAt?.toIso8601String(),
        'ends_at': endsAt?.toIso8601String(),
        'is_trial': isTrial,
        'is_active': isActive,
        'is_expired': isExpired,
        'is_pending': isPending,
        'days_remaining': daysRemaining,
        'cancelled_at': cancelledAt?.toIso8601String(),
        'notes': notes,
        'created_at': createdAt?.toIso8601String(),
      };

  SubscriptionUiState get uiState {
    if (isPending) return SubscriptionUiState.pending;
    if (hasLiveCoverage) return SubscriptionUiState.active;
    if (isExpired || endsAt != null) return SubscriptionUiState.expired;
    return SubscriptionUiState.none;
  }

  bool get hasLiveCoverage {
    if (isPending) return false;
    final end = endsAt;
    if (end == null) return isActive;
    return DateTime.now().isBefore(end);
  }

  static DateTime? _parseDate(Object? value) {
    if (value is! String || value.trim().isEmpty) return null;
    return DateTime.tryParse(_normalizeDigits(value.trim()))?.toLocal();
  }

  static String _normalizeDigits(String input) =>
      input.replaceAllMapped(RegExp('[٠-٩۰-۹]'), (match) {
        final code = match[0]!.codeUnitAt(0);
        final base = code >= 0x06F0 ? 0x06F0 : 0x0660;
        return String.fromCharCode(0x30 + code - base);
      });

  @override
  List<Object?> get props => [
        status,
        type,
        plan,
        planCode,
        planPrice,
        startsAt,
        endsAt,
        isTrial,
        isActive,
        isExpired,
        isPending,
        daysRemaining,
        cancelledAt,
        notes,
        createdAt,
      ];
}
