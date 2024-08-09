import 'package:flutter/material.dart';
import 'package:sql_todo_app/models/task_Model.dart';
import 'package:sql_todo_app/services/database_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();
  final DatabaseService _databaseService = DatabaseService.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("sqflite To Do App"),
        centerTitle: true,
      ),
      floatingActionButton: _addTaskButton(),
      body: _taskTable(),
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      backgroundColor: Colors.teal,
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text("Add Task"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: "Task..."),
                  ),
                  MaterialButton(
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      if (controller.text.isEmpty || controller.text == "")
                        return;
                      _databaseService.addTask(controller.text.trim());

                      setState(() {
                        controller.clear();
                      });
                      Navigator.pop(context);
                    },
                    child: Text("Done"),
                  )
                ],
              ),
            );
          },
        );
      },
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  Widget _taskTable() {
    return FutureBuilder(
        future: _databaseService.getTask(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.cyan,
              ),
            );

          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  TaskModel tasklist = snapshot.data![index];

                  if (snapshot.hasError) {
                    return Text("Error while loading");
                  } else if (snapshot.hasData) {
                    return Card(
                      child: ListTile(
                        onLongPress: () {
                          _databaseService.deleteTask(tasklist.id!);
                          setState(() {});
                        },
                        title: Text(tasklist.content!),
                        trailing: Checkbox(
                          onChanged: (v) {
                            _databaseService.updateTaskStatus(
                                tasklist.id!, v == true ? 1 : 0);
                            setState(() {});
                          },
                          value: tasklist.status == 1,
                        ),
                      ),
                    );
                  } else {
                    return Text("Error");
                  }
                });
          }
        });
  }
}
