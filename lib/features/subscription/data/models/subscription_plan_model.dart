import 'package:equatable/equatable.dart';

class SubscriptionPlanModel extends Equatable {
  final String name;
  final String code;
  final int durationValue;
  final String durationUnit;
  final String price;

  const SubscriptionPlanModel({
    required this.name,
    required this.code,
    required this.durationValue,
    required this.durationUnit,
    required this.price,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlanModel(
        name: json['name'] as String? ?? '',
        code: json['code'] as String? ?? '',
        durationValue: (json['duration_value'] as num?)?.toInt() ?? 0,
        durationUnit: json['duration_unit'] as String? ?? '',
        price: json['price']?.toString() ?? '0.00',
      );

  bool get isFree => (double.tryParse(price) ?? 0) <= 0;

  @override
  List<Object?> get props => [name, code, durationValue, durationUnit, price];
}
