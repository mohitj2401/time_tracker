import 'package:duration/duration.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:time_tracker/models/tasks.dart';
import 'package:time_tracker/services/task_service.dart';
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
  Logger log = Logger();
  TextEditingController name = TextEditingController();
  TaskService service = TaskService();

  late Tasks task;
  @override
  void initState() {
    // log.i(arguments.name);
    task = arguments;
    name.text = task.name;
    // TODO: implement initState
    super.initState();
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
          "Task Detail",
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
            onPressed: () {},
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        width: 100.w,
        height: 100.h,
        child: Column(
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
                      task.time = duration.toString().split('.')[0];
                      TaskService service = TaskService();
                      service.updateTask(task);
                    }
                    isEdit = true;

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
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
