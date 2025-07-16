import 'dart:convert';
import 'package:http/http.dart' as http;

class Course {
  final int id;
  final String name;
  final String code;
  Course({required this.id, required this.name, required this.code});
  factory Course.fromJson(Map<String, dynamic> j) =>
      Course(id: j['id'], name: j['name'], code: j['course_code']);
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
  factory Announcement.fromJson(Map<String, dynamic> j) => Announcement(
        id: j['id'],
        title: j['title'] ?? '(untitled)',
        message: j['message'] ?? '',
        postedAt: DateTime.parse(j['posted_at']),
      );
}

class CanvasRepository {
  final String _base = 'https://us-sae.instructure.com/api/v1';
  String canvasToken = const String.fromEnvironment('CANVAS_TOKEN');

  Map<String, String> get _headers => {'Authorization': 'Bearer $canvasToken'};

  Future<List<Course>> fetchCourses() async {
    final res = await http.get(Uri.parse('$_base/courses'), headers: _headers);
    if (res.statusCode != 200) throw Exception('Courses fail');
    return (jsonDecode(res.body) as List)
        .map((e) => Course.fromJson(e))
        .toList();
  }

  Future<List<Announcement>> fetchAnnouncements(List<String> ctx) async {
    final uri = Uri.parse('$_base/announcements').replace(
      queryParameters: {
        'context_codes[]': ctx,
        'active_only': 'true',
      },
    );
    final res = await http.get(uri, headers: _headers);
    if (res.statusCode != 200) throw Exception('Announce fail');
    return (jsonDecode(res.body) as List)
        .map((e) => Announcement.fromJson(e))
        .toList();
  }
}
