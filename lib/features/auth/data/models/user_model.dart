import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String name;
  final String phone;
  final String? email;
  final int? cafeId;
  final String? cafeName;
  final String? status;
  final String? type;
  final String? avatar;
  final String? token;
  final String? createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.cafeId,
    this.cafeName,
    this.status,
    this.type,
    this.avatar,
    this.token,
    this.createdAt,
  });

  /// [json] is the API's "employee" object (also reused to decode the
  /// locally-cached copy written by [toJson], which mirrors the same
  /// `cafe: { name: ... }` shape). [token] rides alongside it (a sibling in
  /// the verify-otp response, not a field on the employee itself), so it's
  /// passed in separately rather than read from [json].
  factory UserModel.fromJson(Map<String, dynamic> json, {String? token}) =>
      UserModel(
        id: json['id'] as int,
        name: json['name'] as String,
        phone: json['phone'] as String? ?? '',
        email: json['email'] as String?,
        cafeId: json['cafe_id'] as int?,
        cafeName: (json['cafe'] as Map<String, dynamic>?)?['name'] as String?,
        status: json['status'] as String?,
        type: json['type'] as String?,
        avatar: json['avatar'] as String? ?? json['photo'] as String?,
        token: token,
        createdAt: json['created_at'] as String?,
      );

  bool get isOwner => type == 'owner';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'cafe_id': cafeId,
        'cafe': cafeName == null ? null : {'name': cafeName},
        'status': status,
        'type': type,
        'avatar': avatar,
        'token': token,
        'created_at': createdAt,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        email,
        cafeId,
        cafeName,
        status,
        type,
        avatar,
        token,
        createdAt
      ];
}
