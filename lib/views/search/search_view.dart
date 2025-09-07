import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../providers/search_provider.dart';

class SearchView extends StatelessWidget {
  final ScrollController scrollController;

  const SearchView({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        if (searchProvider.isLoading && searchProvider.query.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (searchProvider.errorMessage.isNotEmpty) {
          return Center(child: Text(searchProvider.errorMessage));
        }
        if (searchProvider.query.isEmpty) {
          return const Center(child: Text('Type to search for tracks, albums, artists, or playlists'));
        }

        List<dynamic> items = [];
        switch (searchProvider.selectedType) {
          case 'track':
            items = searchProvider.tracks;
            break;
          case 'album':
            items = searchProvider.albums;
            break;
          case 'artist':
            items = searchProvider.artists;
            break;
          case 'playlist':
            items = searchProvider.playlists;
            break;
          case 'all':
            items = searchProvider.allItems;
            break;
        }

        if (items.isEmpty) {
          return Center(child: Text('No ${searchProvider.selectedType == 'all' ? 'results' : '${searchProvider.selectedType}s'} found for "${searchProvider.query}". Try a different query.'));
        }

        return ListView.builder(
          controller: scrollController,
          itemCount: items.length + (searchProvider.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == items.length) {
              return const Center(child: CircularProgressIndicator());
            }

            final item = items[index];
            final itemType = searchProvider.selectedType == 'all' ? item['type'] as String : searchProvider.selectedType;
            final itemData = searchProvider.selectedType == 'all' ? item['item'] : item;

            return ListTile(
              leading: _buildLeading(itemData, itemType),
              title: Text(_getItemName(itemData, itemType)),
              subtitle: Text(_getItemSubtitle(itemData, itemType)),
              trailing: searchProvider.selectedType == 'all'
                  ? Chip(
                      label: Text(
                        itemType.capitalize(),
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    )
                  : null,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected: ${_getItemName(itemData, itemType)} (${itemType.capitalize()})')),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildLeading(dynamic item, String type) {
    switch (type) {
      case 'track':
        return item.album.images.isNotEmpty
            ? Image.network(
                item.album.images[0].url,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.music_note),
              )
            : const Icon(Icons.music_note);
      case 'album':
        return item.images.isNotEmpty
            ? Image.network(
                item.images[0].url,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.album),
              )
            : const Icon(Icons.album);
      case 'artist':
        return item.images != null && item.images.isNotEmpty
            ? Image.network(
                item.images[0].url,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.person),
              )
            : const Icon(Icons.person);
      case 'playlist':
        return item.images.isNotEmpty
            ? Image.network(
                item.images[0].url,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.playlist_play),
              )
            : const Icon(Icons.playlist_play);
      default:
        return const Icon(Icons.error);
    }
  }

  String _getItemName(dynamic item, String type) {
    switch (type) {
      case 'track':
        return item.name ?? 'Unknown Track';
      case 'album':
        return item.name ?? 'Unknown Album';
      case 'artist':
        return item.name ?? 'Unknown Artist';
      case 'playlist':
        return item.name ?? 'Unknown Playlist';
      default:
        return 'Unknown';
    }
  }

  String _getItemSubtitle(dynamic item, String type) {
    switch (type) {
      case 'track':
        return '${item.artists.map((a) => a.name).join(', ')} • ${item.album.name ?? 'Unknown Album'}';
      case 'album':
        return item.artists?.map((a) => a.name).join(', ') ?? 'Unknown Artist';
      case 'artist':
        return item.genres?.join(', ') ?? 'Artist';
      case 'playlist':
        return item.description ?? 'Playlist';
      default:
        return '';
    }
  }
}

// Ekstensi untuk mengkapitalkan string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}