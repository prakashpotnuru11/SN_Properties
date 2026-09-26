import 'package:flutter/material.dart';
import 'package:sn_properties/features/properties/property_details_screen.dart';
import 'package:sn_properties/shared/models/property.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({required this.property, super.key});

  final Property property;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final details = property.bedrooms > 0
        ? '${property.bedrooms} beds  •  ${property.area}'
        : property.area;

    return SizedBox(
      width: 260,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => PropertyDetailsScreen(property: property),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Stack(
              children: [
                Container(
                  height: 156,
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
                    child: Icon(
                      Icons.home_work_outlined,
                      size: 58,
                      color: Colors.white.withValues(alpha: 0.78),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      child: Text(
                        property.type.name.toUpperCase(),
                        style: textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () {},
                    tooltip: 'Save property',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.9),
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    icon: const Icon(Icons.favorite_border, size: 20),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 15,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    property.price,
                    style: textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(details, style: textTheme.bodySmall),
                ],
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
