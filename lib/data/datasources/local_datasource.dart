import 'package:hive/hive.dart';
import '../models/task_model.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class LocalDatasource {
  var uuid = const Uuid();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> showNotificationAtReminder(TaskModel task) async {
    if (await Permission.notification.isGranted) {
      if (await Permission.scheduleExactAlarm.isGranted) {
        if (task.remind != null) {
          var remindDateTime = task.remind!;

          var jakarta = tz.getLocation('Asia/Jakarta');

          var time = tz.TZDateTime.from(remindDateTime, jakarta);

          if (time.isBefore(DateTime.now())) {
            throw Exception('Reminder time has passed: $time');
          }

          var androidChannelSpecifics = const AndroidNotificationDetails(
            'CHANNEL_ID 4',
            'Task Reminder',
            channelDescription: "Task reminder for your tasks",
            importance: Importance.max,
            priority: Priority.high,
            styleInformation: DefaultStyleInformation(true, true),
          );

          var platformChannelSpecifics = NotificationDetails(
            android: androidChannelSpecifics,
          );

          await flutterLocalNotificationsPlugin.zonedSchedule(
            0,
            'Reminder ${task.title}',
            'You have a task for ${remindDateTime.hour}:${remindDateTime.minute.toString().padLeft(2, '0')}',
            time,
            platformChannelSpecifics,
            androidScheduleMode: AndroidScheduleMode.exact,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );
        }
      } else {
        await Permission.scheduleExactAlarm.request();
      }
    } else {
      await Permission.notification.request();
    }
  }

  Future<List<TaskModel?>> getAllTasks() async {
    try {
      var box = await Hive.openBox('task');

      return box.values.toList().cast<TaskModel?>();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addTask(TaskModel model) async {
    try {
      var box = await Hive.openBox('task');
      TaskModel newTask = TaskModel(
        uid: uuid.v4().toString(),
        title: model.title,
        dateTime: model.dateTime,
        remind: model.remind,
        status: model.status,
        repeat: model.repeat,
      );
      showNotificationAtReminder(newTask);
      await box.put(newTask.uid, newTask);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTaskAtIndex(String id, TaskModel updatedTask) async {
    var box = await Hive.openBox('task');
    showNotificationAtReminder(updatedTask);
    await box.put(id, updatedTask);
  }

  Future<void> updateTaskStatusAtIndex(String? id, bool newStatus) async {
    var box = await Hive.openBox('task');
    TaskModel? currentTask = box.get(id);
    if (currentTask != null) {
      TaskModel updatedTask = TaskModel(
        uid: currentTask.uid,
        dateTime: (newStatus == true && currentTask.repeat == true)
            ? (currentTask.dateTime!.isBefore(DateTime.now())
                ? DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        currentTask.dateTime!.hour,
                        currentTask.dateTime!.minute)
                    .add(const Duration(days: 1)) // Set ke hari berikutnya
                : currentTask.dateTime
                    ?.add(const Duration(days: 1))) // Tetap tambahkan 1 hari
            : currentTask.dateTime,
        remind: (currentTask.remind != null)
            ? (newStatus == true && currentTask.repeat == true)
                ? (currentTask.remind!.isBefore(DateTime.now())
                    ? DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            currentTask.remind!.hour,
                            currentTask.remind!.minute)
                        .add(const Duration(days: 1)) // Set ke hari berikutnya
                    : currentTask.remind?.add(
                        const Duration(days: 1),
                      )) // Tetap tambahkan 1 hari
                : currentTask.remind
            : currentTask.remind,
        title: currentTask.title,
        repeat: currentTask.repeat,
        status: newStatus,
      );

      await box.put(id, updatedTask);
    }
  }

  Future<void> deleteTaskAtIndex(String id) async {
    var box = await Hive.openBox('task');
    await box.delete(id);
  }
}
