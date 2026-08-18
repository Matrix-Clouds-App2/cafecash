import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import '../utils/locale_keys.dart';
import 'app_bottom_sheet.dart';
import 'custom_tap_effect.dart';
import 'sheet_option_tile.dart';

/// Bottom sheet asking whether a photo should come from the camera or the
/// gallery. Resolves to the chosen [ImageSource], or `null` if dismissed.
class ImageSourceSheet {
  ImageSourceSheet._();

  static Future<ImageSource?> show(BuildContext context) {
    return AppBottomSheet.show<ImageSource>(
      context,
      title: LocaleKeys.items_chooseImage.tr(),
      child: const _ImageSourceOptions(),
    );
  }
}

class _ImageSourceOptions extends StatelessWidget {
  const _ImageSourceOptions();

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTapEffect(
          onTap: () => Navigator.pop(context, ImageSource.camera),
          child: SheetOptionTile(
            icon: Icons.photo_camera_outlined,
            label: LocaleKeys.items_pickFromCamera.tr(),
            color: primary,
          ),
        ),
        10.height,
        CustomTapEffect(
          onTap: () => Navigator.pop(context, ImageSource.gallery),
          child: SheetOptionTile(
            icon: Icons.photo_library_outlined,
            label: LocaleKeys.items_pickFromGallery.tr(),
            color: primary,
          ),
        ),
      ],
    );
  }
}
