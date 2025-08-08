import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_clean_riverpod/features/todo/domain/entities/todo.dart';
import '../../providers/todo_provider.dart';

@RoutePage()
class TodoPage extends ConsumerStatefulWidget {
  const TodoPage({super.key});

  @override
  ConsumerState<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends ConsumerState<TodoPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Optimized Todo - Riverpod'),
        actions: [
          // Stats in app bar - only rebuilds when stats change
          Consumer(
            builder: (context, ref, child) {
              final stats = ref.watch(todoStatsProvider);
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text('${stats['remaining']}/${stats['total']}'),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Add todo input - minimal rebuilds
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'New todo...'),
                    onSubmitted: _addTodo,
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final isLoading = ref.watch(todoProvider).isLoading;
                    return TextButton(
                      onPressed: isLoading ? null : _addTodo,
                      child: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Add'),
                    );
                  },
                ),
              ],
            ),
          ),

          // Todo list with optimized rendering
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final todosAsync = ref.watch(todoProvider);

                return todosAsync.when(
                  data: (todos) {
                    if (todos.isEmpty) {
                      return const Center(child: Text('No todos'));
                    }

                    return ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        // Each todo item only rebuilds when its specific state changes
                        return OptimizedTodoItem(
                          key: ValueKey(todo.id),
                          todo: todo,
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                );
              },
            ),
          ),

          // Bulk actions - only shows when there are completed todos
          Consumer(
            builder: (context, ref, child) {
              final hasCompleted = ref.watch(hasCompletedTodosProvider);
              if (!hasCompleted) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () =>
                          ref.read(todoProvider.notifier).toggleAll(),
                      child: const Text('Toggle All'),
                    ),
                    TextButton(
                      onPressed: () =>
                          ref.read(todoProvider.notifier).clearCompleted(),
                      child: const Text('Clear Completed'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _addTodo([String? value]) {
    final text = (value ?? _controller.text).trim();
    if (text.isNotEmpty) {
      ref
          .read(todoProvider.notifier)
          .addTodo(
            Todo(
              id: DateTime.now().millisecondsSinceEpoch,
              title: text,
              isCompleted: false,
            ),
          );
      _controller.clear();
    }
  }
}

// Optimized todo item widget - only rebuilds when this specific todo changes
class OptimizedTodoItem extends ConsumerWidget {
  const OptimizedTodoItem({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Checkbox(
        value: todo.isCompleted,
        onChanged: (_) => ref.read(todoProvider.notifier).toggleTodo(todo.id),
      ),
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
          color: todo.isCompleted ? Colors.grey : null,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => ref.read(todoProvider.notifier).removeTodo(todo.id),
      ),
    );
  }
}
