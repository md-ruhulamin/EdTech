import 'dart:convert';

class Bookmark {
  final int videoId;
  final String title;
  final String duration;

  Bookmark({
    required this.videoId,
    required this.title,
    required this.duration,
  });

  // Factory method to create a Bookmark from a map
  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      videoId: map['videoId'] ?? 0,
      title: map['title'] ?? '',
      duration: map['duration'] ?? 0,
    );
  }

  // Method to convert a Bookmark to a map
  Map<String, dynamic> toMap() {
    return {'videoId': videoId, 'title': title, 'duration': duration};
  }

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      videoId: json['videoId'],
      title: json['title'],
      duration: json['duration'],
    );
  }

  // Convert Bookmark to string

  // Create Bookmark from string
  factory Bookmark.fromString(String string) {
    final Map<String, dynamic> json = jsonDecode(string);
    return Bookmark.fromJson(json);
  }

  // Convert Bookmark to JSON
  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'title': title,
      'duration': duration
         };
  }

  // Create Bookmark from JSON

  // Convert Bookmark to string
  String toString() {
    return jsonEncode(toJson());
  }
}
