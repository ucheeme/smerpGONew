import 'package:flutter/material.dart';

// import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smerp_go/model/response/catalogListResponse.dart';
import 'package:smerp_go/utils/appColors.dart';
import '../../model/response/inventoryList.dart';
import '../mockdata/mockDataGraph.dart';

enum PaymentStatus{
  paid,
  unpaid,
  pending
}

enum OrderStatus{
  accepted,
  rejected,
}

String getTimeCategory() {
  final currentTime = DateTime.now().hour;

  if (currentTime >= 5 && currentTime < 12) {
    return 'Morning';
  } else if (currentTime >= 12 && currentTime < 17) {
    return 'Afternoon';
  } else if (currentTime >= 17 && currentTime < 20) {
    return 'Evening';
  } else {
    return 'Night';
  }
}


String getMonth(int value){
  switch (value){
    case 1:
      return "January";
      break;
    case 2:
      return "February";
      break;
    case 3:
      return "March";
      break;
    case 4:
      return "April";
      break ;
    case 5:
      return "May";
      break;
    case 6:
      return "June";
      break;
    case 7:
      return "July";
      break;
   case 8:
      return " August";
      break ;
    case 9:
      return "September";
      break;
    case 10:
      return "October";
      break;
    case 11:
      return "November";
      break;
    case 12:
      return "December";
      break;

    default:
      return "";
  }
}

List<String> categories =
['All', 'Fashion', 'Food', 'Sport', 'Electronics','Gadgets','Health & Beauty', 'Others'];

List<String> faqOptions =
['All', 'Account', 'Lost password', 'Sales'];

List<String> reportsTimes =
['Last week', 'Last month', 'This week', 'This month'];

// final List<DeveloperSeries> data = [
//
//   DeveloperSeries(
//     day: "Mon",
//     developers: 40000,
//     barColor: charts.ColorUtil.fromDartColor(kAppBlue),
//   ),
//   DeveloperSeries(
//    day: "Tue",
//     developers: 5000,
//     barColor:charts.ColorUtil.fromDartColor(kAppBlue),
//   ),
//   DeveloperSeries(
//     day: "Wed",
//     developers: 40000,
//     barColor:charts.ColorUtil.fromDartColor(kAppBlue),
//   ),
//   DeveloperSeries(
//     day: "Thurs",
//     developers: 35000,
//     barColor: charts.ColorUtil.fromDartColor(kAppBlue),
//   ),
//   DeveloperSeries(
//    day: "Fri",
//    developers: 45500,
//     barColor:charts.ColorUtil.fromDartColor(kAppBlue),
//   ),
//   DeveloperSeries(
//     day: "Sat",
//     developers: 4000,
//     barColor: charts.ColorUtil.fromDartColor(kAppBlue),
//   ),
//   DeveloperSeries(
//     day: "Sun",
//     developers: 6000,
//     barColor: charts.ColorUtil.fromDartColor(kAppBlue),
//   ),
// ];

enum SearchOptions{
  all,fashion,food,sport,electronics,gadgets,healthBeauty,others
}

enum SearchReports{
  lastweek,lastmonth,thisweek,thismonth
}


enum SearchFaqs{
  all,account,lostPassword,sales
}

var identitySourceByPhone = 1;
var identitySourceByMail = 2;

class CatalogFull{
  InventoryInfo catalogData;
  bool isVisible;
  CatalogFull(this.catalogData, this.isVisible);
}

RefreshController refreshController = RefreshController(initialRefresh: false);