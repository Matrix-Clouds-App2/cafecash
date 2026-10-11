import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/storage/local_storage.dart';
import '../../../core/utils/locale_keys.dart';

part 'labels_state.dart';

class LabelsCubit extends Cubit<LabelsState> {
  LabelsCubit(this._storage)
      : super(LabelsState(
          hallLabel: _storage.getHallLabel(),
          matchesLabel: _storage.getMatchesLabel(),
        ));

  final LocalStorage _storage;

  Future<void> updateHallLabel(String? label) async {
    final value = _normalize(label);
    await _storage.setHallLabel(value);
    emit(LabelsState(hallLabel: value, matchesLabel: state.matchesLabel));
  }

  Future<void> updateMatchesLabel(String? label) async {
    final value = _normalize(label);
    await _storage.setMatchesLabel(value);
    emit(LabelsState(hallLabel: state.hallLabel, matchesLabel: value));
  }

  String? _normalize(String? label) {
    final trimmed = label?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}
