import 'package:auto_route/auto_route.dart';
import 'package:todo_app_clean_riverpod/features/todo/presentation/pages/todo_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: TodoRoute.page, initial: true),
  ];
}
