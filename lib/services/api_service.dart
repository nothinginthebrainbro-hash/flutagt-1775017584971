// api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _baseUrl = 'https://your-backend-api.com';
  static const String _tasksEndpoint = '/tasks';
  static const String _calendarEndpoint = '/calendar';
  static const String _profileEndpoint = '/profile';

  Future<List<Task>> getTasks() async {
    final response = await http.get(Uri.parse('$_baseUrl$_tasksEndpoint'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((task) => Task.fromJson(task))
          .toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<Task> addTask(Task task) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_tasksEndpoint'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(task),
    );
    if (response.statusCode == 201) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add task');
    }
  }

  Future<List<CalendarEvent>> getCalendarEvents() async {
    final response = await http.get(Uri.parse('$_baseUrl$_calendarEndpoint'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((event) => CalendarEvent.fromJson(event))
          .toList();
    } else {
      throw Exception('Failed to load calendar events');
    }
  }

  Future<Profile> getProfile() async {
    final response = await http.get(Uri.parse('$_baseUrl$_profileEndpoint'));
    if (response.statusCode == 200) {
      return Profile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }
}

class Task {
  int id;
  String title;
  DateTime date;
  String priority;
  String notes;

  Task({required this.id, required this.title, required this.date, required this.priority, required this.notes});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      priority: json['priority'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'priority': priority,
      'notes': notes,
    };
  }
}

class CalendarEvent {
  int id;
  String title;
  DateTime date;

  CalendarEvent({required this.id, required this.title, required this.date});

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
    };
  }
}

class Profile {
  int id;
  String name;
  String email;

  Profile({required this.id, required this.name, required this.email});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}