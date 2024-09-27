import 'package:hive/hive.dart';
import '../models/task_model.dart';

class LocalDatasource {
  Future<List<TaskModel?>> getAllTasks() async {
    try {
      var box = await Hive.openBox('task');
      return box.values.toList().cast<TaskModel?>();
    } catch (e) {
      rethrow;
    }
  }

  Future<TaskModel?> getTaskAtIndex(int index) async {
    var box = await Hive.openBox('task');
    return box.getAt(index);
  }

  Future<void> addTask(TaskModel model) async {
    try {
      var box = await Hive.openBox('task');
      box.add(model);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTaskAtIndex(int index, TaskModel updatedTask) async {
    var box = await Hive.openBox('task');
    await box.putAt(index, updatedTask);
  }
}
