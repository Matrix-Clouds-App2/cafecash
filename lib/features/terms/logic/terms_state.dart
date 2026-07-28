import 'package:equatable/equatable.dart';

sealed class TermsState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class TermsInitial extends TermsState {}

final class TermsLoading extends TermsState {}

final class TermsSuccess extends TermsState {
  final String content;
  TermsSuccess(this.content);

  @override
  List<Object?> get props => [content];
}

final class TermsError extends TermsState {
  final String message;
  TermsError(this.message);

  @override
  List<Object?> get props => [message];
}
