import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/menu_item_entity.dart';
import 'image_picker_circle.dart';

/// Add/edit bottom sheet for a menu item — a photo (optional), a name and
/// a price.
class MenuItemFormSheet extends StatefulWidget {
  const MenuItemFormSheet({
    super.key,
    this.item,
    required this.onSubmit,
  });

  /// `null` when adding a new item, otherwise the one being edited.
  final MenuItemEntity? item;
  final void Function(String name, double price, String? imagePath) onSubmit;

  static Future<void> show(
    BuildContext context, {
    MenuItemEntity? item,
    required void Function(String name, double price, String? imagePath)
        onSubmit,
  }) {
    return AppBottomSheet.show(
      context,
      title: item == null
          ? LocaleKeys.items_addItem.tr()
          : LocaleKeys.items_editItem.tr(),
      child: MenuItemFormSheet(item: item, onSubmit: onSubmit),
    );
  }

  @override
  State<MenuItemFormSheet> createState() => _MenuItemFormSheetState();
}

class _MenuItemFormSheetState extends State<MenuItemFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.item?.name ?? '');
    _priceCtrl = TextEditingController(
      text: widget.item != null ? widget.item!.price.toStringAsFixed(0) : '',
    );
    _imagePath = widget.item?.imagePath;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final price = double.parse(_priceCtrl.text.trim());
    Navigator.pop(context);
    widget.onSubmit(_nameCtrl.text.trim(), price, _imagePath);
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
              folder: 'item_images',
              onChanged: (path) => setState(() => _imagePath = path),
            ),
          ),
          20.height,
          CustomTextField(
            controller: _nameCtrl,
            hint: LocaleKeys.items_itemNameHint.tr(),
            validator: (value) => (value == null || value.trim().isEmpty)
                ? LocaleKeys.validation_required.tr()
                : null,
          ),
          14.height,
          CustomTextField(
            controller: _priceCtrl,
            hint: LocaleKeys.items_itemPriceHint.tr(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            validator: (value) {
              final price = double.tryParse((value ?? '').trim());
              if (price == null || price <= 0) {
                return LocaleKeys.items_priceInvalid.tr();
              }
              return null;
            },
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
