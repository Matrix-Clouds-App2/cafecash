import '../data/models/shift_entity.dart';

class ShiftWindow {
  ShiftWindow._();

  static bool contains(ShiftEntity shift, DateTime? at) {
    final end = shift.closedAt ?? DateTime.now();
    final start = shift.startedAt ?? end;
    return at != null && !at.isBefore(start) && !at.isAfter(end);
  }
}
