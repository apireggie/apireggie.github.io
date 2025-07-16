// lib/models.dart

class Course {
  final int id;
  final String name;
  final String code;

  Course({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      code: json['course_code'],
    );
  }
}

class Announcement {
  final int id;
  final String title;
  final String message;
  final DateTime postedAt;

  Announcement({
    required this.id,
    required this.title,
    required this.message,
    required this.postedAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'] ?? '(Untitled)',
      message: json['message'] ?? '',
      postedAt: DateTime.parse(json['posted_at']),
    );
  }
}
