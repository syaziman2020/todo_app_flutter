class TaskModel {
  final String title;
  final DateTime dateTime;
  final bool status;
  final bool repeat;
  TaskModel({
    required this.title,
    required this.dateTime,
    this.status = false,
    this.repeat = false,
  });
}
