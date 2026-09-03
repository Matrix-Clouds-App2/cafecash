part of 'subscription_cubit.dart';

sealed class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

final class SubscriptionInitial extends SubscriptionState {
  const SubscriptionInitial();
}

final class SubscriptionLoading extends SubscriptionState {
  const SubscriptionLoading();
}

final class SubscriptionLoaded extends SubscriptionState {
  final SubscriptionModel? subscription;
  final List<SubscriptionPlanModel> plans;
  final bool mutating;

  const SubscriptionLoaded({
    required this.subscription,
    required this.plans,
    this.mutating = false,
  });

  SubscriptionLoaded copyWith({
    SubscriptionModel? subscription,
    List<SubscriptionPlanModel>? plans,
    bool? mutating,
  }) =>
      SubscriptionLoaded(
        subscription: subscription ?? this.subscription,
        plans: plans ?? this.plans,
        mutating: mutating ?? this.mutating,
      );

  @override
  List<Object?> get props => [subscription, plans, mutating];
}

final class SubscriptionError extends SubscriptionState {
  final String message;

  const SubscriptionError(this.message);

  @override
  List<Object?> get props => [message];
}
