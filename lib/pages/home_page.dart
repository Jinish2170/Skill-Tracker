import 'package:flutter/material.dart';
import 'package:new_app/provider/module_provider.dart'; // Your model file
import 'package:new_app/pages/task_page.dart'; // Your task page file
import 'package:provider/provider.dart';

// Changed: Converted to a StatefulWidget to manage the TextEditingController
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Added: A controller to get text from the dialog's TextField
  final TextEditingController _moduleController = TextEditingController();

  @override
  void dispose() {
    // Added: Clean up the controller when the widget is removed
    _moduleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade100,
        title: Text(
          "SkillTrack",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          // Moved IconButton to actions for standard AppBar layout
          IconButton(
            onPressed: () => _showAddModuleDialog(context),
            icon: Icon(Icons.add, color: Colors.white, size: 30),
          ),
        ],
      ),
      // Added: Consumer widget to listen for changes in SkillTrackerModel
      body: Consumer<SkillTrackerModel>(
        builder: (context, skillProvider, child) {
          // Check if there are no modules to show a message
          if (skillProvider.modules.isEmpty) {
            return Container(
              color: Colors.blueAccent.shade100,
              child: Center(
                child: Text(
                  'Add your first skill module',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ),
            );
          }
          return Container(
            color: Colors.blueAccent.shade100,
            child: ListView.builder(
              itemCount: skillProvider.modules.length,
              itemBuilder: (context, index) {
                // Get the specific module for this list item
                final module = skillProvider.modules[index];
                return SizedBox(
                  height: 100,
                  child: Card(
                    shadowColor: Colors.blue,
                    color: Colors.white,
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Centers content vertically
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ListTile(
                          title: Text(
                            module.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // Pass the unique ID to the TaskPage
                                builder: (context) => TaskPage(moduleId: module.id),
                              ),
                            );
                          },

                          trailing: SizedBox(
                            width: 35, // Increased width for better spacing
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                skillProvider.deleteModule(module.id);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // Added: A separate function for the "Add Module" dialog for cleaner code
  void _showAddModuleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Skill Module"),
          content: TextField(
            controller: _moduleController, // Use the controller
            decoration: const InputDecoration(
              hintText: "e.g., Learn Guitar",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _moduleController.clear(); // Clear text field
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Changed: Call the provider's addModule method
                if (_moduleController.text.isNotEmpty) {
                  // Use Provider.of with listen: false inside a function
                  Provider.of<SkillTrackerModel>(context, listen: false)
                      .addModule(_moduleController.text);
                  _moduleController.clear(); // Clear text field
                  Navigator.of(context).pop();
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