import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sopotify/controllers/search_controller.dart';
import 'package:sopotify/core/constant/app_colors.dart';
import '../../providers/search_provider.dart';
import 'search_view.dart';

class DeepSearchScreen extends StatefulWidget {
  const DeepSearchScreen({Key? key}) : super(key: key);

  @override
  _DeepSearchScreenState createState() => _DeepSearchScreenState();
}

class _DeepSearchScreenState extends State<DeepSearchScreen> {
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
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 15.h),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for tracks, albums, artists, or playlists...',
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _controller.refresh(context, ""); // reset search
                          },
                        )
                      : null,
                ),
                onChanged: (query) {
                  setState(() {}); // supaya suffixIcon ikut update
                  _controller.refresh(context, query);
                },
              ),
            ),
            // Filter Chips (Horizontal Scroll)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 8.h),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Consumer<SearchProvider>(
                  builder: (context, searchProvider, child) {
                    return Row(
                      children: [
                        _buildFilterChip(context, 'all', 'All'),
                        SizedBox(width: 8.w),
                        _buildFilterChip(context, 'track', 'Tracks'),
                        SizedBox(width: 8.w),
                        _buildFilterChip(context, 'album', 'Albums'),
                        SizedBox(width: 8.w),
                        _buildFilterChip(context, 'artist', 'Artists'),
                        SizedBox(width: 8.w),
                        _buildFilterChip(context, 'playlist', 'Playlists'),
                      ],
                    );
                  },
                ),
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
      checkmarkColor: AppColors.green,
      label: Text(label),
      selected: searchProvider.selectedType == type,
      onSelected: (selected) {
        if (selected) {
          searchProvider.setSelectedType(type);
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17.r), // Atur border radius
        side: BorderSide(
          color: searchProvider.selectedType == type
              ? AppColors.green
              : Theme.of(context).colorScheme.outline,
          width: 1.w,
        ),
      ),
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      backgroundColor: Theme.of(context).colorScheme.surface,
      labelStyle: TextStyle(
        color: searchProvider.selectedType == type
            ? AppColors.green
            : Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}