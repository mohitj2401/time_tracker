import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_tracker/models/datamodel.dart';
import 'package:time_tracker/services/report_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  ReportService reportScreen = ReportService();
  List<DataModel> datasets = [];
  List<List<DataModel>> datas = [];
  Logger log = Logger();
  bool isLoading = true;
  getData() async {
    datasets = await reportScreen.getMonthlyReport();
    datas = await reportScreen.getWeeklyReport();
    isLoading = false;

    setState(() {});
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
      ),
      body: Container(
        width: 100.w,
        height: 100.h,
        padding: EdgeInsets.all(10),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(children: [
                SizedBox(
                  height: 30.h,
                  width: 100.w,
                  child: SfCartesianChart(
                    title: ChartTitle(text: "Today Report"),
                    primaryXAxis: CategoryAxis(
                      isVisible: true,
                      name: 'Minutes',
                    ),
                    series: <ChartSeries>[
                      // Renders line chart
                      LineSeries<DataModel, String>(
                        isVisibleInLegend: true,
                        yAxisName: 'Minutes',
                        xAxisName: 'Category',
                        dataSource: datasets,
                        xValueMapper: (DataModel sales, _) => sales.x,
                        yValueMapper: (DataModel sales, _) => sales.y,
                      )
                    ],
                  ),
                ),
                SizedBox(
                    height: 40.h,
                    width: 100.w,
                    child: SfCartesianChart(
                      tooltipBehavior: TooltipBehavior(
                          activationMode: ActivationMode.singleTap),
                      primaryXAxis: CategoryAxis(
                        isVisible: true,
                      ),
                      series: <ChartSeries>[
                        StackedColumnSeries<DataModel, String>(
                          enableTooltip: true,
                          isTrackVisible: true,
                          groupName: 'Group A',
                          dataSource: datas[0],
                          xValueMapper: (DataModel data, _) =>
                              data.x.substring(0, 2),
                          yValueMapper: (DataModel data, _) => data.y,
                        ),
                        StackedColumnSeries<DataModel, String>(
                          groupName: 'Group B',
                          dataSource: datas[1],
                          enableTooltip: true,
                          isTrackVisible: true,
                          xValueMapper: (DataModel data, _) =>
                              data.x.substring(0, 2),
                          yValueMapper: (DataModel data, _) => data.y,
                        ),
                        StackedColumnSeries<DataModel, String>(
                          enableTooltip: true,
                          isTrackVisible: true,
                          groupName: 'Group C',
                          dataSource: datas[2],
                          xValueMapper: (DataModel data, _) =>
                              data.x.substring(0, 2),
                          yValueMapper: (DataModel data, _) => data.y,
                        ),
                        StackedColumnSeries<DataModel, String>(
                          enableTooltip: true,
                          isTrackVisible: true,
                          groupName: 'Group D',
                          dataSource: datas[3],
                          xValueMapper: (DataModel data, _) =>
                              data.x.substring(0, 2),
                          yValueMapper: (DataModel data, _) => data.y,
                        ),
                        StackedColumnSeries<DataModel, String>(
                          enableTooltip: true,
                          isTrackVisible: true,
                          groupName: 'Group E',
                          dataSource: datas[4],
                          xValueMapper: (DataModel data, _) =>
                              data.x.substring(0, 2),
                          yValueMapper: (DataModel data, _) => data.y,
                        ),
                        StackedColumnSeries<DataModel, String>(
                          enableTooltip: true,
                          isTrackVisible: true,
                          groupName: 'Group F',
                          dataSource: datas[5],
                          xValueMapper: (DataModel data, _) =>
                              data.x.substring(0, 2),
                          yValueMapper: (DataModel data, _) => data.y,
                        ),
                        StackedColumnSeries<DataModel, String>(
                          enableTooltip: true,
                          isTrackVisible: true,
                          groupName: 'Group G',
                          dataSource: datas[6],
                          xValueMapper: (DataModel data, _) =>
                              data.x.substring(0, 2),
                          yValueMapper: (DataModel data, _) => data.y,
                        ),
                      ],
                    ))
              ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (int value) {
          if (value == 0) {
            Get.toNamed('/');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Category'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Report'),
        ],
      ),
    );
  }
}
