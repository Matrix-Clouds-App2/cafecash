import 'object_box/entities/pending_deletion_entity.dart';
import 'object_box/local_box.dart';
import 'object_box/object_box_storage.dart';

class PendingDeletionRepo {
  PendingDeletionRepo({required ObjectBoxStorage storage})
      : _box = storage.box<PendingDeletionEntity>();

  final LocalBox<PendingDeletionEntity> _box;

  void add(String entityUuid, PendingDeletionType type) {
    _box.put(PendingDeletionEntity(
      entityUuid: entityUuid,
      entityType: type.index,
      createdAt: DateTime.now(),
    ));
  }

  List<PendingDeletionEntity> getAll() => _box.getAll();

  List<PendingDeletionEntity> getByType(PendingDeletionType type) =>
      getAll().where((e) => e.entityTypeEnum == type).toList();

  void removeMany(List<int> ids) => _box.removeMany(ids);
}
