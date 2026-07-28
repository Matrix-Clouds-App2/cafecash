import 'package:coffee_shop/core/extensions/extensions.dart';
import 'package:coffee_shop/core/utils/app_colors.dart';
import 'package:coffee_shop/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Data model for a single participant / delegation member.
class ParticipantModel {
  const ParticipantModel({
    this.id = 0,
    required this.name,
    required this.title,
    this.imagePath,
    this.imageUrl,
    this.isPresident = false,
  });

  final int id;
  final String name;

  /// Display title — maps to `position` in the API response.
  final String title;

  /// Local asset path (used for static/placeholder data).
  final String? imagePath;

  /// Network image URL returned by the API.
  final String? imageUrl;

  /// Whether this member is the head of the delegation.
  final bool isPresident;

  factory ParticipantModel.fromJson(Map<String, dynamic> json) =>
      ParticipantModel(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String,
        title: json['position'] as String? ?? '',
        imageUrl: json['image'] as String?,
        isPresident: json['is_president'] as bool? ?? false,
      );
}

/// A compact vertical card showing a circular participant photo,
/// their name, and their title.
class HomeParticipantCard extends StatelessWidget {
  const HomeParticipantCard({super.key, required this.participant});

  final ParticipantModel participant;

  @override
  Widget build(BuildContext context) {
    final gold = AppColors.accentGold.themeColor;
    final primary = AppColors.primaryColor.themeColor;

    return Container(
      margin: 5.paddingHorizontal+5.paddingVert,
      height: 150.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(1, 3),
          ),
        ],
      ),
      padding: 5.paddingHorizontal+10.paddingVert,
      child: Column(
        children: [
          // ── Avatar ────────────────────────────────────────────────────
          Container(
            width: 72.r,
            height: 72.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: gold, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: ParticipantAvatar(
                imageUrl: participant.imageUrl,
                imagePath: participant.imagePath,
                primary: primary,
                size: 72,
              ),
            ),
          ),
          8.verticalSpace,

          // ── Name ──────────────────────────────────────────────────────
          SizedBox(
            width: 88.w,
            child: AppText(
              participant.name,
              fontSize: 8.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF17212B),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          4.verticalSpace,

          // ── Title ─────────────────────────────────────────────────────
          SizedBox(
            width: 88.w,
            child: AppText(
              participant.title,
              fontSize: 8.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondaryColor.themeColor,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Shared avatar widget — renders a network image, asset image, or placeholder.
class ParticipantAvatar extends StatelessWidget {
  const ParticipantAvatar({super.key, 
    required this.imageUrl,
    required this.imagePath,
    required this.primary,
    required this.size,
  });

  final String? imageUrl;
  final String? imagePath;
  final Color primary;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        width: size.r,
        height: size.r,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    if (imagePath != null) {
      return Image.asset(imagePath!, fit: BoxFit.cover);
    }
    return _placeholder();
  }

  Widget _placeholder() => Container(
        color: primary.withValues(alpha: 0.10),
        child: Icon(
          Icons.person,
          size: (size * 0.5).r,
          color: primary.withValues(alpha: 0.50),
        ),
      );
}
