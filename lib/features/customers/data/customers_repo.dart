import '../../../core/storage/object_box/local_box.dart';
import '../../../core/storage/object_box/object_box_storage.dart';
import 'models/customer_entity.dart';

class CustomersRepo {
  CustomersRepo({required ObjectBoxStorage storage})
      : _box = storage.box<CustomerEntity>();

  final LocalBox<CustomerEntity> _box;

  List<CustomerEntity> getAll() => _box.getAll();

  Stream<List<CustomerEntity>> watchAll() => _box.watchAll();

  bool phoneExists(String phone, {int? excludingId}) {
    final trimmed = phone.trim();
    return _box.getAll().any(
        (customer) => customer.phone == trimmed && customer.id != excludingId);
  }

  CustomerEntity add({required String name, required String phone}) {
    final customer = CustomerEntity(
      name: name,
      phone: phone,
      createdAt: DateTime.now(),
    );
    customer.id = _box.put(customer);
    return customer;
  }

  void update(CustomerEntity customer) => _box.put(customer);

  void delete(CustomerEntity customer) => _box.remove(customer.id);
}
