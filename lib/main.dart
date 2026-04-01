import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [
    Task(
      id: DateTime.now().toString(),
      title: 'Complete Homework',
      date: DateTime.now(),
      priority: 'High',
      notes: 'Math homework due tomorrow',
      category: 'School',
    ),
    Task(
      id: DateTime.now().toString(),
      title: 'Personal Project',
      date: DateTime.now().add(Duration(days: 3)),
      priority: 'Low',
      notes: 'Work on personal project',
      category: 'Personal',
    ),
  ];

  List<Task> get tasks {
    return [..._tasks];
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void completeTask(Task task) {
    final index = _tasks.indexOf(task);
    if (index != -1) {
      _tasks[index] = task.copyWith(completed: true);
      notifyListeners();
    }
  }
}

class Task {
  final String id;
  final String title;
  final DateTime date;
  final String priority;
  final String notes;
  final String category;
  final bool completed;

  Task({
    required this.id,
    required this.title,
    required this.date,
    required this.priority,
    required this.notes,
    required this.category,
    this.completed = false,
  });

  Task copyWith({bool? completed}) => Task(
        id: id,
        title: title,
        date: date,
        priority: priority,
        notes: notes,
        category: category,
        completed: completed ?? this.completed,
      );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskProvider>(context).tasks;

    return Scaffold(
      appBar: AppBar(
        title: Text('Student Planner'),
        backgroundColor: Colors.blue[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Today',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (ctx, index) {
                  return ListTile(
                    title: Text(tasks[index].title),
                    subtitle: Text(DateFormat.yMd().format(tasks[index].date)),
                    trailing: Container(
                      width: 100,
                      child: Text(
                        tasks[index].priority,
                        style: TextStyle(
                          fontSize: 16,
                          color: tasks[index].priority == 'High'
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Text(
              'Upcoming Deadlines',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (ctx, index) {
                  return ListTile(
                    title: Text(tasks[index].title),
                    subtitle: Text(DateFormat.yMd().format(tasks[index].date)),
                    trailing: Container(
                      width: 100,
                      child: Text(
                        tasks[index].priority,
                        style: TextStyle(
                          fontSize: 16,
                          color: tasks[index].priority == 'High'
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskListScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CalendarScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          }
        },
      ),
    );
  }
}

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskProvider>(context).tasks;

    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        backgroundColor: Colors.blue[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (ctx, index) {
            return Card(
              elevation: 5,
              child: ListTile(
                title: Text(tasks[index].title),
                subtitle: Text(DateFormat.yMd().format(tasks[index].date)),
                trailing: Container(
                  width: 100,
                  child: Text(
                    tasks[index].priority,
                    style: TextStyle(
                      fontSize: 16,
                      color: tasks[index].priority == 'High'
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AddTaskScreen extends StatelessWidget {
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _priorityController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
        backgroundColor: Colors.blue[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date'),
            ),
            TextField(
              controller: _priorityController,
              decoration: InputDecoration(labelText: 'Priority'),
            ),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(labelText: 'Notes'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<TaskProvider>(context, listen: false).addTask(
                  Task(
                    id: DateTime.now().toString(),
                    title: _titleController.text,
                    date: DateTime.parse(_dateController.text),
                    priority: _priorityController.text,
                    notes: _notesController.text,
                    category: 'School',
                  ),
                );
                Navigator.pop(context);
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        backgroundColor: Colors.blue[200],
      ),
      body: Center(
        child: Text('Calendar View'),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blue[200],
      ),
      body: Center(
        child: Text('Profile View'),
      ),
    );
  }
}