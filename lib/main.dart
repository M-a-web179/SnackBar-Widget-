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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
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

  final TextEditingController _taskController = TextEditingController();

  String? _lastRemovedTask;
  int? _lastRemovedIndex;

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        title: Text(
          'Today\'s Tasks',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.checklist_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Stay on track ✨',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Card with list
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.surface,
                        colorScheme.surfaceVariant.withOpacity(0.4),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: _tasks.isEmpty
                      ? Center(
                          child: Text(
                            'Nothing here yet.\nAdd a task below!',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.outline,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: _tasks.length,
                          separatorBuilder: (context, index) =>
                              Divider(height: 0, color: colorScheme.outlineVariant),
                          itemBuilder: (context, index) {
                            final task = _tasks[index];
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 18,
                                backgroundColor: colorScheme.primaryContainer,
                                child: Icon(
                                  Icons.bolt_rounded,
                                  color: colorScheme.onPrimaryContainer,
                                  size: 18,
                                ),
                              ),
                              title: Text(
                                task,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                'Tap delete to remove',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.outline,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete_forever_rounded,
                                  color: colorScheme.error,
                                ),
                                onPressed: () => _removeTask(index),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Input bar
          SafeArea(
            top: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        hintText: 'Add a new task...',
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                        prefixIcon: Icon(
                          Icons.star_rounded,
                          color: colorScheme.tertiary,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _addTask(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    onPressed: _addTask,
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addTask() {
    final text = _taskController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a task first'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _tasks.add(text);
    });
    _taskController.clear();

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task added 🎉'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _removeTask(int index) {
    setState(() {
      _lastRemovedTask = _tasks[index];
      _lastRemovedIndex = index;
      _tasks.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();

    final snackBar = SnackBar(
      backgroundColor: Colors.redAccent,
      behavior: SnackBarBehavior.floating,
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

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task restored'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
