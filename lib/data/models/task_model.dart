import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel {
  @HiveField(0)
  final String? uid;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final DateTime? dateTime;
  @HiveField(3)
  final DateTime? remind;
  @HiveField(4)
  final bool status;
  @HiveField(5)
  final bool repeat;

  TaskModel({
    this.uid,
    required this.title,
    required this.dateTime,
    this.remind,
    this.status = false,
    this.repeat = false,
  });
}
