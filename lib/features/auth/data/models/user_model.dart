import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String? token;
  final String? createdAt;
  final String? countryCode;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.countryCode,
    this.avatar,
    this.token,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] ?? json['phone_number']??'',
        avatar: json['photo'] as String?,
        countryCode: json['country_code'] as String?,
        token: json['token'] as String?,
        createdAt: json['created_at'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'avatar': avatar,
        'token': token,
        'created_at': createdAt,
      };

  @override
  List<Object?> get props => [id, name, email, phone, avatar, token, createdAt];
}
