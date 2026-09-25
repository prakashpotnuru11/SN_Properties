import 'package:flutter/material.dart';
import 'package:sn_properties/shared/models/property.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    required this.category,
    required this.icon,
    super.key,
  });

  final PropertyCategory category;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final label = switch (category) {
      PropertyCategory.residential => 'Residential',
      PropertyCategory.commercial => 'Commercial',
      PropertyCategory.agricultural => 'Agricultural',
      PropertyCategory.plots => 'Plots',
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}
