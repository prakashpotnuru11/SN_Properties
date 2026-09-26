import 'package:flutter/material.dart';
import 'package:sn_properties/features/home/data/sample_properties.dart';
import 'package:sn_properties/features/home/widgets/category_tile.dart';
import 'package:sn_properties/features/home/widgets/property_card.dart';
import 'package:sn_properties/features/home/widgets/section_header.dart';
import 'package:sn_properties/features/profile/profile_screen.dart';
import 'package:sn_properties/features/search/property_search.dart';
import 'package:sn_properties/features/search/search_screen.dart';
import 'package:sn_properties/shared/models/property.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavigationIndex = 0;
  PropertyType _selectedPropertyType = PropertyType.buy;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              sliver: SliverToBoxAdapter(child: _buildHeader(context)),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
              sliver: SliverToBoxAdapter(child: _buildSearch(context)),
            ),
            if (_searchQuery.trim().isNotEmpty) ...[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 30, 0, 0),
                sliver: SliverToBoxAdapter(
                  child: SectionHeader(title: 'Search results'),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 28),
                sliver: SliverToBoxAdapter(
                  child: _buildSearchResults(_searchProperties(_searchQuery)),
                ),
              ),
            ] else ...[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                sliver: SliverToBoxAdapter(child: _buildPropertyTypes(context)),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                sliver: SliverToBoxAdapter(child: _buildCategories(context)),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 30, 0, 0),
                sliver: SliverToBoxAdapter(
                  child: SectionHeader(title: 'Featured properties'),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildPropertyList(SampleProperties.featured),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 26, 0, 0),
                sliver: SliverToBoxAdapter(
                  child: SectionHeader(title: 'Recently added'),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 28),
                sliver: SliverToBoxAdapter(
                  child: _buildPropertyList(SampleProperties.recentlyAdded),
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedNavigationIndex,
        onDestinationSelected: (index) {
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const SearchScreen(),
              ),
            );
            return;
          }
          if (index == 4) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const ProfileScreen(),
              ),
            );
            return;
          }
          setState(() => _selectedNavigationIndex = index);
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SN PROPERTIES',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 18),
              Text(
                'Find a place\nyou will love.',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          tooltip: 'Notifications',
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Theme.of(context).colorScheme.primary,
          ),
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }

  Widget _buildSearch(BuildContext context) {
    return TextField(
      onChanged: (value) => setState(() => _searchQuery = value),
      decoration: InputDecoration(
        hintText: 'Search by city, neighbourhood or project',
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context).colorScheme.primary,
        ),
        suffixIcon: IconButton(
          onPressed: () {},
          tooltip: 'Filter properties',
          icon: const Icon(Icons.tune),
        ),
      ),
    );
  }

  Widget _buildPropertyTypes(BuildContext context) {
    return Row(
      children: PropertyType.values.map((type) {
        final isSelected = type == _selectedPropertyType;
        final label = type.name[0].toUpperCase() + type.name.substring(1);
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: type == PropertyType.sell ? 0 : 8,
            ),
            child: ChoiceChip(
              label: SizedBox(
                width: double.infinity,
                child: Text(label, textAlign: TextAlign.center),
              ),
              selected: isSelected,
              onSelected: (_) {
                setState(() => _selectedPropertyType = type);
              },
              showCheckmark: false,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
              side: BorderSide.none,
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategories(BuildContext context) {
    const categories = [
      (PropertyCategory.residential, Icons.apartment_outlined),
      (PropertyCategory.commercial, Icons.business_outlined),
      (PropertyCategory.agricultural, Icons.grass_outlined),
      (PropertyCategory.plots, Icons.grid_view_outlined),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore categories',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: categories
              .map((category) => CategoryTile(
                    category: category.$1,
                    icon: category.$2,
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildPropertyList(List<Property> properties) {
    return SizedBox(
      height: 340,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        scrollDirection: Axis.horizontal,
        itemCount: properties.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) => PropertyCard(property: properties[index]),
      ),
    );
  }

  List<Property> _searchProperties(String query) {
    return PropertySearch.filter(SampleProperties.all, query);
  }

  Widget _buildSearchResults(List<Property> properties) {
    if (properties.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Text(
            'No properties found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }

    return _buildPropertyList(properties);
  }
}
