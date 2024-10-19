import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task_model.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tl;

class LocalDatasource {
  var uuid = const Uuid();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> showNotificationAtReminder(TaskModel task) async {
    if (await Permission.notification.isGranted) {
      if (await Permission.scheduleExactAlarm.isGranted) {
        if (task.remind != null) {
          var remindDateTime = task.remind!;
          var selectDateTime = task.dateTime!;

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
            task.uid.hashCode,
            'Reminder ${task.title}',
            'You have a task for ${selectDateTime.hour}:${selectDateTime.minute.toString().padLeft(2, '0')}',
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
      if (newTask.status == false) {
        await flutterLocalNotificationsPlugin.cancel(newTask.uid.hashCode);
      } else {
        await showNotificationAtReminder(newTask);
      }
      await box.put(newTask.uid, newTask);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTaskAtIndex(TaskModel updatedTask) async {
    var box = await Hive.openBox('task');
    if (updatedTask.status == true) {
      await flutterLocalNotificationsPlugin.cancel(updatedTask.uid.hashCode);
    } else {
      showNotificationAtReminder(updatedTask);
    }

    await box.put(updatedTask.uid, updatedTask);
  }

  Future<void> updateTaskStatusAtIndex(String? id, bool newStatus) async {
    var box = await Hive.openBox('task');
    TaskModel? currentTask = box.get(id);
    if (currentTask != null) {
      TaskModel updatedTask = TaskModel(
        uid: currentTask.uid,
        dateTime: (newStatus == true && currentTask.repeat == true)
            ? DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    currentTask.dateTime!.hour,
                    currentTask.dateTime!.minute)
                .add(currentTask.dateTime!.isBefore(DateTime.now())
                    ? const Duration(
                        days: 1) // Tambahkan 1 hari jika waktu sudah lewat
                    : const Duration(
                        days:
                            1)) // Tetap tambahkan 1 hari jika waktu belum lewat
            : (newStatus == false && currentTask.repeat == true)
                ? DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    currentTask.dateTime!.hour,
                    currentTask.dateTime!.minute)
                : currentTask.dateTime,
        remind: (newStatus == true && currentTask.repeat == true)
            ? DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    currentTask.remind!.hour,
                    currentTask.remind!.minute)
                .add(currentTask.remind!.isBefore(DateTime.now())
                    ? const Duration(
                        days: 1) // Tambahkan 1 hari jika waktu sudah lewat
                    : const Duration(
                        days:
                            1)) // Tetap tambahkan 1 hari jika waktu belum lewat
            : (newStatus == false && currentTask.repeat == true)
                ? DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    currentTask.remind!.hour,
                    currentTask.remind!.minute)
                : currentTask.remind,
        title: currentTask.title,
        repeat: currentTask.repeat,
        status: newStatus,
      );

      if (newStatus == true) {
        await flutterLocalNotificationsPlugin.cancel(updatedTask.uid.hashCode);
      } else {
        showNotificationAtReminder(currentTask);
      }

      await box.put(id, updatedTask);
    }
  }

  Future<void> deleteTaskAtIndex(String id) async {
    var box = await Hive.openBox('task');

    await flutterLocalNotificationsPlugin.cancel(id.hashCode);

    await box.delete(id);
  }

  Future<void> changeTaskClosedApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    tl.initializeTimeZones();
    Hive.registerAdapter(TaskModelAdapter());
    var box = await Hive.openBox('task');
    List<TaskModel?> tasks = box.values.toList().cast<TaskModel?>();
    List<TaskModel?> repeatedTasks =
        tasks.where((task) => task?.repeat == true).toList();

    for (var task in repeatedTasks) {
      if (task != null && task.dateTime != null) {
        DateTime now = DateTime.now();
        DateTime today = DateTime(now.year, now.month, now.day);
        DateTime taskDateTime = task.dateTime!;
        DateTime? taskRemind = task.remind;
        DateTime todayTaskTime = DateTime(now.year, now.month, now.day,
            taskDateTime.hour, taskDateTime.minute);

        if (todayTaskTime.isBefore(today)) {
          task.dateTime = todayTaskTime;
          task.status = false;
        }

        if (task.remind != null) {
          DateTime todayTaskRemind = DateTime(now.year, now.month, now.day,
              taskRemind!.hour, taskRemind.minute);
          if (todayTaskRemind.isBefore(today)) {
            task.remind = todayTaskRemind;
          }
        }
      }
    }
  }
}
