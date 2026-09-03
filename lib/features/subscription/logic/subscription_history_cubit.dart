import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/locale_keys.dart';
import '../data/models/subscription_model.dart';
import '../data/subscription_repo.dart';

part 'subscription_history_state.dart';

class SubscriptionHistoryCubit extends Cubit<SubscriptionHistoryState> {
  SubscriptionHistoryCubit(this._repo)
      : super(const SubscriptionHistoryInitial());

  final SubscriptionRepo _repo;

  Future<void> load() async {
    emit(const SubscriptionHistoryLoading());

    final cafeId = kUserModel?.cafeId;
    if (cafeId == null) {
      emit(SubscriptionHistoryError(LocaleKeys.subscription_errorLoad.tr()));
      return;
    }

    try {
      final entries = await _repo.getHistory(cafeId);
      emit(SubscriptionHistoryLoaded(entries));
    } catch (e) {
      final message = e is NetworkException ? e.message : e.toString();
      emit(SubscriptionHistoryError(message));
    }
  }
}
