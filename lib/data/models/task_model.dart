import 'package:hive/hive.dart';
part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final DateTime dateTime;
  @HiveField(2)
  final DateTime? remind;
  @HiveField(3)
  final bool status;
  @HiveField(4)
  final bool repeat;
  TaskModel({
    required this.title,
    required this.dateTime,
    this.remind,
    this.status = false,
    this.repeat = false,
  });
}
