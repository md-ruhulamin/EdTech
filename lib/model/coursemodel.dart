class Course {
  String name;
  String imgUrl;
  String title;
  String videoUrl;

  Course(
      {required this.name,
      required this.imgUrl,
      required this.title,
      required this.videoUrl});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      name: json['name'] ?? '',
      imgUrl: json['imgUrl'] ?? '',
      title: json['title'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imgUrl': imgUrl,
      'title': title,
      'videoUrl': videoUrl
    };
  }
}
