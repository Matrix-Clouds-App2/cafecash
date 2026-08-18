import 'package:objectbox/objectbox.dart';

class LocalBox<T> {
  LocalBox(this._box);

  final Box<T> _box;

  T? getById(int id) => _box.get(id);

  List<T> getAll() => _box.getAll();

  int put(T object) => _box.put(object);

  List<int> putMany(List<T> objects) => _box.putMany(objects);

  bool remove(int id) => _box.remove(id);

  int removeMany(List<int> ids) => _box.removeMany(ids);

  int removeAll() => _box.removeAll();

  int get count => _box.count();

  bool get isEmpty => _box.isEmpty();

  Query<T> query([Condition<T>? condition]) =>
      condition == null ? _box.query().build() : _box.query(condition).build();

  Stream<List<T>> watchAll() =>
      _box.query().watch(triggerImmediately: true).map((q) => q.find());

  Stream<List<T>> watchQuery(Condition<T> condition) => _box
      .query(condition)
      .watch(triggerImmediately: true)
      .map((q) => q.find());
}
