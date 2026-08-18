import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/category_entity.dart';
import 'image_picker_circle.dart';

/// Add/edit bottom sheet for a category — a photo (optional) plus a name.
class CategoryFormSheet extends StatefulWidget {
  const CategoryFormSheet({
    super.key,
    this.category,
    required this.onSubmit,
  });

  /// `null` when adding a new category, otherwise the one being edited.
  final CategoryEntity? category;
  final void Function(String name, String? imagePath) onSubmit;

  static Future<void> show(
    BuildContext context, {
    CategoryEntity? category,
    required void Function(String name, String? imagePath) onSubmit,
  }) {
    return AppBottomSheet.show(
      context,
      title: category == null
          ? LocaleKeys.items_addCategory.tr()
          : LocaleKeys.items_editCategory.tr(),
      child: CategoryFormSheet(category: category, onSubmit: onSubmit),
    );
  }

  @override
  State<CategoryFormSheet> createState() => _CategoryFormSheetState();
}

class _CategoryFormSheetState extends State<CategoryFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.category?.name ?? '');
    _imagePath = widget.category?.imagePath;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context);
    widget.onSubmit(_nameCtrl.text.trim(), _imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: ImagePickerCircle(
              imagePath: _imagePath,
              folder: 'category_images',
              onChanged: (path) => setState(() => _imagePath = path),
            ),
          ),
          20.height,
          CustomTextField(
            controller: _nameCtrl,
            hint: LocaleKeys.items_categoryNameHint.tr(),
            validator: (value) => (value == null || value.trim().isEmpty)
                ? LocaleKeys.validation_required.tr()
                : null,
          ),
          24.height,
          CustomButton(
            title: LocaleKeys.common_save.tr(),
            onTap: _submit,
          ),
        ],
      ),
    );
  }
}
