part of 'sync_cubit.dart';

sealed class SyncState extends Equatable {
  const SyncState();

  @override
  List<Object?> get props => [];
}

final class SyncIdle extends SyncState {
  const SyncIdle();
}

final class SyncRunning extends SyncState {
  const SyncRunning(this.progress);

  final SyncProgress progress;

  @override
  List<Object?> get props => [progress];
}

final class SyncBootstrapNeedsResolution extends SyncState {
  const SyncBootstrapNeedsResolution(this.plan);

  final BootstrapMergePlan plan;

  @override
  List<Object?> get props => [plan.conflicts.length];
}

final class SyncSuccess extends SyncState {
  const SyncSuccess({this.uploadResult});

  final SyncUploadResult? uploadResult;

  @override
  List<Object?> get props => [uploadResult];
}

final class SyncFailure extends SyncState {
  const SyncFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
