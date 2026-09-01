import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import '../utils/locale_keys.dart';
import 'app_bottom_sheet.dart';
import 'custom_tap_effect.dart';
import 'sheet_option_tile.dart';

class ManageOptionsSheet {
  ManageOptionsSheet._();

  static Future<void> show(
    BuildContext context, {
    required String title,
    required VoidCallback onEdit,
    VoidCallback? onDelete,
    String? extraLabel,
    IconData? extraIcon,
    VoidCallback? onExtra,
  }) {
    return AppBottomSheet.show(
      context,
      title: title,
      child: _ManageOptions(
        onEdit: onEdit,
        onDelete: onDelete,
        extraLabel: extraLabel,
        extraIcon: extraIcon,
        onExtra: onExtra,
      ),
    );
  }
}

class _ManageOptions extends StatelessWidget {
  const _ManageOptions({
    required this.onEdit,
    this.onDelete,
    this.extraLabel,
    this.extraIcon,
    this.onExtra,
  });

  final VoidCallback onEdit;
  final VoidCallback? onDelete;
  final String? extraLabel;
  final IconData? extraIcon;
  final VoidCallback? onExtra;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onExtra != null && extraLabel != null && extraIcon != null) ...[
          CustomTapEffect(
            onTap: () {
              Navigator.pop(context);
              onExtra!();
            },
            child: SheetOptionTile(
              icon: extraIcon!,
              label: extraLabel!,
              color: primary,
            ),
          ),
          10.height,
        ],
        CustomTapEffect(
          onTap: () {
            Navigator.pop(context);
            onEdit();
          },
          child: SheetOptionTile(
            icon: Icons.edit_outlined,
            label: LocaleKeys.common_edit.tr(),
            color: primary,
          ),
        ),
        if (onDelete != null) ...[
          10.height,
          CustomTapEffect(
            onTap: () {
              Navigator.pop(context);
              onDelete!();
            },
            child: SheetOptionTile(
              icon: Icons.delete_outline_rounded,
              label: LocaleKeys.common_delete.tr(),
              color: Colors.white,
              labelColor: Colors.red,
            ),
          ),
        ],
      ],
    );
  }
}
