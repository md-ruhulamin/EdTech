class Chapter {
  String icon;
  String title;
  int videoId;
  String videoUrl;
  bool visited;

  Chapter({
    required this.videoId,
    required this.icon,
    required this.title,
    required this.videoUrl,
    this.visited = false,
  });

  @override
  String toString() {
    return 'Chapter: $title, Icon: $icon, Video URL: $videoUrl, Visited: $visited';
  }
}
