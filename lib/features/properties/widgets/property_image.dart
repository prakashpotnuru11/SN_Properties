import 'package:flutter/material.dart';
import 'package:sn_properties/shared/models/property.dart';

class PropertyImage extends StatelessWidget {
  const PropertyImage({
    required this.property,
    required this.height,
    super.key,
  });

  final Property property;
  final double height;

  @override
  Widget build(BuildContext context) {
    final imageUrl = property.imageUrls.isEmpty ? '' : property.imageUrls.first;
    if (imageUrl.isEmpty) {
      return _placeholder(context);
    }

    return Image.network(
      imageUrl,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _placeholder(context, showProgress: true);
      },
      errorBuilder: (context, error, stackTrace) => _placeholder(context),
    );
  }

  Widget _placeholder(BuildContext context, {bool showProgress = false}) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            property.accentColor.withValues(alpha: 0.65),
            property.accentColor,
          ],
        ),
      ),
      child: Center(
        child: showProgress
            ? SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              )
            : Icon(
                Icons.home_work_outlined,
                size: height > 200 ? 76 : 58,
                color: Colors.white.withValues(alpha: 0.78),
              ),
      ),
    );
  }
}