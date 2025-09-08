import 'package:hive/hive.dart';
import 'package:yapilacaklar_listesi/models/task.dart';

abstract class localStorage {
  Future<void> addTask({required task task});
  Future<bool> deleteTask({required task task});
  Future<task?> getTask({required String id});
  Future<List<task>> getAllTask();
  Future<task> updateTask({required task task});
}

class hiveLocalStorage extends localStorage {
  late Box<task> _taskBox;
  hiveLocalStorage() {
    _taskBox = Hive.box('tasks');
  }
  @override
  Future<void> addTask({required task task}) async {
    await _taskBox.put(task.id, task);
  }

  @override
  Future<bool> deleteTask({required task task}) async {
    await task.delete();
    return true;
  }

  @override
  Future<List<task>> getAllTask() async {
    List<task> _allTask = <task>[];
    _allTask = _taskBox.values.toList();

    if (_allTask.isNotEmpty) {
      _allTask.sort((task a, task b) => b.created.compareTo(a.created));
    }
    return _allTask;
  }

  @override
  Future<task?> getTask({required String id})async {
    if (_taskBox.containsKey(id)) {
      return _taskBox.get(id);
    } else {
      return null;
    }
  }

  @override
  Future<task> updateTask({required task task}) async {
    await task.save();
    return task;
  }
}
