import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Loads a network item photo with a graceful lifecycle:
///   * while loading  → [fallback] (if given) or a subtle spinner tile
///   * on error/offline → [fallback] (if given) or a themed icon tile
///
/// Keeps the app looking intentional whether or not the image resolves, so
/// swapping the URLs for real assets later is a drop-in change.
class ItemImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final IconData fallbackIcon;

  /// Optional custom widget shown during loading and on failure (e.g. a
  /// gradient for the hero). Overrides the default icon/spinner tiles.
  final Widget? fallback;

  const ItemImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallbackIcon = Icons.inventory_2_rounded,
    this.fallback,
  });

  bool get _isAsset => url.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(14);
    final Widget image = _isAsset
        ? Image.asset(
            url,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stack) => fallback ?? _iconTile(),
          )
        : Image.network(
            url,
            width: width,
            height: height,
            fit: fit,
            gaplessPlayback: true,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return fallback ?? _spinnerTile();
            },
            errorBuilder: (context, error, stack) => fallback ?? _iconTile(),
          );

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(width: width, height: height, child: image),
    );
  }

  Widget _spinnerTile() => Container(
        width: width,
        height: height,
        color: AppTheme.darkerCharcoal,
        alignment: Alignment.center,
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppTheme.gold,
          ),
        ),
      );

  Widget _iconTile() => Container(
        width: width,
        height: height,
        color: AppTheme.gold.withValues(alpha: 0.12),
        alignment: Alignment.center,
        child: Icon(
          fallbackIcon,
          color: AppTheme.gold,
          size: (width ?? height ?? 48) * 0.42,
        ),
      );
}
