import 'package:flutter/foundation.dart';
class Module {
  String name;
  List<Task> tasks;
  Module({required this.name, required this.tasks});
}

class Task {
  String name;
  bool isDone;
  DateTime dueDate;
  Task({required this.name, required this.dueDate, this.isDone = false});
}


class SkillTrackerModel extends ChangeNotifier {
  final List<Module> _modules = [];

  List<Module> get modules => _modules;


  void addModule(Module module) {
    _modules.add(module);
    notifyListeners();
  }

  void updateModule(Module module, int index) {
    _modules[index] = module;
    notifyListeners();
  }

  void deleteModule(int index) {
    _modules.removeAt(index);
    notifyListeners();
  }

  void addTask(Module module, Task task) {
    module.tasks.add(task);
    notifyListeners();
  }

  void updateTask(Module module, Task task, int taskIndex) {
    module.tasks[taskIndex] = task;
    notifyListeners();
  }

  void deleteTask(Module module, int taskIndex) {
    module.tasks.removeAt(taskIndex);
    notifyListeners();
  }

  void toggleTaskStatus(Module module, Task task) {
    task.isDone = !task.isDone;
    notifyListeners();
  }
}



