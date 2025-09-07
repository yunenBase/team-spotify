import 'liked_track_model.dart'; // Mengandung Track, Album, Artist, Image

class SearchResponse {
  final PagingTracks tracks;
  final PagingAlbums albums;
  final PagingArtists artists;
  final PagingPlaylists playlists;

  SearchResponse({
    required this.tracks,
    required this.albums,
    required this.artists,
    required this.playlists,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      tracks: PagingTracks.fromJson(json['tracks'] as Map<String, dynamic>? ?? {}),
      albums: PagingAlbums.fromJson(json['albums'] as Map<String, dynamic>? ?? {}),
      artists: PagingArtists.fromJson(json['artists'] as Map<String, dynamic>? ?? {}),
      playlists: PagingPlaylists.fromJson(json['playlists'] as Map<String, dynamic>? ?? {}),
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
    var itemList = json['items'] as List<dynamic>? ?? [];
    List<Track> items = itemList.map((item) => Track.fromJson(item as Map<String, dynamic>? ?? {})).toList();

    return PagingTracks(
      href: json['href'] as String?,
      items: items,
      limit: json['limit'] as int? ?? 0,
      offset: json['offset'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      total: json['total'] as int? ?? 0,
    );
  }
}

class PagingAlbums {
  final String? href;
  final List<Album> items;
  final int limit;
  final int offset;
  final String? next;
  final String? previous;
  final int total;

  PagingAlbums({
    this.href,
    required this.items,
    required this.limit,
    required this.offset,
    this.next,
    this.previous,
    required this.total,
  });

  factory PagingAlbums.fromJson(Map<String, dynamic> json) {
    var itemList = json['items'] as List<dynamic>? ?? [];
    List<Album> items = itemList.map((item) => Album.fromJson(item as Map<String, dynamic>? ?? {})).toList();

    return PagingAlbums(
      href: json['href'] as String?,
      items: items,
      limit: json['limit'] as int? ?? 0,
      offset: json['offset'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      total: json['total'] as int? ?? 0,
    );
  }
}

class PagingArtists {
  final String? href;
  final List<Artist> items;
  final int limit;
  final int offset;
  final String? next;
  final String? previous;
  final int total;

  PagingArtists({
    this.href,
    required this.items,
    required this.limit,
    required this.offset,
    this.next,
    this.previous,
    required this.total,
  });

  factory PagingArtists.fromJson(Map<String, dynamic> json) {
    var itemList = json['items'] as List<dynamic>? ?? [];
    List<Artist> items = itemList.map((item) => Artist.fromJson(item as Map<String, dynamic>? ?? {})).toList();

    return PagingArtists(
      href: json['href'] as String?,
      items: items,
      limit: json['limit'] as int? ?? 0,
      offset: json['offset'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      total: json['total'] as int? ?? 0,
    );
  }
}

class PagingPlaylists {
  final String? href;
  final List<Playlist> items;
  final int limit;
  final int offset;
  final String? next;
  final String? previous;
  final int total;

  PagingPlaylists({
    this.href,
    required this.items,
    required this.limit,
    required this.offset,
    this.next,
    this.previous,
    required this.total,
  });

  factory PagingPlaylists.fromJson(Map<String, dynamic> json) {
    var itemList = json['items'] as List<dynamic>? ?? [];
    List<Playlist> items = itemList.map((item) => Playlist.fromJson(item as Map<String, dynamic>? ?? {})).toList();

    return PagingPlaylists(
      href: json['href'] as String?,
      items: items,
      limit: json['limit'] as int? ?? 0,
      offset: json['offset'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      total: json['total'] as int? ?? 0,
    );
  }
}

class Playlist {
  final String id;
  final String name;
  final String? description;
  final List<Image> images;
  final String? uri;

  Playlist({
    required this.id,
    required this.name,
    this.description,
    required this.images,
    this.uri,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    var imageList = json['images'] as List<dynamic>? ?? [];
    List<Image> images = imageList.map((item) => Image.fromJson(item as Map<String, dynamic>? ?? {})).toList();

    return Playlist(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown Playlist',
      description: json['description'] as String?,
      images: images,
      uri: json['uri'] as String?,
    );
  }
}