import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../shift/data/models/shift_entity.dart';
import '../data/models/bootstrap_merge_plan.dart';
import '../data/models/sync_progress.dart';
import '../data/models/sync_upload_result.dart';
import '../data/sync_repo.dart';

part 'sync_state.dart';

class SyncCubit extends Cubit<SyncState> {
  SyncCubit(this._repo) : super(const SyncIdle());

  final SyncRepo _repo;

  Future<void> uploadShift(ShiftEntity shift) async {
    emit(const SyncRunning(SyncProgress(phase: SyncPhase.preparing)));
    try {
      final result = await _repo.uploadShift(
        shift,
        onProgress: (progress) => emit(SyncRunning(progress)),
      );
      emit(SyncSuccess(uploadResult: result));
    } on NetworkException catch (e) {
      emit(SyncFailure(e.message));
    } catch (e) {
      emit(SyncFailure(e.toString()));
    }
  }

  Future<void> pullBootstrap() async {
    emit(const SyncRunning(SyncProgress(phase: SyncPhase.downloading)));
    try {
      final snapshot = await _repo.downloadBootstrap(
        onProgress: (progress) => emit(SyncRunning(progress)),
      );
      final plan = _repo.planBootstrap(snapshot);
      if (plan.hasConflicts) {
        emit(SyncBootstrapNeedsResolution(plan));
        return;
      }
      emit(const SyncRunning(SyncProgress(phase: SyncPhase.merging)));
      await _repo.applyBootstrap(plan, const {});
      emit(const SyncSuccess());
    } on NetworkException catch (e) {
      emit(SyncFailure(e.message));
    } catch (e) {
      emit(SyncFailure(e.toString()));
    }
  }

  Future<void> hydrateShift(ShiftEntity shift) async {
    emit(const SyncRunning(SyncProgress(phase: SyncPhase.downloading)));
    try {
      await _repo.hydrateShift(shift);
      emit(const SyncSuccess());
    } on NetworkException catch (e) {
      emit(SyncFailure(e.message));
    } catch (e) {
      emit(SyncFailure(e.toString()));
    }
  }

  Future<void> applyBootstrapResolution(
    BootstrapMergePlan plan,
    Map<String, BootstrapConflictChoice> choices,
  ) async {
    emit(const SyncRunning(SyncProgress(phase: SyncPhase.merging)));
    try {
      await _repo.applyBootstrap(plan, choices);
      emit(const SyncSuccess());
    } on NetworkException catch (e) {
      emit(SyncFailure(e.message));
    } catch (e) {
      emit(SyncFailure(e.toString()));
    }
  }
}
