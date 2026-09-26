import 'package:flutter/material.dart';
import 'package:sn_properties/shared/models/property.dart';

class PropertyDetailsScreen extends StatelessWidget {
  const PropertyDetailsScreen({required this.property, super.key});

  final Property property;

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
                child: Container(
                  height: 240,
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
                    child: Icon(
                      Icons.home_work_outlined,
                      size: 76,
                      color: Colors.white.withValues(alpha: 0.82),
                    ),
                  ),
                ),
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