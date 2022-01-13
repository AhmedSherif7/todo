import 'package:get/get.dart';

import '../db/db_helper.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  final RxList<Task> tasksList = <Task>[].obs;

  Future<int> addTask({required Task task}) {
    return DbHelper.insert(task);
  }

  Future<void> getTasks() async {
    final tasks = await DbHelper.query();
    tasksList.assignAll(tasks.map((task) => Task.fromJson(task)).toList());
  }

  void delete(int id) async {
    await DbHelper.delete(id);
    getTasks();
  }

  void deleteAll() async {
    await DbHelper.deleteAll();
    getTasks();
  }

  void markAsCompleted(int id) async {
    await DbHelper.update(id);
    getTasks();
  }
}
