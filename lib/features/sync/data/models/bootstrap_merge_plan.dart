import 'bootstrap_snapshot.dart';

enum BootstrapConflictKind { category, menuItem, customer }

enum BootstrapConflictChoice { takeServer, keepLocal }

class BootstrapConflictField {
  const BootstrapConflictField({
    required this.label,
    required this.localValue,
    required this.serverValue,
  });

  final String label;
  final String localValue;
  final String serverValue;
}

class BootstrapConflict {
  const BootstrapConflict({
    required this.kind,
    required this.uuid,
    required this.title,
    required this.fields,
    this.localImage,
    this.serverImage,
    this.deletedOnServer = false,
  });

  final BootstrapConflictKind kind;
  final String uuid;
  final String title;
  final List<BootstrapConflictField> fields;
  final String? localImage;
  final String? serverImage;
  final bool deletedOnServer;
}

class BootstrapMergePlan {
  const BootstrapMergePlan({
    required this.snapshot,
    required this.conflicts,
  });

  final BootstrapSnapshot snapshot;
  final List<BootstrapConflict> conflicts;

  bool get hasConflicts => conflicts.isNotEmpty;
}

class BootstrapMergeResult {
  const BootstrapMergeResult({
    this.categoriesUpserted = 0,
    this.menuItemsUpserted = 0,
    this.customersUpserted = 0,
    this.rowsDeleted = 0,
    this.ordersImported = 0,
    this.treasuryImported = 0,
    this.conflictsResolved = 0,
  });

  final int categoriesUpserted;
  final int menuItemsUpserted;
  final int customersUpserted;
  final int rowsDeleted;
  final int ordersImported;
  final int treasuryImported;
  final int conflictsResolved;
}
