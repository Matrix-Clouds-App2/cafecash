import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Picks a photo from the camera/gallery, compresses + resizes it, and
/// copies it into the app's own persistent storage — so records that
/// reference it (e.g. `CategoryEntity.imagePath`) only ever store a small
/// file path, never raw image bytes, keeping the local database light and
/// low-end phones happy.
class LocalImagePicker {
  LocalImagePicker._();

  static final ImagePicker _picker = ImagePicker();

  // Resizing + JPEG-quality compression happens right at pick time (native
  // side), before the image ever touches app memory or disk.
  static const double _maxDimension = 1024;
  static const int _quality = 70;

  /// Picks an image from [source], compresses it, and saves a copy under
  /// `<app documents>/[folder]/`. Returns the saved file's path, or `null`
  /// if the user cancelled the picker.
  static Future<String?> pickAndSave({
    required ImageSource source,
    required String folder,
  }) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: _maxDimension,
      maxHeight: _maxDimension,
      imageQuality: _quality,
    );
    if (picked == null) return null;

    final docsDir = await getApplicationDocumentsDirectory();
    final targetDir = Directory('${docsDir.path}/$folder');
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    final ext = picked.path.split('.').last;
    final fileName = '${DateTime.now().microsecondsSinceEpoch}.$ext';
    final saved = await File(picked.path).copy('${targetDir.path}/$fileName');
    return saved.path;
  }

  /// Deletes a previously saved image file, if it's still there. Safe to
  /// call with `null`/empty paths or a file that's already gone — used
  /// whenever a photo gets replaced or its owning record gets deleted, so
  /// storage doesn't quietly fill up with orphaned files.
  static Future<void> deleteIfExists(String? path) async {
    if (path == null || path.isEmpty) return;
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
