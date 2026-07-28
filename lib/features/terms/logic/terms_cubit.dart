import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/terms_repo.dart';
import 'terms_state.dart';

class TermsCubit extends Cubit<TermsState> {
  TermsCubit(this._repo) : super(TermsInitial());

  final TermsRepo _repo;

  Future<void> loadTerms() async {
    emit(TermsLoading());
    try {
      final content = await _repo.fetchTerms();
      emit(TermsSuccess(content));
    } catch (e) {
      emit(TermsError(e.toString()));
    }
  }
}
