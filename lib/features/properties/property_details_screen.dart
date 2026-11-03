import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sn_properties/features/favorites/favorites_local_storage.dart';
import 'package:sn_properties/features/properties/widgets/property_image.dart';
import 'package:sn_properties/shared/models/property.dart';

class PropertyDetailsScreen extends StatelessWidget {
  const PropertyDetailsScreen({
    required this.property,
    required this.favoritesStore,
    super.key,
  });

  final Property property;
  final FavoritesStore favoritesStore;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Property details'),
        actions: [
          IconButton(
            onPressed: () => SharePlus.instance.share(
              ShareParams(text: propertyShareText(property)),
            ),
            tooltip: 'Share property',
            icon: const Icon(Icons.share_outlined),
          ),
          AnimatedBuilder(
            animation: favoritesStore,
            builder: (context, _) {
              final isSaved = favoritesStore.isFavorite(property);
              return IconButton(
                onPressed: () => favoritesStore.toggle(property),
                tooltip: isSaved ? 'Remove saved property' : 'Save property',
                icon: Icon(
                  isSaved ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: PropertyImage(property: property, height: 240),
              ),
              const SizedBox(height: 22),
              Text(
                property.title,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                property.price,
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: colorScheme.secondary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(property.location, style: textTheme.bodyLarge),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _AttributeChip(label: property.type.name.toUpperCase()),
                  _AttributeChip(label: _categoryLabel(property.category)),
                  _AttributeChip(label: property.area),
                  if (property.bedrooms > 0)
                    _AttributeChip(label: '${property.bedrooms} bedrooms'),
                  if (property.isFeatured)
                    const _AttributeChip(label: 'FEATURED'),
                ],
              ),
              if (property.description.trim().isNotEmpty) ...[
                const SizedBox(height: 26),
                Text(
                  'About this property',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(property.description, style: textTheme.bodyLarge),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _categoryLabel(PropertyCategory category) {
    return switch (category) {
      PropertyCategory.residential => 'Residential',
      PropertyCategory.commercial => 'Commercial',
      PropertyCategory.agricultural => 'Agricultural',
      PropertyCategory.plots => 'Plots',
    };
  }
}

String propertyShareText(Property property) {
  final title = property.title.trim();
  final details = <String>[
    if (property.price.trim().isNotEmpty) property.price.trim(),
    if (property.location.trim().isNotEmpty) property.location.trim(),
    property.type.name.toUpperCase(),
    property.category.name,
    if (property.area.trim().isNotEmpty) property.area.trim(),
    if (property.bedrooms > 0) '${property.bedrooms} bedrooms',
    if (property.description.trim().isNotEmpty) property.description.trim(),
  ];

  return [if (title.isNotEmpty) title, ...details].join('\n');
}

class _AttributeChip extends StatelessWidget {
  const _AttributeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}