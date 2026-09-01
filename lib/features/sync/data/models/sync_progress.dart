import 'package:equatable/equatable.dart';

enum SyncPhase {
  preparing,
  compressing,
  zippingImages,
  uploading,
  downloading,
  merging,
}

class SyncProgress extends Equatable {
  const SyncProgress({
    required this.phase,
    this.current = 0,
    this.total = 0,
    this.eta,
  });

  final SyncPhase phase;
  final int current;
  final int total;
  final Duration? eta;

  bool get isDeterminate =>
      (phase == SyncPhase.uploading || phase == SyncPhase.downloading) &&
      total > 0;

  double get fraction => total <= 0 ? 0 : (current / total).clamp(0, 1);

  @override
  List<Object?> get props => [phase, current, total, eta];
}
