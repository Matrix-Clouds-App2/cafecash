import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../data/models/subscription_model.dart';
import '../data/models/subscription_plan_model.dart';
import '../data/subscription_repo.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit(this._repo) : super(const SubscriptionInitial());

  final SubscriptionRepo _repo;

  Future<void> load() async {
    if (state is! SubscriptionLoaded) {
      final seed = kUserModel?.subscription;
      emit(seed != null
          ? SubscriptionLoaded(subscription: seed, plans: const [])
          : const SubscriptionLoading());
    }

    try {
      final plans = await _repo.getPlans();
      final subscription = await _repo.getCurrentSubscription();
      kUserModel = kUserModel?.copyWith(subscription: subscription);
      emit(SubscriptionLoaded(subscription: subscription, plans: plans));
    } catch (e) {
      if (state is SubscriptionLoaded) {
        AppOverlay.showError(_message(e));
      } else {
        emit(SubscriptionError(_message(e)));
      }
    }
  }

  Future<void> refresh() => load();

  Future<void> activate({required String planCode, String? notes}) => _mutate(
        (cafeId) =>
            _repo.activate(cafeId: cafeId, planCode: planCode, notes: notes),
        successMessage: LocaleKeys.subscription_activatedSuccess.tr(),
      );

  Future<void> renew({required String planCode, String? notes}) => _mutate(
        (cafeId) =>
            _repo.renew(cafeId: cafeId, planCode: planCode, notes: notes),
        successMessage: LocaleKeys.subscription_renewedSuccess.tr(),
      );

  Future<void> changePlan({
    required String planCode,
    required String effectiveMode,
    String? notes,
  }) =>
      _mutate(
        (cafeId) => _repo.changePlan(
          cafeId: cafeId,
          planCode: planCode,
          effectiveMode: effectiveMode,
          notes: notes,
        ),
        successMessage: LocaleKeys.subscription_changedSuccess.tr(),
      );

  Future<void> _mutate(
    Future<SubscriptionModel?> Function(int cafeId) action, {
    required String successMessage,
  }) async {
    final current = state;
    if (current is! SubscriptionLoaded) return;

    final cafeId = kUserModel?.cafeId;
    if (cafeId == null) {
      AppOverlay.showError(LocaleKeys.subscription_errorLoad.tr());
      return;
    }

    emit(current.copyWith(mutating: true));
    try {
      final subscription = await action(cafeId);
      kUserModel = kUserModel?.copyWith(subscription: subscription);
      emit(
          SubscriptionLoaded(subscription: subscription, plans: current.plans));
      AppOverlay.showSuccess(successMessage);
      await load();
    } catch (e) {
      AppOverlay.showError(_message(e));
      emit(current.copyWith(mutating: false));
    }
  }

  String _message(Object e) => e is NetworkException ? e.message : e.toString();
}
