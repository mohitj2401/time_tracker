import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:time_tracker/models/category.dart';
import 'package:time_tracker/models/tasks.dart';
import 'package:time_tracker/services/category_service.dart';
import 'package:time_tracker/services/task_service.dart';
import 'package:time_tracker/util/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Logger logger = Logger();
  TextEditingController name = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController description = TextEditingController();

  int selectedTask = 0;
  // List<Category> catogories = [];
  List<DropdownMenuItem> items = [];
  int selectedItem = 0;
  List<Tasks> tasks = [];
  TaskService taskService = TaskService();

  getCategory() async {
    CategoryService service = CategoryService();
    items.add(DropdownMenuItem(
      child: Text("Select Task Catgeory"),
      value: 0,
    ));
    service.getAllCategory().then((value) {
      value.forEach((element) {
        items.add(DropdownMenuItem(
          child: Text(element.name!),
          value: element.id,
        ));
      });
      getTask();
    });
  }

  getTask() async {
    tasks = await taskService.getAllTask();
    setState(() {});
  }

  saveTask() {
    Tasks task = new Tasks(
      category_id: selectedItem,
      date: date.text,
      time: '00:00:00',
      name: name.text,
      description: description.text,
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
    );
    taskService.insertTask(task);
    Navigator.pop(context);
    getTask();
  }

  @override
  void initState() {
    getCategory();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: ThemeProvide.appColor,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Text(
          'Self Time Tracker',
          // style: ThemeProvider.titleStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet<void>(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      height: 300,
                      child: SingleChildScrollView(child: StatefulBuilder(
                        builder: (context, setState) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                child: const Text(
                                  "Add Task",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                height: 20.sp,
                              ),
                              Container(
                                child: TextFormField(
                                  controller: name,
                                  cursorColor: ThemeProvider.whiteColor,
                                  style: const TextStyle(fontSize: 16),
                                  decoration: const InputDecoration(
                                    // contentPadding: EdgeInsets.zero,
                                    hintText: 'Task Name',
                                    border: OutlineInputBorder(),
                                    hintStyle: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              DropdownButton(
                                isExpanded: true,
                                value: selectedItem,
                                items: items,
                                onChanged: (val) {
                                  // logger.i(val);
                                  setState(() {
                                    selectedItem = val;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: TextFormField(
                                  onTap: () async {
                                    DateTime? d = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now()
                                          .subtract(Duration(days: 365)),
                                      lastDate: DateTime.now()
                                          .add(Duration(days: 30)),
                                    );
                                    if (d != null) {
                                      date.text = d.toString().split(' ')[0];
                                    }
                                  },
                                  controller: date,
                                  cursorColor: ThemeProvider.whiteColor,
                                  style: const TextStyle(fontSize: 16),
                                  decoration: const InputDecoration(
                                    // contentPadding: EdgeInsets.zero,
                                    hintText: 'Date',
                                    border: OutlineInputBorder(),
                                    hintStyle: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              // Container(
                              //   child: TextFormField(
                              //     controller: time,
                              //     cursorColor: ThemeProvider.whiteColor,
                              //     style: const TextStyle(fontSize: 16),
                              //     decoration: const InputDecoration(
                              //       // contentPadding: EdgeInsets.zero,
                              //       hintText: 'Time',
                              //       border: OutlineInputBorder(),
                              //       hintStyle: TextStyle(fontSize: 16),
                              //     ),
                              //     onTap: () async {
                              //       Duration? duration =
                              //           await showDurationPicker(
                              //               context: context,
                              //               initialTime: Duration(minutes: 30));
                              //       if (duration != null) {
                              //         time.text =
                              //             duration.toString().split('.')[0];
                              //       }
                              //     },
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              Container(
                                child: TextFormField(
                                  minLines: 3,
                                  maxLines: 5,
                                  controller: description,
                                  cursorColor: ThemeProvider.whiteColor,
                                  style: const TextStyle(fontSize: 16),
                                  decoration: const InputDecoration(
                                    // contentPadding: EdgeInsets.zero,
                                    hintText: 'Description',
                                    border: OutlineInputBorder(),
                                    hintStyle: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    saveTask();
                                  },
                                  child: Text('Save'))
                            ],
                          );
                        },
                      )),
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.add_circle_outline),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(tasks[index].name),
                  ),
                );
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int value) {
          if (value == 1) {
            Get.toNamed('/catogories');
          }
          logger.i(value);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Category'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Report'),
        ],
      ),
      // drawer: Drawer(
      //   child: ListView(
      //     children: [
      //       ListTile(
      //         onTap: () {},
      //         title: Text("Category"),
      //       ),
      //       ListTile(
      //         onTap: () {},
      //         title: Text("Category"),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
