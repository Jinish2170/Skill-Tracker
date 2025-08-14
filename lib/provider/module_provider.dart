import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Module {
  final String id;
  String name;
  List<Task> tasks;

  // The constructor now automatically assigns a unique ID.
  Module({required this.name, required this.tasks}) : id = uuid.v4();
}

class Task {
  final String id;
  String name;
  bool isDone;
  DateTime dueDate;

  // The constructor now automatically assigns a unique ID.
  Task({required this.name, required this.dueDate, this.isDone = false})
      : id = uuid.v4();
}

class SkillTrackerModel extends ChangeNotifier {
  final List<Module> _modules = [];

  List<Module> get modules => _modules;


  void addModule(String moduleName) {
    final newModule = Module(name: moduleName, tasks: []);
    _modules.add(newModule);
    notifyListeners();
  }



  void deleteModule(String moduleId) {
    _modules.removeWhere((m) => m.id == moduleId);
    notifyListeners();
  }


  void addTaskToModule(String moduleId, String taskName, DateTime dueDate) {
    final module = _modules.firstWhere((m) => m.id == moduleId);
    final newTask = Task(name: taskName, dueDate: dueDate);
    module.tasks.add(newTask);
    notifyListeners();
  }

  void toggleTaskStatus(String moduleId, String taskId) {
    final module = _modules.firstWhere((m) => m.id == moduleId);
    final task = module.tasks.firstWhere((t) => t.id == taskId);
    task.isDone = !task.isDone;
    notifyListeners();
  }

  void deleteTask(String moduleId, String taskId) {
    final module = _modules.firstWhere((m) => m.id == moduleId);
    module.tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }
}