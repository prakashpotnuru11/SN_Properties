import 'package:flutter/material.dart';
import 'package:sn_properties/features/favorites/favorites_local_storage.dart';
import 'package:sn_properties/features/home/data/sample_properties.dart';
import 'package:sn_properties/features/home/widgets/property_card.dart';
import 'package:sn_properties/features/search/property_search.dart';
import 'package:sn_properties/shared/models/property.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({required this.favoritesStore, super.key});

  final FavoritesStore favoritesStore;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final properties = PropertySearch.filter(SampleProperties.all, _query);

    return Scaffold(
      appBar: AppBar(title: const Text('Search properties')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final searchField = _buildSearchField(context);
            final resultsHeader = _buildResultsHeader(context);
            final results = _buildResults(context, properties);

            if (constraints.maxHeight < 320) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    searchField,
                    resultsHeader,
                    const SizedBox(height: 8),
                    SizedBox(height: 340, child: results),
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                searchField,
                resultsHeader,
                const SizedBox(height: 8),
                Expanded(child: results),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _query = value),
        decoration: InputDecoration(
          hintText: 'Search by city, neighbourhood or project',
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.primary,
          ),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                  tooltip: 'Clear search',
                  icon: const Icon(Icons.clear),
                ),
        ),
      ),
    );
  }

  Widget _buildResultsHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        _query.trim().isEmpty ? 'Available properties' : 'Search results',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }

  Widget _buildResults(BuildContext context, List<Property> properties) {
    if (properties.isEmpty) {
      return Center(
        child: Text(
          'No properties found',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }
    return _buildPropertyList(properties);
  }

  Widget _buildPropertyList(List<Property> properties) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      scrollDirection: Axis.horizontal,
      itemCount: properties.length,
      separatorBuilder: (_, _) => const SizedBox(width: 14),
      itemBuilder: (context, index) => PropertyCard(
        property: properties[index],
        favoritesStore: widget.favoritesStore,
      ),
    );
  }
}