class SyncUploadResult {
  const SyncUploadResult({
    required this.syncUuid,
    required this.shiftUuid,
    required this.duplicate,
  });

  final String? syncUuid;
  final String? shiftUuid;
  final bool duplicate;

  factory SyncUploadResult.fromJson(Map<String, dynamic> json) =>
      SyncUploadResult(
        syncUuid: json['sync_uuid'] as String?,
        shiftUuid: json['shift_uuid'] as String?,
        duplicate: json['duplicate'] as bool? ?? false,
      );
}
