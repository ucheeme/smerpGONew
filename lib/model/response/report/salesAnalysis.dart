// To parse this JSON data, do
//
//     final salesAnalysis = salesAnalysisFromJson(jsonString);

import 'dart:convert';

SalesAnalysisThisWeek salesAnalysisThisWeekFromJson(String str) => SalesAnalysisThisWeek.fromJson(json.decode(str));

String salesAnalysisThisWeekToJson(SalesAnalysisThisWeek data) => json.encode(data.toJson());

class SalesAnalysisThisWeek {

  Month lastWeek;
  Month thisWeek;
  SalesAnalysisThisWeek({
    required this.lastWeek,
    required this.thisWeek
  });

  factory SalesAnalysisThisWeek.fromJson(Map<String, dynamic> json) => SalesAnalysisThisWeek(
    lastWeek: Month.fromJson(json["lastWeek"]),
    thisWeek: Month.fromJson(json["thisWeek"]),
  );

  Map<String, dynamic> toJson() => {
    "lastWeek": lastWeek?.toJson(),
    "thisWeek": thisWeek?.toJson(),
  };
}

SalesAnalysisThisMontkh salesAnalysisThisMontkhFromJson(String str) => SalesAnalysisThisMontkh.fromJson(json.decode(str));

String salesAnalysisThisMontkhToJson(SalesAnalysisThisMontkh data) => json.encode(data.toJson());

class SalesAnalysisThisMontkh {
  Month lastMonth;
  Month thisMonth;
  SalesAnalysisThisMontkh({
    required this.lastMonth,
    required this.thisMonth,
  });

  factory SalesAnalysisThisMontkh.fromJson(Map<String, dynamic> json) => SalesAnalysisThisMontkh(
    lastMonth:Month.fromJson(json["lastMonth"]),
    thisMonth:Month.fromJson(json["thisMonth"]),
  );

  Map<String, dynamic> toJson() => {
    "lastMonth": lastMonth?.toJson(),
    "thisMonth": thisMonth?.toJson(),
  };
}

class Month {
  double sales;
  double order;
  double offline;
  double gross;

  Month({
    required this.sales,
    required this.order,
    required this.offline,
    required this.gross
  });

  factory Month.fromJson(Map<String, dynamic> json) => Month(
    sales: (json["sales"].runtimeType==int)?0.toDouble():json["sales"],
    order: (json["order"].runtimeType==int)?0.toDouble():json["order"],
    offline:(json["offline"].runtimeType==int)?0.toDouble(): json["offline"],
    gross: (json["gross"].runtimeType==int)?0.toDouble():json["gross"]
  );

  Map<String, dynamic> toJson() => {
    "sales": sales,
    "order": order,
    "offline": offline,
    "gross":gross
  };
}

SalesAnalysisM salesAnalysisMFromJson(String str) => SalesAnalysisM.fromJson(json.decode(str));

String salesAnalysisMToJson(SalesAnalysisM data) => json.encode(data.toJson());

class SalesAnalysisM {

  double sales;
  double order;
  double offline;
  double gross;
  SalesAnalysisM({
    required this.sales,
    required this.order,
    required this.offline,
    required this.gross
  });

  factory SalesAnalysisM.fromJson(Map<String, dynamic> json) => SalesAnalysisM(
    sales: (json["sales"].runtimeType==int)?0.toDouble():json["sales"],
    order: (json["order"].runtimeType==int)?0.toDouble():json["order"],
    offline:(json["offline"].runtimeType==int)?0.toDouble(): json["offline"],
    gross: (json['gross'].runtimeType==int)?0.toDouble():json["gross"]
  );

  Map<String, dynamic> toJson() => {
    "sales": sales,
    "order": order,
    "offline": offline,
    "gross":gross
  };
}



