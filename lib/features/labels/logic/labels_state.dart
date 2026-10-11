part of 'labels_cubit.dart';

class LabelsState extends Equatable {
  const LabelsState({this.hallLabel, this.matchesLabel});

  final String? hallLabel;
  final String? matchesLabel;

  String get hallDisplayLabel => hallLabel ?? LocaleKeys.nav_hall.tr();
  String get matchesDisplayLabel => matchesLabel ?? LocaleKeys.nav_matches.tr();

  @override
  List<Object?> get props => [hallLabel, matchesLabel];
}
