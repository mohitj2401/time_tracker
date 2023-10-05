import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:time_tracker/controllers/theme_controller.dart';
import 'package:time_tracker/models/tasks.dart';
import 'package:time_tracker/providers/theme_provider.dart';
import 'package:time_tracker/services/category_service.dart';
import 'package:time_tracker/services/task_service.dart';
import 'package:time_tracker/util/theme.dart';
import 'package:time_tracker/util/toast.dart';

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
  final ThemeController myController = Get.put(ThemeController());
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  // int selectedTask = 0;
  // List<Category> catogories = [];
  List<DropdownMenuItem> items = [];
  int selectedItem = 0;
  List<Tasks> tasks = [];
  TaskService taskService = TaskService();

  int selectedTimer = 0;
  int selectedTimerTime = 0;

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

  timerExist() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? val = pref.getBool('TIMER_EXIST');
    if (val != null && val) {
      String? DTval = pref.getString('DT');
      // logger.i(DTval);
      DateTime d = DateTime.parse(DTval!);
      // logger.i(d);
      DateTime d2 = DateTime.now();
      // logger.i(d2);

      Duration compareResult = d2.difference(d);
      // logger.i(compareResult);

      int? timerId = pref.getInt('TIMER_ID');
      // logger.i(timerId);
      if (timerId != null && timerId > 1) {
        selectedTimer = timerId;
        _stopWatchTimer.setPresetSecondTime(compareResult.inSeconds);
        _stopWatchTimer.onStartTimer();
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    getCategory();
    timerExist();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProviders>(context);
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: ThemeProvide.appColor,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Text(
          'Time Tracker',
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
                if (selectedTimer == tasks[index].id) {
                  return Card(
                    elevation: 2,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Text((index + 1).toString()),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(tasks[index].name),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          StreamBuilder<int>(
                            stream: _stopWatchTimer.rawTime,
                            initialData: 0,
                            builder: (context, snap) {
                              // print(snap.data);
                              final value = snap.data;
                              selectedTimerTime = value!;
                              final displayTime = StopWatchTimer.getDisplayTime(
                                  value,
                                  milliSecond: false);
                              return Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      displayTime,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Helvetica',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          IconButton(
                            onPressed: () async {
                              _stopWatchTimer.onStopTimer();

                              selectedTimer = 0;
                              String time =
                                  Duration(milliseconds: selectedTimerTime)
                                      .toString()
                                      .split('.')[0];
                              tasks[index].time = time;
                              taskService.updateTask(tasks[index]);
                              selectedTimerTime = 0;
                              _stopWatchTimer.onResetTimer();
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              pref.setBool('TIMER_EXIST', false);
                              setState(() {});
                            },
                            icon: Icon(Icons.pause_circle),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return InkWell(
                  onTap: () {
                    // Get.changeTheme(ThemeData.light(useMaterial3: true));
                    themeProvider.updateTheme(1);
                    // myController.toggleTheme();
                  },
                  child: Card(
                    elevation: 2,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Text((index + 1).toString()),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(tasks[index].name),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          Text(tasks[index].time),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  // print(tasks[index].time);
                                  int val =
                                      parseTime("${tasks[index].time}.0000")
                                          .inSeconds;
                                  // print(val);
                                  // _stopWatchTimer.onResetTimer();
                                  _stopWatchTimer.setPresetSecondTime(val,
                                      add: false);
                                  _stopWatchTimer.onStartTimer();
                                  selectedTimer = tasks[index].id!;
                                  selectedTimerTime = 0;
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  pref.setBool('TIMER_EXIST', true);
                                  pref.setString(
                                      'DT', DateTime.now().toString());
                                  pref.setInt('TIMER_ID', selectedTimer);
                                  setState(() {});
                                },
                                icon: Icon(Icons.play_circle),
                              ),
                              IconButton(
                                onPressed: () async {
                                  // print(tasks[index].time);
                                  bool val = await notificationDialog("Warning",
                                      "You already have time stored for this task.");
                                  // print(val);
                                  if (val) {
                                    taskService.deleteTask(tasks[index].id!);
                                    tasks.removeWhere((element) =>
                                        element.id == tasks[index].id);
                                    setState(() {});
                                  }
                                },
                                icon: Icon(Icons.delete),
                              ),
                              IconButton(
                                onPressed: () async {
                                  // print(tasks[index].time);
                                  bool val = await notificationDialog("Warning",
                                      "You already have time stored for this task.");
                                  // print(val);
                                  if (val) {
                                    tasks[index].time = '00:00:00';
                                    taskService.updateTask(tasks[index]);

                                    setState(() {});
                                  }
                                },
                                icon: Icon(Icons.restore),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
