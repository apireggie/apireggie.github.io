// Flutter Canvas Demo – Courses & Announcements (AppRegin Suite)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ————— ENTRY —————
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dart:html';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final canvasToken = dotenv.env['CANVAS_TOKEN'];
final openAiKey = dotenv.env['OPENAI_API_KEY'];

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const AppReginCanvasApp());
  // Fade out the preloader
  Future.delayed(const Duration(milliseconds: 300), () {
    final loader = document.getElementById('loading-screen');
    loader?.remove();
  });
}

class AppReginCanvasApp extends StatelessWidget {
  const AppReginCanvasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: RepositoryProvider(
        create: (_) => CanvasRepository(),
        child: const CanvasHomePage(),
      ),
    );
  }
}

// ————— MODELS —————
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

// ————— REPOSITORY —————
class CanvasRepository {
  // 👉 swap to your proxy URL in web builds
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
        'context_codes[]': ctx, // multiple allowed
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

// ————— BLoC —————
sealed class CanvasEvent {}

class LoadCourses extends CanvasEvent {}

class LoadAnnouncements extends CanvasEvent {
  final List<String> contexts;
  LoadAnnouncements(this.contexts);
}

sealed class CanvasState {}

class CanvasInitial extends CanvasState {}

class CanvasLoading extends CanvasState {}

class CoursesReady extends CanvasState {
  final List<Course> courses;
  CoursesReady(this.courses);
}

class AnnouncementsReady extends CanvasState {
  final List<Announcement> announcements;
  AnnouncementsReady(this.announcements);
}

class CanvasError extends CanvasState {
  final String msg;
  CanvasError(this.msg);
}

class CanvasBloc extends Bloc<CanvasEvent, CanvasState> {
  final CanvasRepository repo;
  CanvasBloc(this.repo) : super(CanvasInitial()) {
    on<LoadCourses>((_, emit) async {
      emit(CanvasLoading());
      try {
        emit(CoursesReady(await repo.fetchCourses()));
      } catch (e) {
        emit(CanvasError(e.toString()));
      }
    });
    on<LoadAnnouncements>((event, emit) async {
      emit(CanvasLoading());
      try {
        emit(AnnouncementsReady(await repo.fetchAnnouncements(event.contexts)));
      } catch (e) {
        emit(CanvasError(e.toString()));
      }
    });
  }
}

// ————— UI —————
class CanvasHomePage extends StatefulWidget {
  const CanvasHomePage({super.key});
  @override
  State<CanvasHomePage> createState() => _CanvasHomePageState();
}

class _CanvasHomePageState extends State<CanvasHomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = CanvasBloc(context.read<CanvasRepository>());
    return BlocProvider(
      create: (_) => bloc..add(LoadCourses()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Canvas Dash – AppRegin'),
          bottom: TabBar(
            controller: _tab,
            onTap: (i) {
              if (i == 0) bloc.add(LoadCourses());
              if (i == 1) {
                // tweak context list to taste
                bloc.add(LoadAnnouncements(['course_101', 'user_${12345}']));
              }
            },
            tabs: const [
              Tab(text: 'Courses', icon: Icon(Icons.school)),
              Tab(text: 'Announcements', icon: Icon(Icons.campaign)),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tab,
          children: const [_CoursesView(), _AnnouncementsView()],
        ),
      ),
    );
  }
}

class _CoursesView extends StatelessWidget {
  const _CoursesView();
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<CanvasBloc, CanvasState>(builder: (_, state) {
        if (state is CanvasLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CoursesReady) {
          return ListView.separated(
            itemCount: state.courses.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (_, i) => ListTile(
              leading: const Icon(Icons.class_),
              title: Text(state.courses[i].name),
              subtitle: Text(state.courses[i].code),
            ),
          );
        } else if (state is CanvasError) {
          return Center(child: Text(state.msg));
        }
        return const SizedBox.shrink();
      });
}

class _AnnouncementsView extends StatelessWidget {
  const _AnnouncementsView();
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<CanvasBloc, CanvasState>(builder: (_, state) {
        if (state is CanvasLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AnnouncementsReady) {
          return ListView.builder(
            itemCount: state.announcements.length,
            itemBuilder: (_, i) {
              final a = state.announcements[i];
              return ExpansionTile(
                leading: const Icon(Icons.campaign_outlined),
                title: Text(a.title),
                subtitle:
                    Text(a.postedAt.toLocal().toString().split(".").first),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SelectableText(a.message,
                        style: const TextStyle(height: 1.4)),
                  ),
                ],
              );
            },
          );
        } else if (state is CanvasError) {
          return Center(child: Text(state.msg));
        }
        return const SizedBox.shrink();
      });
}
