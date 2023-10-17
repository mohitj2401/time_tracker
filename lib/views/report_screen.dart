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
  List<ChartSeries> chartSeries = [];
  Logger log = Logger();
  bool isLoading = true;
  getData() async {
    datasets = await reportScreen.getMonthlyReport();
    reportScreen.getWeeklyReport().then((value) {
      value.forEach((element) {
        chartSeries.add(
          StackedColumnSeries<DataModel, String>(
            name: element[0].z,
            // dataLabelSettings: const DataLabelSettings(
            //   isVisible: true,
            //   textStyle: TextStyle(fontSize: 14, color: Colors.black),
            // ),
            dataLabelMapper: (DataModel data, _) => 'Minutes ${data.z}'!,
            dataSource: element,
            xValueMapper: (DataModel data, _) => data.x.substring(0, 2),
            yValueMapper: (DataModel data, _) => data.y,
          ),
        );
      });

      setState(() {
        isLoading = false;
      });
    });
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
        automaticallyImplyLeading: false,
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
                      enableSideBySideSeriesPlacement: true,

                      title: ChartTitle(text: "Weekly Report"),
                      enableAxisAnimation: true,
                      trackballBehavior: TrackballBehavior(
                          enable: true,
                          activationMode: ActivationMode.singleTap),
                      // legend: Legend(isVisible: true),
                      legend:
                          Legend(isVisible: true, position: LegendPosition.top),
                      primaryXAxis: CategoryAxis(name: "min/Category"
                          // isVisible: true,
                          ),
                      series: chartSeries,
                    ))
              ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: 2,
        onTap: (int value) {
          if (value == 0) {
            Get.offNamed('/');
          }
          if (value == 1) {
            Get.offNamed('/catogories');
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
