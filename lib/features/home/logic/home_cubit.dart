import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/home_repo.dart';
import '../data/models/home_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repo) : super(const HomeInitial());

  final HomeRepo _repo;

  Future<void> loadHome() async {
    emit(const HomeLoading());
    try {
      final home = await _repo.fetchHome();
      emit(HomeSuccess(home: home));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(HomeError(msg));
    }
  }
}
