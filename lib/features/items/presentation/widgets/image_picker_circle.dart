import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/local_image_picker.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../../../core/widgets/image/custom_image.dart';
import '../../../../core/widgets/image_source_sheet.dart';

/// Circular photo picker used by the category/item forms. Tapping it opens
/// [ImageSourceSheet] (camera/gallery), then picks + compresses + saves the
/// photo via [LocalImagePicker] and reports the new path back through
/// [onChanged]. Picking a photo is optional — leaving it empty just shows a
/// placeholder icon.
class ImagePickerCircle extends StatelessWidget {
  const ImagePickerCircle({
    super.key,
    required this.imagePath,
    required this.folder,
    required this.onChanged,
    this.size = 96,
  });

  final String? imagePath;

  /// Sub-folder under the app's documents directory the photo gets saved
  /// into (e.g. `category_images` vs `item_images`).
  final String folder;
  final ValueChanged<String?> onChanged;
  final double size;

  Future<void> _pick(BuildContext context) async {
    final source = await ImageSourceSheet.show(context);
    if (source == null) return;
    final savedPath =
        await LocalImagePicker.pickAndSave(source: source, folder: folder);
    if (savedPath != null) onChanged(savedPath);
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final hasImage = imagePath != null && imagePath!.isNotEmpty;
    final circleSize = size.r;

    return CustomTapEffect(
      onTap: () => _pick(context),
      child: Container(
        width: circleSize,
        height: circleSize,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: primary.withValues(alpha: 0.08),
          border: Border.all(
            color: primary.withValues(alpha: hasImage ? 0.35 : 0.6),
            width: 1.4,
          ),
        ),
        child: hasImage
            ? Stack(
                fit: StackFit.expand,
                children: [
                  CustomImage(image: imagePath!, fit: BoxFit.cover),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.4),
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      alignment: Alignment.center,
                      child: Icon(Icons.edit_rounded,
                          color: Colors.white, size: 14.sp),
                    ),
                  ),
                ],
              )
            : Icon(Icons.add_a_photo_outlined,
                color: primary, size: circleSize * 0.32),
      ),
    );
  }
}
