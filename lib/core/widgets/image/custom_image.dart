import 'dart:io';

import 'package:app_base/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';

import '../../utils/app_images.dart';

class CustomImage extends StatelessWidget {
  const CustomImage(
      {super.key,
      required this.image,
      this.radius,
      this.fit,
      this.width,
      this.height});

  /// A network URL, a bundled asset path (default seed catalog images, e.g.
  /// `assets/images/seed_items/tea.png`), or a local file path (e.g. images
  /// saved by `LocalImagePicker`) — detected automatically. `.svg` paths are
  /// rendered as vectors.
  final String image;
  final double? radius;
  final double? width;
  final double? height;
  final BoxFit? fit;

  bool get _isNetwork =>
      image.startsWith('http://') || image.startsWith('https://');

  bool get _isAsset => image.startsWith('assets/');

  bool get _isSvg => image.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    final holder = ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: Image.asset(AppImages.holder, fit: BoxFit.cover),
    );

    Widget child;
    if (_isSvg && _isAsset) {
      child = SvgPicture.asset(
        image,
        fit: fit ?? BoxFit.cover,
        placeholderBuilder: (context) => holder,
      );
    } else if (_isSvg) {
      child = SvgPicture.file(
        File(image),
        fit: fit ?? BoxFit.cover,
        placeholderBuilder: (context) => holder,
      );
    } else if (_isNetwork) {
      child = Image.network(
        image,
        fit: fit ?? BoxFit.cover,
        errorBuilder: (context, error, v) => holder,
      );
    } else if (_isAsset) {
      child = Image.asset(
        image,
        fit: fit ?? BoxFit.cover,
        errorBuilder: (context, error, v) => holder,
      );
    } else {
      child = Image.file(
        File(image),
        fit: fit ?? BoxFit.cover,
        errorBuilder: (context, error, v) => holder,
      );
    }

    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 0),
        child: child,
      ),
    );
  }
}

class CustomImageOnlyRadius extends StatelessWidget {
  const CustomImageOnlyRadius(
      {super.key,
      required this.image,
      this.fit,
      this.width,
      this.height,
      this.topRightRadius,
      this.bottomRightRadius,
      this.topLeftRadius,
      this.bottomLeftRadius});
  final String image;
  final double? topRightRadius;
  final double? bottomRightRadius;
  final double? topLeftRadius;
  final double? bottomLeftRadius;
  final double? width;
  final double? height;
  final BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topLeftRadius ?? 0),
            topRight: Radius.circular(topRightRadius ?? 0),
            bottomRight: Radius.circular(bottomRightRadius ?? 0),
            bottomLeft: Radius.circular(bottomLeftRadius ?? 0)),
        child: Image.network(
          image,
          fit: fit ?? BoxFit.cover,
          errorBuilder: (context, error, v) {
            return ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(topLeftRadius ?? 0),
                  topRight: Radius.circular(topRightRadius ?? 0),
                  bottomRight: Radius.circular(bottomRightRadius ?? 0),
                  bottomLeft: Radius.circular(bottomLeftRadius ?? 0)),
              child: Image.asset(
                AppImages.holder,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}

void openBottomSheet(BuildContext context, ImageProvider imageProvider) =>
    showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const ContinuousRectangleBorder(),
      builder: (BuildContext context) {
        return PhotoViewGestureDetectorScope(
          axis: Axis.vertical,
          child: Stack(
            children: [
              PhotoView(
                backgroundDecoration: BoxDecoration(
                  color: Colors.grey.withAlpha(240),
                ),
                imageProvider: imageProvider,
                heroAttributes:
                    PhotoViewHeroAttributes(tag: imageProvider.toString()),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.close,
                      color: AppColors.primaryColor.themeColor,
                      size: MediaQuery.of(context).size.width * 0.1,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
