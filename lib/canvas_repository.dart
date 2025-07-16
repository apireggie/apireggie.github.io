import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models.dart';

class CanvasRepository {
  // These will be replaced at build time with --dart-define
  static const String canvasToken = String.fromEnvironment('CANVAS_TOKEN');
  static const String baseUrl = 'https://us-sae.instructure.com/api/v1';

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $canvasToken',
      };

  Future<List<Course>> fetchCourses() async {
    final res =
        await http.get(Uri.parse('$baseUrl/courses'), headers: _headers);
    if (res.statusCode != 200) throw Exception('Courses fetch failed');
    return (jsonDecode(res.body) as List)
        .map((e) => Course.fromJson(e))
        .toList();
  }

  Future<List<Announcement>> fetchAnnouncements(List<String> contexts) async {
    final uri = Uri.parse('$baseUrl/announcements').replace(
      queryParameters: {
        for (var ctx in contexts) 'context_codes[]': ctx,
        'active_only': 'true',
      },
    );

    final res = await http.get(uri, headers: _headers);
    if (res.statusCode != 200) throw Exception('Announcements fetch failed');
    return (jsonDecode(res.body) as List)
        .map((e) => Announcement.fromJson(e))
        .toList();
  }
}
