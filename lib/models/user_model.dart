class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String? imageUrl;
  final int? followers;

  UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    this.imageUrl,
    this.followers,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      displayName: json['display_name'],
      email: json['email'],
      imageUrl: (json['images'] != null && json['images'].isNotEmpty)
          ? json['images'][0]['url']
          : null,
      followers: json['followers']?['total'] ?? 0,
    );
  }
}
