import 'package:equatable/equatable.dart';

sealed class ContactUsState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ContactUsInitial extends ContactUsState {}

final class ContactUsLoading extends ContactUsState {}

final class ContactUsSuccess extends ContactUsState {}

final class ContactUsError extends ContactUsState {
  final String message;
  ContactUsError(this.message);

  @override
  List<Object?> get props => [message];
}
