import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnackBar Undo Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TodoSnackBarDemo(),
    );
  }
}

class TodoSnackBarDemo extends StatefulWidget {
  const TodoSnackBarDemo({super.key});

  @override
  State<TodoSnackBarDemo> createState() => _TodoSnackBarDemoState();
}

class _TodoSnackBarDemoState extends State<TodoSnackBarDemo> {
  final List<String> _tasks = [
    'Finish Flutter homework',
    'Review SnackBar widget',
    'Read one chapter of a book',
    'Go for a short walk',
  ];

  String? _lastRemovedTask;
  int? _lastRemovedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SnackBar: Undo delete'),
      ),
      body: ListView.separated(
        itemCount: _tasks.length,
        separatorBuilder: (context, index) => const Divider(height: 0),
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            title: Text(task),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _removeTask(index),
            ),
          );
        },
      ),
    );
  }

  void _removeTask(int index) {
    setState(() {
      _lastRemovedTask = _tasks[index];
      _lastRemovedIndex = index;
      _tasks.removeAt(index);
    });

    // Clear any existing SnackBar so they don't stack
    ScaffoldMessenger.of(context).clearSnackBars();

    final snackBar = SnackBar(
      // 1) backgroundColor: visual style
      backgroundColor: Colors.redAccent,

      // 2) behavior: default vs floating
      behavior: SnackBarBehavior.floating,

      // 3) duration: how long it stays visible
      duration: const Duration(seconds: 4),

      content: const Text('Task deleted'),
      action: SnackBarAction(
        label: 'UNDO',
        textColor: Colors.white,
        onPressed: _undoDelete,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _undoDelete() {
    if (_lastRemovedTask == null || _lastRemovedIndex == null) return;

    setState(() {
      _tasks.insert(_lastRemovedIndex!, _lastRemovedTask!);
    });

    _lastRemovedTask = null;
    _lastRemovedIndex = null;
  }
}
