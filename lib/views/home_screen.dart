import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:time_tracker/models/category.dart';
import 'package:time_tracker/models/tasks.dart';
import 'package:time_tracker/providers/theme_provider.dart';
import 'package:time_tracker/services/category_service.dart';
import 'package:time_tracker/services/task_service.dart';
import 'package:time_tracker/util/constant.dart';
import 'package:time_tracker/util/toast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isTodayTask = true;

  Logger logger = Logger();
  TextEditingController name = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController description = TextEditingController();

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  late SharedPreferences pref;
  List<Category> categories = [];
  ScrollController controller = ScrollController();
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
    items.add(const DropdownMenuItem(
      value: 0,
      child: Text("Select Task Catgeory"),
    ));

    service.getAllCategory().then((value) {
      categories = value;
      AppConstants.categories = value;
      for (var element in value) {
        items.add(DropdownMenuItem(
          value: element.id,
          child: Text(element.name!),
        ));
      }
      getTask();
    });
  }

  getTask() async {
    if (isTodayTask)
      tasks = await taskService.getTodayTask();
    else
      tasks = await taskService.getAllTask();

    setState(() {});
  }

  saveTask() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    logger.i(formattedDate);
    Tasks task = Tasks(
      category_id: selectedItem,
      date: formattedDate,
      time: '00:00:00',
      name: name.text,
      description: description.text,
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
    );
    taskService.insertTask(task);
    Navigator.pop(context);
    selectedItem = 0;
    name.text = '';
    description.text = '';
    setState(() {});
    getTask();
  }

  timerExist() async {
    pref = await SharedPreferences.getInstance();

    bool? val = pref.getBool('TIMER_EXIST');
    if (val != null && val) {
      String? DTval = pref.getString('DT');
      logger.i(DTval);
      DateTime d = DateTime.parse(DTval!);
      logger.i(d);
      DateTime d2 = DateTime.now();
      logger.i(d2);

      Duration compareResult = d2.difference(d);
      logger.i(compareResult.inSeconds);

      int? timerId = pref.getInt('TIMER_ID');
      logger.i(timerId);
      if (timerId != null && timerId > 0) {
        try {
          selectedTimer = timerId;
          _stopWatchTimer.setPresetSecondTime(compareResult.inSeconds);

          _stopWatchTimer.onStartTimer();
          setState(() {});
        } catch (e) {
          logger.e(e.toString());
        }
      }
    }

    int? themeNumber = pref.getInt('THEME');
    if (themeNumber != null) {
      context.read<ThemeProviders>().updateTheme(themeNumber);
      // themeProvider.updateTheme(themeNumber);
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
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProviders>(context);
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: ThemeProvide.appColor,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: const Text(
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: const Text(
                                      "Add Today's Task",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (name.text.isNotEmpty &&
                                          selectedItem > 0) {
                                        saveTask();
                                      } else {
                                        toast(
                                            "Please Enter Task Field or Select Category",
                                            context,
                                            isError: true);
                                      }
                                    },
                                    child: Text('Save'),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20.sp,
                              ),
                              Container(
                                child: TextFormField(
                                  controller: name,
                                  // cursorColor: ThemeProvider.whiteColor,
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
                                  minLines: 3,
                                  maxLines: 5,
                                  controller: description,
                                  // cursorColor: ThemeProvider.whiteColor,
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
                          );
                        },
                      )),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
          IconButton(
            onPressed: () {
              int nu = themeProvider.theme_number;
              pref.setInt('THEME', nu == 1 ? 0 : 1);

              themeProvider.updateTheme(nu == 1 ? 0 : 1);
            },
            icon: themeProvider.theme_number == 0
                ? Icon(Icons.light_mode_outlined)
                : Icon(Icons.dark_mode_outlined),
          )
        ],
      ),
      body: Container(
        height: 100.h,
        width: 100.w,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: categories.isEmpty
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      "Please add category first.",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Container(
                    child: Text(
                      "Or",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        CategoryService service = CategoryService();
                        bool res = await service.defaultcategories();
                        if (res) {
                          service.getAllCategory().then((value) {
                            categories = value;
                            AppConstants.categories = value;
                            for (var element in value) {
                              items.add(DropdownMenuItem(
                                value: element.id,
                                child: Text(element.name!),
                              ));
                            }
                            getTask();
                          });
                          setState(() {});
                          toast("Default category added", context);
                        } else {}
                      },
                      child: Text("Add default Category"))
                ],
              ))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 10.h,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              isTodayTask = false;
                              getTask();
                              setState(() {});
                            },
                            child: Card(
                              elevation: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: isTodayTask
                                      ? null
                                      : Theme.of(context)
                                          .colorScheme
                                          .secondary
                                          .withOpacity(0.4),
                                  border: isTodayTask
                                      ? null
                                      : Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text(
                                    "All (${!isTodayTask ? tasks.length : ''})"),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              isTodayTask = true;
                              getTask();
                              setState(() {});
                            },
                            child: Card(
                              elevation: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: !isTodayTask
                                      ? null
                                      : Theme.of(context)
                                          .colorScheme
                                          .secondary
                                          .withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(15),
                                  border: !isTodayTask
                                      ? null
                                      : Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text(
                                    "Today Tasks (${isTodayTask ? tasks.length : ''})"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 70.h,
                      width: 90.w,
                      child: ListView.builder(
                        controller: controller,
                        // primary: true,
                        shrinkWrap: true,
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          if (selectedTimer == tasks[index].id) {
                            return Card(
                              elevation: 2,
                              child: Container(
                                width: 90.w,
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(tasks[index].name),
                                      ),
                                    ),
                                    Expanded(
                                      child: StreamBuilder<int>(
                                        stream: _stopWatchTimer.rawTime,
                                        initialData: 0,
                                        builder: (context, snap) {
                                          // print(snap.data);
                                          final value = snap.data;
                                          selectedTimerTime = value!;
                                          final displayTime =
                                              StopWatchTimer.getDisplayTime(
                                                  value,
                                                  milliSecond: false);
                                          return Column(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Text(
                                                  displayTime,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: 'Helvetica',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () async {
                                          _stopWatchTimer.onStopTimer();

                                          selectedTimer = 0;
                                          String time = Duration(
                                                  milliseconds:
                                                      selectedTimerTime)
                                              .toString()
                                              .split('.')[0];
                                          String hr = time.split(':')[0];
                                          String min = time.split(':')[1];
                                          String sec = time.split(':')[2];
                                          if (hr.length < 2) {
                                            time = '0' +
                                                hr +
                                                ':' +
                                                min +
                                                ":" +
                                                sec;
                                          }
                                          tasks[index].time = time;
                                          taskService.updateTask(tasks[index]);
                                          selectedTimerTime = 0;
                                          _stopWatchTimer.onResetTimer();
                                          SharedPreferences pref =
                                              await SharedPreferences
                                                  .getInstance();
                                          pref.setBool('TIMER_EXIST', false);
                                          logger.i(time);
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.pause_circle),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return Card(
                            elevation: 2,
                            child: InkWell(
                              onTap: () {
                                context.go('/task-detail', extra: tasks[index]);

                                getTask();

                                // Get.changeTheme(ThemeData.light(useMaterial3: true));
                                // themeProvider.updateTheme(1);
                                // myController.toggleTheme();
                              },
                              child: Container(
                                width: 90.w,
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        // padding: const EdgeInsets.symmetric(
                                        //     horizontal: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              tasks[index].name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall,
                                            ),
                                            Text(
                                              AppConstants.categories
                                                  .firstWhere((element) =>
                                                      element.id ==
                                                      tasks[index].category_id)
                                                  .name!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(tasks[index].time),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          if (isTodayTask)
                                            IconButton(
                                              onPressed: () async {
                                                // print(tasks[index].time);
                                                int val = parseTime(
                                                        "${tasks[index].time}.0000")
                                                    .inSeconds;
                                                // print(val);
                                                // _stopWatchTimer.onResetTimer();
                                                _stopWatchTimer
                                                    .setPresetSecondTime(val,
                                                        add: false);
                                                _stopWatchTimer.onStartTimer();
                                                selectedTimer =
                                                    tasks[index].id!;
                                                selectedTimerTime = 0;
                                                SharedPreferences pref =
                                                    await SharedPreferences
                                                        .getInstance();
                                                pref.setBool(
                                                    'TIMER_EXIST', true);
                                                pref.setString(
                                                    'DT',
                                                    DateTime.now()
                                                        .subtract(Duration(
                                                            seconds: val))
                                                        .toString());
                                                pref.setInt(
                                                    'TIMER_ID', selectedTimer);
                                                setState(() {});
                                              },
                                              icon:
                                                  const Icon(Icons.play_circle),
                                            ),
                                          if (!isTodayTask)
                                            IconButton(
                                              alignment: Alignment.centerRight,
                                              onPressed: () async {
                                                // print(tasks[index].time);
                                                // bool val = await notificationDialog(
                                                //     "Warning",
                                                //     "You already have time stored for this task.");
                                                // print(val);
                                                bool val = true;
                                                if (val) {
                                                  taskService.deleteTask(
                                                      tasks[index].id!);
                                                  tasks.removeWhere((element) =>
                                                      element.id ==
                                                      tasks[index].id);
                                                  setState(() {});
                                                }
                                              },
                                              icon: const Icon(Icons.delete),
                                            ),
                                          if (isTodayTask)
                                            IconButton(
                                              onPressed: () async {
                                                bool val = true;

                                                // print(tasks[index].time);
                                                // bool val = await notificationDialog(
                                                //     "Warning",
                                                //     "You already have time stored for this task.");
                                                // print(val);
                                                if (val) {
                                                  tasks[index].time =
                                                      '00:00:00';
                                                  taskService
                                                      .updateTask(tasks[index]);

                                                  setState(() {});
                                                }
                                              },
                                              icon: const Icon(Icons.restore),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        onTap: (int value) {
          if (value == 1) {
            context.go('/catogories');
          }
          if (value == 2) {
            context.go('/report');
          }
          // logger.i(value);
        },
        items: const [
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
      floatingActionButton: tasks.length > 6
          ? FloatingActionButton(
              mini: true,
              tooltip: 'Move to End',
              onPressed: () {
                controller.animateTo(99999,
                    duration: Duration(milliseconds: 100),
                    curve: Curves.linear);
              },
              child: Icon(
                Icons.keyboard_arrow_down,
                // size: 50,
              ),
            )
          : null,
    );
  }
}
