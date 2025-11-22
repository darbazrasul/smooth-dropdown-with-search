import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Duration fadeInDuration;
  final Duration fadeOutDuration;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final Alignment alignment;
  final bool enableShimmer;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;
  final IconData errorIcon;
  final String errorText;
  final double? errorIconSize;
  final TextStyle? errorTextStyle;
  final VoidCallback? onTap;
  final String? heroTag;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.backgroundColor,
    this.placeholder,
    this.errorWidget,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.fadeOutDuration = const Duration(milliseconds: 300),
    this.memCacheWidth,
    this.memCacheHeight,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.alignment = Alignment.center,
    this.enableShimmer = true,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.errorIcon = Icons.broken_image_outlined,
    this.errorText = 'Image not available',
    this.errorIconSize,
    this.errorTextStyle,
    this.onTap,
    this.heroTag,
  });

  factory CachedImage.circular({
    Key? key,
    required String imageUrl,
    required double size,
    Color? backgroundColor,
    Widget? placeholder,
    Widget? errorWidget,
    VoidCallback? onTap,
    String? heroTag,
  }) {
    return CachedImage(
      key: key,
      imageUrl: imageUrl,
      width: size,
      height: size,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(size / 2),
      backgroundColor: backgroundColor,
      placeholder: placeholder,
      errorWidget: errorWidget,
      onTap: onTap,
      heroTag: heroTag,
    );
  }

  factory CachedImage.square({
    Key? key,
    required String imageUrl,
    required double size,
    double borderRadius = 8.0,
    Color? backgroundColor,
    Widget? placeholder,
    Widget? errorWidget,
    VoidCallback? onTap,
    String? heroTag,
  }) {
    return CachedImage(
      key: key,
      imageUrl: imageUrl,
      width: size,
      height: size,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(borderRadius),
      backgroundColor: backgroundColor,
      placeholder: placeholder,
      errorWidget: errorWidget,
      onTap: onTap,
      heroTag: heroTag,
    );
  }

  factory CachedImage.card({
    Key? key,
    required String imageUrl,
    double? width,
    double? height,
    double borderRadius = 12.0,
    Color? backgroundColor,
    Widget? placeholder,
    Widget? errorWidget,
    VoidCallback? onTap,
    String? heroTag,
  }) {
    return CachedImage(
      key: key,
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(borderRadius),
      backgroundColor: backgroundColor,
      placeholder: placeholder,
      errorWidget: errorWidget,
      onTap: onTap,
      heroTag: heroTag,
    );
  }

  Widget _buildDefaultPlaceholder() {
    if (!enableShimmer) {
      return Container(
        width: width,
        height: height,
        color: backgroundColor ?? Colors.grey.shade200,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade400),
          ),
        ),
      );
    }

    return Shimmer.fromColors(
      baseColor: shimmerBaseColor ?? Colors.grey.shade300,
      highlightColor: shimmerHighlightColor ?? Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
        ),
      ),
    );
  }

  Widget _buildDefaultErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.shade200,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              errorIcon,
              color: Colors.grey.shade400,
              size: errorIconSize ?? 32.sp,
            ),
            if (errorText.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                errorText,
                style:
                    errorTextStyle ??
                    TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCachedImage() {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      placeholder: (context, url) => placeholder ?? _buildDefaultPlaceholder(),
      errorWidget: (context, url, error) =>
          errorWidget ?? _buildDefaultErrorWidget(),
      fadeInDuration: fadeInDuration,
      fadeOutDuration: fadeOutDuration,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      maxWidthDiskCache: maxWidthDiskCache,
      maxHeightDiskCache: maxHeightDiskCache,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = _buildCachedImage();

    if (borderRadius != null) {
      imageWidget = ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    if (heroTag != null) {
      imageWidget = Hero(tag: heroTag!, child: imageWidget);
    }

    if (onTap != null) {
      imageWidget = GestureDetector(onTap: onTap, child: imageWidget);
    }

    return imageWidget;
  }
}
