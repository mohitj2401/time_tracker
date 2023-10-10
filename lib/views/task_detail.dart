import 'package:duration/duration.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:time_tracker/models/tasks.dart';
import 'package:time_tracker/services/category_service.dart';
import 'package:time_tracker/services/task_service.dart';
import 'package:time_tracker/util/theme.dart';
import 'package:time_tracker/util/toast.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({
    super.key,
  });
  // final Tasks task;
  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  bool isEdit = false;
  Tasks arguments = Get.arguments;
  int selectedItem = 0;
  Logger log = Logger();
  TextEditingController name = TextEditingController();
  TaskService service = TaskService();
  // TextEditingController name = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController description = TextEditingController();
  late Tasks task;
  List<DropdownMenuItem> items = [];

  getCategory() async {
    CategoryService service = CategoryService();
    items.add(const DropdownMenuItem(
      value: 0,
      child: Text("Select Task Catgeory"),
    ));
    service.getAllCategory().then((value) {
      for (var element in value) {
        items.add(DropdownMenuItem(
          value: element.id,
          child: Text(element.name!),
        ));
      }
      // getTask();
    });
  }

  @override
  void initState() {
    // log.i(arguments.name);
    task = arguments;
    name.text = task.name;
    time.text = task.time;
    selectedItem = task.category_id;
    getCategory();
    // TODO: implement initState
    super.initState();
  }

  editTask() {
    TaskService service = TaskService();

    if (name.text.isNotEmpty && selectedItem > 0) {
      task.time = time.text;
      task.name = name.text;
      task.category_id = selectedItem;
      task.description = description.text;

      service.updateTask(task);
      isEdit = false;
      setState(() {});
    } else {
      showToast("Please Enter Task Field or Select Category", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back(result: isEdit);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        // backgroundColor: ThemeProvider.appColor,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Text(
          isEdit ? "Edit Task" : "Task Detail",
          // style: ThemeProvider.titleStyle,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              bool val = await notificationDialog(
                  "Warning", "You already have time stored for this task.");
              // print(val);
              if (val) {
                service.deleteTask(task.id!);
                Get.back(result: true);
                setState(() {});
              }
            },
            icon: Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {
              isEdit = true;
              setState(() {});
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        width: 100.w,
        height: 100.h,
        child: isEdit
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          editTask();
                        },
                        child: Text('Edit'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isEdit = false;
                          });
                        },
                        child: Text('Go Back'),
                      )
                    ],
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
                  Container(
                    child: TextFormField(
                      controller: time,
                      cursorColor: ThemeProvider.whiteColor,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        // contentPadding: EdgeInsets.zero,
                        hintText: 'Time Conpleted',
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(fontSize: 16),
                      ),
                      onTap: () async {
                        Duration inital = parseTime("${task.time}.0000");
                        Duration? duration = await showDurationPicker(
                            context: context, initialTime: inital);
                        if (duration != null) {
                          String time_cal = duration.toString().split('.')[0];
                          String hr = time_cal.split(':')[0];
                          String min = time_cal.split(':')[1];
                          String sec = time_cal.split(':')[2];
                          if (hr.length < 2) {
                            time_cal = '0' + hr + ':' + min + ":" + sec;
                          }
                          time.text = time_cal;
                          // TaskService service = TaskService();
                          // service.updateTask(task);
                        }
                        setState(() {});
                      },
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
                  // ElevatedButton(
                  //     onPressed: () {
                  //       saveTask();
                  //     },
                  //     child: const Text('Save'))
                ],
              )
            : Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 30.w,
                            child: Text(
                              task.name,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          Container(
                            child: Text(
                              DateFormat('MMMM d , y').format(task.created_at!),
                              // style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () async {
                          // log.i(task.time);
                          Duration inital = parseTime("${task.time}.0000");
                          Duration? duration = await showDurationPicker(
                              context: context, initialTime: inital);
                          if (duration != null) {
                            String time_cal = duration.toString().split('.')[0];
                            String hr = time_cal.split(':')[0];
                            String min = time_cal.split(':')[1];
                            String sec = time_cal.split(':')[2];
                            if (hr.length < 2) {
                              time_cal = '0' + hr + ':' + min + ":" + sec;
                            }
                            // time.text = time_cal;
                            task.time = time_cal;
                            TaskService service = TaskService();
                            service.updateTask(task);
                          }
                          // isEdit = true;

                          setState(() {});
                        },
                        child: Text(task.time,
                            style: Theme.of(context).textTheme.displaySmall),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Container(
                    child: Text(
                      "Description",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      task.description!,
                      // style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
