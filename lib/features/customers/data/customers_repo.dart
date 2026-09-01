import 'package:uuid/uuid.dart';

import '../../../core/storage/object_box/entities/pending_deletion_entity.dart';
import '../../../core/storage/object_box/local_box.dart';
import '../../../core/storage/object_box/object_box_storage.dart';
import '../../../core/storage/pending_deletion_repo.dart';
import 'models/customer_entity.dart';

class CustomersRepo {
  CustomersRepo({
    required ObjectBoxStorage storage,
    required PendingDeletionRepo pendingDeletionRepo,
  })  : _box = storage.box<CustomerEntity>(),
        _pendingDeletionRepo = pendingDeletionRepo;

  final LocalBox<CustomerEntity> _box;
  final PendingDeletionRepo _pendingDeletionRepo;

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
      uuid: const Uuid().v4(),
    );
    customer.id = _box.put(customer);
    return customer;
  }

  void update(CustomerEntity customer) {
    customer.synced = false;
    _box.put(customer);
  }

  void delete(CustomerEntity customer) {
    if (customer.synced) {
      _pendingDeletionRepo.add(customer.uuid, PendingDeletionType.customer);
    }
    _box.remove(customer.id);
  }

  void markSynced(List<CustomerEntity> customers) {
    if (customers.isEmpty) return;
    for (final customer in customers) {
      customer.synced = true;
    }
    _box.putMany(customers);
  }
}
