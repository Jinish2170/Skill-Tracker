import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // A great package for formatting dates
import 'package:new_app/provider/module_provider.dart'; // Your model file
import 'package:provider/provider.dart';

class TaskPage extends StatefulWidget {
  final String moduleId;
  const TaskPage({super.key, required this.moduleId});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  // Added: A controller for the new task's name
  final TextEditingController _taskController = TextEditingController();
  DateTime? selectedDate;
  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SkillTrackerModel>(
      builder: (context, skillProvider, child) {
        final module = skillProvider.modules.firstWhere(
          (m) => m.id == widget.moduleId,
        );

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent.shade100,
            title: Text(
              module.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => _showAddTaskDialog(context, module.id),
                icon: Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ],
          ),
          body: module.tasks.isEmpty
              ? Container(
                  color: Colors.blueAccent.shade100,
                  child: Center(
                    child: Text(
                      'Add your first task',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                )
              : Container(
                  color: Colors.blueAccent.shade100,
                  child: ListView.builder(
                    itemCount: module.tasks.length,
                    itemBuilder: (context, index) {
                      // Get the specific task for this list item
                      final task = module.tasks[index];
                      return Card(
                        shadowColor: Colors.blue,
                        color: Colors.white,
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          // The checkbox to toggle the task's status
                          title: Text(
                            task.name,
                            // Add a line-through style if the task is done
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          // Display the formatted due date
                          subtitle: Text(
                            'Due: ${DateFormat.yMMMd().format(task.dueDate)}',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          // The delete button for the task
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  // Call the provider's method to delete the task
                                  skillProvider.deleteTask(module.id, task.id);
                                },
                              ),
                              Checkbox(
                                value: task.isDone,
                                onChanged: (value) {
                                  // Call the provider's method to toggle the status
                                  skillProvider.toggleTaskStatus(
                                    module.id,
                                    task.id,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }

  // A function to show the dialog for adding a new task
  void _showAddTaskDialog(BuildContext context, String moduleId) {
    DateTime? selectedDate; // Variable to hold the chosen due date

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Task"),
          content: Column(
            mainAxisSize:
                MainAxisSize.min, // Make the column take minimum space
            children: [
              TextField(
                controller: _taskController,
                decoration: const InputDecoration(
                  hintText: "Enter task name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              // A button to open the date picker
              TextButton.icon(
                icon: Icon(Icons.calendar_today),
                label: Text(
                  selectedDate == null
                      ? 'Select Due Date'
                      // Use the intl package to format the date nicely
                      : 'Due: ${DateFormat.yMMMd().format(selectedDate!)}',
                ),
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != selectedDate) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _taskController.clear();
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Check if a name was entered and a date was selected
                if (_taskController.text.isNotEmpty && selectedDate != null) {
                  Provider.of<SkillTrackerModel>(
                    context,
                    listen: false,
                  ).addTaskToModule(
                    moduleId,
                    _taskController.text,
                    selectedDate!,
                  );
                  _taskController.clear();
                  Navigator.of(context).pop();
                }
                ;
                if (selectedDate == null) {
                  // 2. Show a SnackBar alert message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select a due date.'),
                      backgroundColor: Colors.red,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  );
                  return; // Stop the function here
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
