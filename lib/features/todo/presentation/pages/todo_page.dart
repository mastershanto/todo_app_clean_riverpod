import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app_clean_riverpod/core/theme/app_text_styles.dart';
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
    final todos = ref.watch(todoProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'ADD Car Todo',
          style: AppTextStyles.textStylec24c333333NunitoSans700.copyWith(
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6D5FFD), Color(0xFF46A6FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.08),
                    blurRadius: 16.r,
                    offset: Offset(0, 8.h),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: AppTextStyles.textStylec16c333333NunitoSans700,
                      decoration: InputDecoration(
                        hintText: 'What needs to be done?',
                        hintStyle:
                            AppTextStyles.textStylec12cB7BAC0NunitoSans600,
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 250),
                    transitionBuilder: (child, anim) =>
                        ScaleTransition(scale: anim, child: child),
                    child: _controller.text.trim().isNotEmpty
                        ? Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12.r),
                              onTap: () {
                                final text = _controller.text.trim();
                                if (text.isNotEmpty) {
                                  ref
                                      .read(todoProvider.notifier)
                                      .addTodo(
                                        Todo(
                                          id: DateTime.now()
                                              .millisecondsSinceEpoch,
                                          title: text,
                                          isCompleted: false,
                                        ),
                                      );
                                  _controller.clear();
                                  setState(() {});
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(10.r),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6.r,
                                      offset: Offset(0, 2.h),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Color(0xFF6D5FFD),
                                  size: 26.sp,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(width: 36.w),
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.h),
            Expanded(
              child: todos.isEmpty
                  ? Center(
                      child: Text(
                        'No todos yet. Add your first task!',
                        style: AppTextStyles.textStylec14c333333NunitoSans600
                            .copyWith(color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      itemCount: todos.length,
                      separatorBuilder: (_, __) => SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          decoration: BoxDecoration(
                            color: todo.isCompleted
                                ? Color(0xFFE0F7FA)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10.r,
                                offset: Offset(0, 4.h),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => ref
                                    .read(todoProvider.notifier)
                                    .toggleTodo(todo.id),
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  width: 28.w,
                                  height: 28.w,
                                  decoration: BoxDecoration(
                                    color: todo.isCompleted
                                        ? Color(0xFF6D5FFD)
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: todo.isCompleted
                                          ? Color(0xFF6D5FFD)
                                          : Colors.grey.shade300,
                                      width: 2.w,
                                    ),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: todo.isCompleted
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 20.sp,
                                        )
                                      : null,
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: AnimatedDefaultTextStyle(
                                  duration: Duration(milliseconds: 200),
                                  style: todo.isCompleted
                                      ? AppTextStyles
                                            .textStylec14c333333NunitoSans600
                                            .copyWith(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.grey,
                                            )
                                      : AppTextStyles
                                            .textStylec16c333333NunitoSans700,
                                  child: Text(todo.title),
                                ),
                              ),
                              AnimatedOpacity(
                                opacity: todo.isCompleted ? 1.0 : 0.7,
                                duration: Duration(milliseconds: 200),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                    size: 22.sp,
                                  ),
                                  onPressed: () => ref
                                      .read(todoProvider.notifier)
                                      .removeTodo(todo.id),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
