import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/contact_us_repo.dart';
import 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  ContactUsCubit(this._repo) : super(ContactUsInitial());

  final ContactUsRepo _repo;

  Future<void> send({
    required String name,
    required String email,
    required String phone,
    required String message,
  }) async {
    emit(ContactUsLoading());
    try {
      await _repo.send(
        name: name,
        email: email,
        phone: phone,
        message: message,
      );
      emit(ContactUsSuccess());
    } catch (e) {
      emit(ContactUsError(e.toString()));
    }
  }
}
