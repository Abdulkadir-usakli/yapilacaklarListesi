import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'task.g.dart';

@HiveType(typeId: 1)
class task extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  final DateTime created;
  @HiveField(3)
  bool isCompleted;

  task(
      {required this.id,
      required this.name,
      required this.created,
      required this.isCompleted});

  factory task.create({required String name, required DateTime created}) {
    return task(
        id: Uuid().v1(), name: name, created: created, isCompleted: false);
  }
}
