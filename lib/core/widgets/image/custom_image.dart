import 'package:app_base/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
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
  final String image;
  final double? radius;
  final double? width;
  final double? height;
  final BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 0),
        child: Image.network(
          image,
          fit: fit ?? BoxFit.cover,
          errorBuilder: (context, error, v) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(radius ?? 0),
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
