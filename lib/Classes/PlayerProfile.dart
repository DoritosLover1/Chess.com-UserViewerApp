class PlayerProfile {
  final String username;
  final String? country;
  final int? followers;
  final int? joined;
  final int? lastOnline;
  final bool? verified;
  final String? status;
  final List<dynamic>? streamingPlatforms;

  PlayerProfile({
    required this.username,
    this.followers,
    this.country,
    this.joined,
    this.lastOnline,
    this.verified,
    this.status,
    this.streamingPlatforms = const [],
  });

  factory PlayerProfile.fromJson(Map<String, dynamic> json) {
    return PlayerProfile(
      username: json['username'] ?? '',
      followers: json['followers'] ?? 0,
      country: json['country'] ?? '',
      joined: json['joined'] ?? 0,
      lastOnline: json['last_online'] ?? 0,
      status: json['status'] ?? '',
      streamingPlatforms: json['streaming_platforms']
    );
  }
}