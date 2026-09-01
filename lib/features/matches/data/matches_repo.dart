import 'package:uuid/uuid.dart';

import '../../../core/storage/object_box/local_box.dart';
import '../../../core/storage/object_box/object_box_storage.dart';
import 'models/match_seat_entity.dart';

class MatchesRepo {
  MatchesRepo({required ObjectBoxStorage storage})
      : _box = storage.box<MatchSeatEntity>();

  final LocalBox<MatchSeatEntity> _box;

  List<MatchSeatEntity> getSeats() {
    final seats = _box.getAll();
    seats.sort((a, b) => a.number.compareTo(b.number));
    return seats;
  }

  Stream<List<MatchSeatEntity>> watchSeats() => _box
      .watchAll()
      .map((seats) => seats..sort((a, b) => a.number.compareTo(b.number)));

  MatchSeatEntity addSeat() {
    final seats = _box.getAll();
    final nextNumber = seats.isEmpty
        ? 1
        : seats.map((s) => s.number).reduce((a, b) => a > b ? a : b) + 1;
    final seat = MatchSeatEntity(number: nextNumber, uuid: const Uuid().v4());
    seat.id = _box.put(seat);
    return seat;
  }

  void setStatus(int id, MatchSeatStatus status) {
    final seat = _box.getById(id);
    if (seat == null) return;
    seat.statusEnum = status;
    _box.put(seat);
  }

  void deleteSeat(int id) {
    _box.remove(id);
  }

  void syncOrderSummary({
    required int seatId,
    required MatchSeatStatus status,
    int drinkCount = 0,
    double price = 0,
    String? customerName,
  }) {
    final seat = _box.getById(seatId);
    if (seat == null) return;
    seat
      ..statusEnum = status
      ..drinkCount = drinkCount
      ..price = price
      ..customerName = customerName;
    _box.put(seat);
  }
}
