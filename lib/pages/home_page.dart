import 'package:flutter/material.dart';
import 'package:new_app/provider/module_provider.dart';
import 'task_page.dart';

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade100,
        title: Row(
          children: [
            Text("SkillTrack" , style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white,),),
            Padding(
              padding: const EdgeInsets.only(left:222.0),
              child: IconButton(onPressed: (){
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Add New Skill Module"),
                      content: TextField(
                        decoration: const InputDecoration(
                          hintText: "Enter New Skill Module",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text("Add"),
                        ),
                      ],
                    );
                  },
                );
              }, icon: Icon(Icons.add, color: Colors.white)),
            )
          ],
        ),

    ),
      body: ListView.builder(
        itemCount: modules.length,
        itemBuilder: (context, index) => getRow(index),
      ),
    );
  }


  Widget getRow(int index) {
    return Card(
        shadowColor: Colors.blue,
        color: Colors.white,
        elevation: 4,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(modules[index].name , style: const TextStyle( fontSize: 20,fontWeight: FontWeight.bold)), // Added const
            ],
          ),
          trailing: SizedBox(
            width: 70,
            child: Row(
              children: [
                InkWell(
                    onTap:((){
                      modules.removeAt(index);
                    }),
                    child: const Icon(Icons.delete)), // Added const


                InkWell(
                    onTap:((){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const task_page()),
                      );
                    }),
                    child: const Icon(Icons.add)), // Added const
              ],
            ),
          ),
        )
    );
  }
}
