class Playlist {
  final String id;
  final String name;
  final String? description;
  final bool isPublic;
  final bool isCollaborative;
  final String ownerId;
  final String ownerName;
  final int totalTracks;
  final String? imageUrl; // URL gambar playlist
  final String spotifyUrl; // URL Spotify untuk playlist

  Playlist({
    required this.id,
    required this.name,
    this.description,
    required this.isPublic,
    required this.isCollaborative,
    required this.ownerId,
    required this.ownerName,
    required this.totalTracks,
    this.imageUrl,
    required this.spotifyUrl,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Playlist',
      description: json['description'],
      isPublic: json['public'] ?? false,
      isCollaborative: json['collaborative'] ?? false,
      ownerId: json['owner']['id'] ?? '',
      ownerName: json['owner']['display_name'] ?? 'Unknown Owner',
      totalTracks: json['tracks']['total'] ?? 0,
      imageUrl: json['images'] != null && json['images'].isNotEmpty
          ? json['images'][0]['url']
          : null,
      spotifyUrl: json['external_urls']['spotify'] ?? '',
    );
  }

  get images => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'public': isPublic,
      'collaborative': isCollaborative,
      'owner': {
        'id': ownerId,
        'display_name': ownerName,
      },
      'tracks': {'total': totalTracks},
      'images': imageUrl != null ? [{'url': imageUrl}] : [],
      'external_urls': {'spotify': spotifyUrl},
    };
  }
}

class PlaylistResponse {
  final List<Playlist> playlists;
  final int total;
  final String? next;
  final String? previous;

  PlaylistResponse({
    required this.playlists,
    required this.total,
    this.next,
    this.previous,
  });

  factory PlaylistResponse.fromJson(Map<String, dynamic> json) {
    var playlistList = json['items'] as List;
    List<Playlist> playlists =
        playlistList.map((item) => Playlist.fromJson(item)).toList();

    return PlaylistResponse(
      playlists: playlists,
      total: json['total'] ?? 0,
      next: json['next'],
      previous: json['previous'],
    );
  }
}