import 'package:flutter/material.dart';
import 'package:sn_properties/features/favorites/favorites_local_storage.dart';
import 'package:sn_properties/features/home/data/sample_properties.dart';
import 'package:sn_properties/features/home/widgets/property_card.dart';
import 'package:sn_properties/features/profile/profile_screen.dart';
import 'package:sn_properties/features/search/search_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({required this.favoritesStore, super.key});

  final FavoritesStore favoritesStore;

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    widget.favoritesStore.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved properties')),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: widget.favoritesStore,
          builder: (context, _) {
            if (!widget.favoritesStore.isReady) {
              return const Center(child: CircularProgressIndicator());
            }

            final properties = SampleProperties.all
                .where(widget.favoritesStore.isFavorite)
                .toList();
            if (properties.isEmpty) {
              return _buildEmptyState(context);
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              itemCount: properties.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) => Center(
                child: PropertyCard(
                  property: properties[index],
                  favoritesStore: widget.favoritesStore,
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 2,
        onDestinationSelected: (index) {
          if (index == 0) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => SearchScreen(
                  favoritesStore: widget.favoritesStore,
                ),
              ),
            );
          } else if (index == 4) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const ProfileScreen(),
              ),
            );
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Enquiries',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_border,
              size: 52,
              color: theme.colorScheme.primary.withValues(alpha: 0.72),
            ),
            const SizedBox(height: 20),
            Text(
              'No saved properties yet',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Save properties you like and they will appear here.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: const Icon(Icons.search),
              label: const Text('Explore Properties'),
            ),
          ],
        ),
      ),
    );
  }
}