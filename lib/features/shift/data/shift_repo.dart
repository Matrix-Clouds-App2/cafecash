import '../../../core/storage/object_box/local_box.dart';
import '../../../core/storage/object_box/object_box_storage.dart';
import 'models/shift_entity.dart';

class ShiftRepo {
  ShiftRepo({required ObjectBoxStorage storage})
      : _box = storage.box<ShiftEntity>();

  final LocalBox<ShiftEntity> _box;

  ShiftEntity? getActiveShift() {
    final all = _box.getAll();
    for (final shift in all) {
      if (shift.statusEnum == ShiftStatus.open) return shift;
    }
    return null;
  }

  Stream<ShiftEntity?> watchActiveShift() => _box.watchAll().map((all) {
        for (final shift in all) {
          if (shift.statusEnum == ShiftStatus.open) return shift;
        }
        return null;
      });

  List<ShiftEntity> getHistory() => _historyFrom(_box.getAll());

  Stream<List<ShiftEntity>> watchHistory() => _box.watchAll().map(_historyFrom);

  List<ShiftEntity> _historyFrom(List<ShiftEntity> all) {
    final closed =
        all.where((shift) => shift.statusEnum == ShiftStatus.closed).toList();
    closed.sort((a, b) =>
        (b.closedAt ?? DateTime(0)).compareTo(a.closedAt ?? DateTime(0)));
    return closed;
  }

  ShiftEntity startShift({required double openingBalance}) {
    final active = getActiveShift();
    if (active != null) return active;

    final shift = ShiftEntity(
      openingBalance: openingBalance,
      startedAt: DateTime.now(),
    );
    shift.id = _box.put(shift);
    return shift;
  }

  void closeShift(ShiftEntity shift, {required double closingBalance}) {
    shift
      ..statusEnum = ShiftStatus.closed
      ..closedAt = DateTime.now()
      ..closingBalance = closingBalance;
    _box.put(shift);
  }
}
