import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopotify/controllers/search_controller.dart';
import '../../providers/search_provider.dart';
import 'search_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final SpotifySearchController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SpotifySearchController();
    _controller.init(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _controller.refresh(context, '');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search for tracks, albums, artists, or playlists...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (query) {
                  _controller.refresh(context, query);
                },
              ),
            ),
            // Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Consumer<SearchProvider>(
                builder: (context, searchProvider, child) {
                  return Wrap(
                    spacing: 8.0,
                    children: [
                      _buildFilterChip(context, 'all', 'All'), // Tambah chip All
                      _buildFilterChip(context, 'track', 'Tracks'),
                      _buildFilterChip(context, 'album', 'Albums'),
                      _buildFilterChip(context, 'artist', 'Artists'),
                      _buildFilterChip(context, 'playlist', 'Playlists'),
                    ],
                  );
                },
              ),
            ),
            // Hasil Search
            Expanded(
              child: SearchView(scrollController: _controller.scrollController),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String type, String label) {
    final searchProvider = context.watch<SearchProvider>();
    return FilterChip(
      label: Text(label),
      selected: searchProvider.selectedType == type,
      onSelected: (selected) {
        if (selected) {
          searchProvider.setSelectedType(type);
        }
      },
    );
  }
}