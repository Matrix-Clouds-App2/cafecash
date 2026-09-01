import 'package:equatable/equatable.dart';

class EmployeeModel extends Equatable {
  final int id;
  final String name;
  final String phone;
  final String? email;
  final int? cafeId;
  final String status;
  final String type;
  final String? createdAt;

  const EmployeeModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.cafeId,
    required this.status,
    required this.type,
    this.createdAt,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        id: json['id'] as int,
        name: json['name'] as String,
        phone: json['phone'] as String? ?? '',
        email: json['email'] as String?,
        cafeId: json['cafe_id'] as int?,
        status: json['status'] as String? ?? 'active',
        type: json['type'] as String? ?? 'employee',
        createdAt: json['created_at'] as String?,
      );

  bool get isActive => status == 'active';

  @override
  List<Object?> get props =>
      [id, name, phone, email, cafeId, status, type, createdAt];
}
