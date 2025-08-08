import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/todo.dart';

// Main todos state using AsyncNotifier for loading states
class TodoNotifier extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    // Simulate initial loading (can be replaced with actual data fetching)
    await Future.delayed(const Duration(milliseconds: 100));
    return [];
  }

  // Optimized add todo - minimal state updates
  Future<void> addTodo(Todo todo) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final current = state.value ?? [];
      return [...current, todo];
    });
  }

  // Optimized toggle - only updates specific item
  Future<void> toggleTodo(int id) async {
    final current = state.value ?? [];
    state = AsyncData([
      for (final todo in current)
        if (todo.id == id)
          todo.copyWith(isCompleted: !todo.isCompleted)
        else
          todo,
    ]);
  }

  // Optimized remove - efficient filtering
  Future<void> removeTodo(int id) async {
    final current = state.value ?? [];
    state = AsyncData(current.where((todo) => todo.id != id).toList());
  }

  // Batch operations for better performance
  Future<void> clearCompleted() async {
    final current = state.value ?? [];
    state = AsyncData(current.where((todo) => !todo.isCompleted).toList());
  }

  Future<void> toggleAll() async {
    final current = state.value ?? [];
    final hasIncomplete = current.any((todo) => !todo.isCompleted);

    state = AsyncData([
      for (final todo in current) todo.copyWith(isCompleted: hasIncomplete),
    ]);
  }
}

// Individual todo provider for minimal rebuilds
final todoItemProvider = Provider.family<Todo?, int>((ref, id) {
  final todos = ref.watch(todoProvider);
  return todos.when(
    data: (todos) => todos.firstWhere((todo) => todo.id == id),
    loading: () => null,
    error: (_, __) => null,
  );
});

// Computed providers for derived state
final todoStatsProvider = Provider<Map<String, int>>((ref) {
  final todosAsync = ref.watch(todoProvider);
  return todosAsync.when(
    data: (todos) => {
      'total': todos.length,
      'completed': todos.where((t) => t.isCompleted).length,
      'remaining': todos.where((t) => !t.isCompleted).length,
    },
    loading: () => {'total': 0, 'completed': 0, 'remaining': 0},
    error: (_, __) => {'total': 0, 'completed': 0, 'remaining': 0},
  );
});

final hasCompletedTodosProvider = Provider<bool>((ref) {
  final todos = ref.watch(todoProvider);
  return todos.when(
    data: (todos) => todos.any((todo) => todo.isCompleted),
    loading: () => false,
    error: (_, __) => false,
  );
});

// Main provider
final todoProvider = AsyncNotifierProvider<TodoNotifier, List<Todo>>(
  () => TodoNotifier(),
);
