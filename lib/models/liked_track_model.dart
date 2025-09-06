class LikedTrackItem {
  final String addedAt;
  final Track track;

  LikedTrackItem({
    required this.addedAt,
    required this.track,
  });

  factory LikedTrackItem.fromJson(Map<String, dynamic> json) {
    return LikedTrackItem(
      addedAt: json['added_at'] ?? '',
      track: Track.fromJson(json['track'] ?? {}),
    );
  }
}

class Track {
  final Album album;
  final List<Artist> artists;
  final int discNumber;
  final int durationMs;
  final bool explicit;
  final String id;
  final String name;
  final int popularity;
  final String previewUrl;
  final int trackNumber;
  final String uri;

  Track({
    required this.album,
    required this.artists,
    required this.discNumber,
    required this.durationMs,
    required this.explicit,
    required this.id,
    required this.name,
    required this.popularity,
    this.previewUrl = '',
    required this.trackNumber,
    required this.uri,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    var artistList = json['artists'] as List? ?? [];
    List<Artist> artists = artistList.map((item) => Artist.fromJson(item)).toList();

    return Track(
      album: Album.fromJson(json['album'] ?? {}),
      artists: artists,
      discNumber: json['disc_number'] ?? 0,
      durationMs: json['duration_ms'] ?? 0,
      explicit: json['explicit'] ?? false,
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Track',
      popularity: json['popularity'] ?? 0,
      previewUrl: json['preview_url'] ?? '',
      trackNumber: json['track_number'] ?? 0,
      uri: json['uri'] ?? '',
    );
  }
}

class Album {
  final String albumType;
  final List<Artist> artists;
  final List<String> availableMarkets;
  final String id;
  final List<Image> images;
  final String name;
  final String releaseDate;
  final int totalTracks;
  final String uri;

  Album({
    required this.albumType,
    required this.artists,
    required this.availableMarkets,
    required this.id,
    required this.images,
    required this.name,
    required this.releaseDate,
    required this.totalTracks,
    required this.uri,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    var artistList = json['artists'] as List? ?? [];
    List<Artist> artists = artistList.map((item) => Artist.fromJson(item)).toList();

    var imageList = json['images'] as List? ?? [];
    List<Image> images = imageList.map((item) => Image.fromJson(item)).toList();

    return Album(
      albumType: json['album_type'] ?? '',
      artists: artists,
      availableMarkets: (json['available_markets'] as List?)?.cast<String>() ?? [],
      id: json['id'] ?? '',
      images: images,
      name: json['name'] ?? 'Unknown Album',
      releaseDate: json['release_date'] ?? '',
      totalTracks: json['total_tracks'] ?? 0,
      uri: json['uri'] ?? '',
    );
  }
}

class Artist {
  final String id;
  final String name;
  final String uri;

  Artist({
    required this.id,
    required this.name,
    required this.uri,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Artist',
      uri: json['uri'] ?? '',
    );
  }
}

class Image {
  final int height;
  final int width;
  final String url;

  Image({
    required this.height,
    required this.width,
    required this.url,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      height: json['height'] ?? 0,
      width: json['width'] ?? 0,
      url: json['url'] ?? '',
    );
  }
}

class LikedTracksResponse {
  final List<LikedTrackItem> items;
  final int limit;
  final String? next;
  final int offset;
  final String? previous;
  final int total;

  LikedTracksResponse({
    required this.items,
    required this.limit,
    this.next,
    required this.offset,
    this.previous,
    required this.total,
  });

  factory LikedTracksResponse.fromJson(Map<String, dynamic> json) {
    var itemList = json['items'] as List? ?? [];
    List<LikedTrackItem> items = itemList.map((item) => LikedTrackItem.fromJson(item)).toList();

    return LikedTracksResponse(
      items: items,
      limit: json['limit'] ?? 0,
      next: json['next'],
      offset: json['offset'] ?? 0,
      previous: json['previous'],
      total: json['total'] ?? 0,
    );
  }
}