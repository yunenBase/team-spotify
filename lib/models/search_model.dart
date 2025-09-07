import 'liked_track_model.dart'; // Import model Track, Album, Artist, dll.

class SearchResponse {
  final PagingTracks tracks; // Hanya fokus pada tracks untuk sederhana

  SearchResponse({required this.tracks});

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      tracks: PagingTracks.fromJson(json['tracks'] ?? {}),
    );
  }
}

class PagingTracks {
  final String? href;
  final List<Track> items;
  final int limit;
  final int offset;
  final String? next;
  final String? previous;
  final int total;

  PagingTracks({
    this.href,
    required this.items,
    required this.limit,
    required this.offset,
    this.next,
    this.previous,
    required this.total,
  });

  factory PagingTracks.fromJson(Map<String, dynamic> json) {
    var itemList = json['items'] as List? ?? [];
    List<Track> items = itemList.map((item) => Track.fromJson(item)).toList();

    return PagingTracks(
      href: json['href'],
      items: items,
      limit: json['limit'] ?? 0,
      offset: json['offset'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      total: json['total'] ?? 0,
    );
  }
}