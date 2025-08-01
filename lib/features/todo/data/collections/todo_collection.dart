import 'package:isar/isar.dart';

part 'todo_collection.g.dart';

@collection
class TodoCollection {
  Id id = Isar.autoIncrement;
  late String title;
  late bool isCompleted;
}
