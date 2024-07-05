//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:charts_flutter_new/flutter.dart' as charts;
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../../model/response/report/weekSaleReport.dart';
// import '../../../../utils/mockdata/mockDataGraph.dart';
//
// class ReportWeek extends StatefulWidget {
//   final List<SalesByWeekSeries> data;
//    ReportWeek({super.key, required this.data});
//
//   @override
//   State<ReportWeek> createState() => _ReportWeekState();
// }
//
// class _ReportWeekState extends State<ReportWeek> {
//   @override
//   Widget build(BuildContext context) {
//
//     List<charts.Series<SalesByWeekSeries, String>> series = [
//       charts.Series(
//           id: "developers",
//           data: widget.data,
//           // seriesColor: kBlackB600,
//           domainFn: (SalesByWeekSeries series, _) =>getDayOfWeek(series.data.day),
//           measureFn: (SalesByWeekSeries series, _) => series.data.amount,
//           colorFn: (SalesByWeekSeries series, _) => series.barColor
//       )
//     ];
//     return Container(
//       height: 500.h,
//       width: double.infinity,
//       //  padding: EdgeInsets.all(25),
//       child: Column(
//         children: <Widget>[
//           Text(
//             "",
//             style: Theme.of(context).textTheme.bodyText2,
//           ),
//           Expanded(
//             child: charts.BarChart(
//
//                 animationDuration: Duration(seconds: 1),
//                 defaultRenderer: charts.BarRendererConfig(
//                     cornerStrategy: charts.ConstCornerStrategy(30.r.toInt()),
//                 maxBarWidthPx: 40
//                 ),
//                 series,
//                 animate: true),
//           )
//         ],
//       ),
//     );
//   }
//
// }
//
//
//
//
//
//
// String getDayOfWeek(DateTime date) {
//   List<String> daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
//   return daysOfWeek[date.weekday - 1];
// }
