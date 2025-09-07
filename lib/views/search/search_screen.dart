import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/search_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Tunda clearSearch hingga setelah build selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final searchProvider = context.read<SearchProvider>();
      searchProvider.clearSearch();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
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
              final searchProvider = context.read<SearchProvider>();
              searchProvider.clearSearch();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search for tracks...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                final searchProvider = context.read<SearchProvider>();
                searchProvider.searchTracks(context, query);
              },
            ),
          ),
          // Hasil Search
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, searchProvider, child) {
                if (searchProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (searchProvider.errorMessage.isNotEmpty) {
                  return Center(child: Text(searchProvider.errorMessage));
                }
                if (searchProvider.searchResults.isEmpty) {
                  return const Center(
                    child: Text('No results found. Try a different query.'),
                  );
                }
                return ListView.builder(
                  itemCount: searchProvider.searchResults.length,
                  itemBuilder: (context, index) {
                    final track = searchProvider.searchResults[index];
                    return ListTile(
                      leading: track.album.images.isNotEmpty
                          ? Image.network(
                              track.album.images[0].url,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.music_note),
                            )
                          : const Icon(Icons.music_note),
                      title: Text(track.name),
                      subtitle: Text(
                        '${track.artists.map((a) => a.name).join(', ')} • ${track.album.name}',
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Selected: ${track.name}')),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}