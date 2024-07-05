import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:smerp_go/cubit/bankDetail/bank_details_cubit.dart';

import '../model/response/order/orderDetails.dart';
import '../model/response/sales/saleListInfo.dart';
import 'AppUtils.dart';
import 'appColors.dart';
import 'appDesignUtil.dart';

List<SalesItemInfo> splitSaleListData(List<SalesItemInfo> data, int parts,int position){
  List<int> count = [1,2,3,4,5,6,7,8,9];
  print("this is sublist: ${count.sublist(0,4)} and ${count.sublist(4,count.length)}");
  if(data.length>4){
    position = 3;
    if(parts==1) {

      return data.sublist(0, 4);
    }else {
      return data.sublist(4,data.length);
    }
  }else{
    return data;
  }

}
List<OrderItems> splitOrderListData(List<OrderItems> data, int parts,int position){
  List<int> count = [1,2,3,4,5,6,7,8,9];
  print("this is sublist: ${count.sublist(0,3)} and ${count.sublist(4,count.length)}");
  if(data.length>4){
    position = 3;
    if(parts==1) {
      return data.sublist(0, 4);
    }else {
      return data.sublist(4,data.length);
    }
  }else{
    return data;
  }
}
int positionSet (List<SalesItemInfo> data,) {
  if (data.length.isLowerThan(4)) {

    print("${data.length} list is lower than 4");
    return 0;
  } else {
    print("list is more than 4");
    return 3;
  }
}
int positionSetOrder (List<OrderItems> data,){
  if(data.length.isLowerThan(4)){
    print("Order list is lower than 4");
    return 0;
  }else{
    print("Order list is more than 4");
    return 3;
  }
}
Future<Uint8List> generate2Pdf(PdfPageFormat format,{int? paymentStatus,
  DateTime? orderPlacedAt, DateTime? orderCompletedAt, String? deliveryAddress,
  bool isOrder=false,
  required List<SaleListDataInfo> data,
  List<OrderItems>? orderData,
  customerName ="",})async{
  List<OrderItems>? newValueOrders;
  List<SalesItemInfo>? newValueSales;
  int position;
  int lentth;
  if(isOrder){
    position=positionSetOrder(orderData!);
    if(position==0){
      lentth = orderData!.length;
    }else{
      newValueOrders=splitOrderListData(orderData!, 1,position);
      lentth=6;
    }
  }else{
    print(data[0].saleProducts.length);
    position = positionSet(data[0].saleProducts);
    if(position==0){
      lentth = data[0].saleProducts.length;
    }else{
      newValueSales=splitSaleListData(data[0].saleProducts,1,position);
      lentth=6;
    }
  }
  var datePlaced="";
  var dateCompleted="";
  final pdf = pw.Document( compress: false,
    pageMode: PdfPageMode.fullscreen,);
  final font = await PdfGoogleFonts.nunitoExtraLight();
  final ByteData image = await rootBundle.load((paymentStatus==1)?
  "assets/receiptPaid.png":"assets/receiptUnpaid.png");
  Uint8List imageData = (image).buffer.asUint8List();
  final ByteData img= await rootBundle.load("assets/smerp_heading.png");
  Uint8List imaging =(img).buffer.asUint8List();
  final ByteData smerpBottom= await rootBundle.load("assets/smerp_logo.png");
  var dataFont = await rootBundle.load("font/graphik_regular.ttf");
  Uint8List _smerpBottom =(smerpBottom).buffer.asUint8List();
  (lentth.isGreaterThan(5)) ?
  pdf.addPage(

    pw.MultiPage(
      maxPages: 10,
      theme: pw.ThemeData.withFont(
          icons: pw.Font.ttf(await rootBundle.load("font/graphik_regular.ttf"))
      ),
      build: (pw.Context context) {

        datePlaced = formatDate(
          (orderPlacedAt??DateTime.now()).toLocal(),
          [dd, '/',mm, '/', yyyy, hh,":",mm," ", am],
        );
        dateCompleted= formatDate(
          (orderCompletedAt??DateTime.now()).toLocal(),
          [dd, '/',mm, '/', yyyy," ", hh,":",mm," ", am],
        );
        return [
          pw.Stack(
              alignment: pw.Alignment.center,
              fit:pw.StackFit.passthrough,
              children:[
                pw.Column(
                    children: [
                      pw.Container(
                          height: 100.w,
                          width: double.infinity,
                          child: pw.Image(pw.MemoryImage(imaging))
                      ),
                      // pw.Expanded(
                      //   child:
                      pw.Column(
                          children: [
                            pw.Column(children: [
                              txt(text: "${customerName}!"
                                  " Here are your order details", size: 12.sp,
                                maxLine: 3,
                                color: PdfColor.fromHex("111827"),
                                weight: pw.FontWeight.bold, ),
                              gap(null),
                              txt(text: "RECEIPT", size: 14,
                                  color: PdfColor.fromHex("7C5CFC"),weight: pw.FontWeight.bold),
                            ],),
                            gap(null),
                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Expanded(
                                  flex: 1,
                                  child: pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    children: [
                                      txt(text: 'Order placed at:', size: 12),
                                      txt(text: dateCompleted, size: 10,
                                          weight: pw.FontWeight.bold),
                                      gap(45),
                                      txt(text: 'Ordered from:', size: 12,),
                                      txt(text: "${loginData!.storeName}", size: 12,
                                          weight: pw.FontWeight.bold),
                                      gap2(null),
                                      txt(text: "${loginData!.storeEmail}",
                                        size: 12,color:PdfColor.fromHex("888888"),),
                                      gap2(null),
                                      txt(text: "${loginData!.storePhoneNumber}",
                                        size: 12,color: PdfColor.fromHex("888888"),)
                                    ],
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 1,
                                  child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end,
                                    children: [
                                      txt(text: 'Order completed at:',
                                          size: 12,align: pw.TextAlign.end),
                                      txt(text: dateCompleted,
                                          size: 10,weight: pw.FontWeight.bold,
                                          align: pw.TextAlign.end),
                                      gap(45),
                                      txt(text: 'Delivered to:', size: 12,
                                          align: pw.TextAlign.end),
                                      // gap2(),
                                      txt(text: "${customerName}",
                                          size: 12,weight: pw.FontWeight.bold,
                                          align: pw.TextAlign.end),
                                      gap2(null),
                                      txt(text: deliveryAddress??"none", size: 10,
                                          color: PdfColor.fromHex("888888"),
                                          maxLine: 2,align: pw.TextAlign.end),
                                    ],
                                  ),
                                ),
                              ],),
                            gap(50),
                            pw.Table(
                              border: pw.TableBorder.symmetric(
                                outside: pw.BorderSide.none,
                                inside: pw.BorderSide.none,
                              ),
                              children: [
                                pw.TableRow(
                                  children: [
                                    txt(text: "Item Name", size: 14,weight: pw.FontWeight.bold,maxLine: 1,align: pw.TextAlign.start),
                                    pw.Center(child: txt(text: "Quantity/Price", size: 14,weight: pw.FontWeight.bold,maxLine: 1)),
                                    txt(text: "Value", size: 14,weight: pw.FontWeight.bold,maxLine: 1,align: pw.TextAlign.end),
                                  ],
                                ),
                              ],
                            ),

                            pw.Container(
                              height: 240.h,
                              color: PdfColor.fromHex("FFFFFF"),
                              padding: pw.EdgeInsets.zero,
                              child: pw.ListView.builder(

                                  padding: pw.EdgeInsets.zero,
                                  // itemCount: (isOrder)?orderData!.length:
                                  // data[0].saleProducts.length,
                                  itemCount:  (isOrder)?(newValueOrders!.length):
                                  (newValueSales!.length),
                                  itemBuilder: (context, index){
                                    var items =(isOrder)? newValueOrders![index]:null;
                                    var currentData=(isOrder)?null: newValueSales![index];
                                    (isOrder)?print("This is the order value for index:$index => ${ newValueOrders![index].name}"):
                                    print("This is the sales value for index:$index => ${newValueSales![index].productName}");
                                    return (isOrder)?
                                    pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Container(
                                          width: 120.w,
                                          height: 50.h,
                                          child:pw.Align(
                                            alignment: pw.Alignment.centerLeft,
                                            child: pw.Padding(
                                              padding:  pw.EdgeInsets.zero,
                                              child: pw.SizedBox(
                                                width: 300.w,
                                                child: txt(
                                                    text:items!.productName,size: 14.sp,
                                                    color:  PdfColors.black, weight: pw.FontWeight.normal),
                                              ),
                                            ),
                                          ) ,
                                        ),
                                        gapW(40),
                                        pw.Container(
                                          width: 120.w,
                                          height: 50.h,
                                          child:pw.Align(
                                            alignment: pw.Alignment.center,
                                            child: pw.Padding(
                                              padding:  pw.EdgeInsets.only(left: 15.w),
                                              child: customTextnaira1("${items.quantity.toString()} x NGN ${
                                                  double.parse(
                                                      items.sellingPrice.toString()
                                                  ).toString().split(".")[0]}",
                                                  PdfColors.black,
                                                  14.sp,dataFont, fontWeight: pw.FontWeight.normal),
                                            ),
                                          ) ,
                                        ),

                                        pw.Container(
                                          width: 120.w,
                                          height: 50.h,
                                          child:pw.Align(
                                            alignment: pw.Alignment.centerRight,
                                            child: pw.Padding(
                                                padding:  pw.EdgeInsets.only(right: 5.w),
                                                child:  customTextnaira1(
                                                    "NGN ${double.parse(
                                                        (items.quantity*items.sellingPrice).toString()
                                                    ).toString().split(".")[0]}", kBlack,
                                                    14.sp,dataFont,
                                                    fontWeight: pw.FontWeight.normal)
                                            ),
                                          ) ,
                                        ),
                                      ],
                                    ):
                                    pw.Row(
                                      mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Container(
                                          width: 200.w,
                                          height: 50.h,
                                          child:pw.Align(
                                            alignment: pw.Alignment.centerLeft,
                                            child: pw.Padding(
                                              padding:  pw.EdgeInsets.zero,
                                              child: txt(
                                                  text: (currentData!.productName.length>=8)?
                                                  currentData.productName.replaceRange(8,
                                                      currentData.productName.length, '...'):
                                                  currentData.productName,color:PdfColors.black,
                                                  size:14.sp, weight: pw.FontWeight.normal),
                                            ),
                                          ) ,
                                        ),
                                        pw.Container(
                                          width: 120.w,
                                          height: 50.h,
                                          child: pw.Align(
                                            alignment:  pw.Alignment.centerLeft,
                                            child:  pw.Padding(
                                              padding:   pw.EdgeInsets.only(left: 10.w),
                                              child: customTextnaira1("${currentData.quantity.toString()} x NGN ${
                                                  double.parse(
                                                      currentData.sellingPrice.toString()
                                                  ).toString().split(".")[0]}",
                                                  PdfColors.black,
                                                  14.sp,dataFont, fontWeight: pw.FontWeight.normal),
                                            ),
                                          ) ,
                                        ),
                                        pw.Container(
                                          width: 120.w,
                                          height: 50.h,
                                          // color:kAppBlue,
                                          child: pw.Center(child:
                                          pw.Align(
                                            alignment:  pw.Alignment.centerRight,
                                            child: customTextnaira1(
                                                " NGN ${double.parse(
                                                    (currentData.quantity*currentData.sellingPrice).toString()
                                                ).toString().split(".")[0]}",PdfColors.black,
                                                14.sp,dataFont, fontWeight: pw.FontWeight.normal),
                                          ) ,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                            pw.Row(
                              children: [
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end,
                                        children: [
                                          pw.Column(
                                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                                            children: [
                                              txt(text: "${storeBankDetail?.bankName??""}", size: 13,maxLine: 1,
                                                  weight: pw.FontWeight.bold,
                                                  color:  PdfColor.fromHex("7C5CFC"),align: pw.TextAlign.start),

                                              txt(text: "${storeBankDetail?.accountNumber??""}", size: 12,
                                                  color: PdfColor.fromHex("7C5CFC"),weight: pw.FontWeight.bold,align: pw.TextAlign.start),

                                              txt(text: "${storeBankDetail?.accountName??""}", size: 12,
                                                  color: PdfColor.fromHex("7C5CFC"),weight: pw.FontWeight.bold,align: pw.TextAlign.start),
                                            ],),
                                        ],),
                                    ]
                                ),
                                pw.Spacer(),                                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end,
                                  children: [
                                    pw.Column(
                                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                                      children: [
                                        txt(text: "Subtotal:", size: 12,maxLine: 1,color:  PdfColor.fromHex("888888"),align: pw.TextAlign.end),
                                        gap2(null),
                                        txt(text: "Grand Total:", size: 16,
                                            color: PdfColor.fromHex("7C5CFC"),weight: pw.FontWeight.bold,align: pw.TextAlign.end),
                                      ],),
                                    pw.SizedBox(width: 40,),
                                    pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end,
                                      children: [
                                        customTextnaira1(
                                            "NGN ${double.parse(
                                                getTotalAmount(isOrder,orderData,data)
                                            ).toString().split(".")[0]}", PdfColor.fromHex("888888"),
                                            14.sp,dataFont,
                                            fontWeight: pw.FontWeight.bold),
                                        gap2(null),
                                        customTextnaira1(
                                            "NGN ${double.parse(
                                                getTotalAmount(isOrder,orderData,data)
                                            ).toString().split(".")[0]}", PdfColor.fromHex("695ACD"),
                                            18.sp,dataFont,
                                            maxLines: 3,
                                            fontWeight: pw.FontWeight.bold)
                                      ],),

                                  ],),
                              ]
                            ),

                            gap(null),
                          ]
                      ),
                      // ),
                      pw.SizedBox(height: 10),
                      pw.Container(
                        padding: pw.EdgeInsets.symmetric(vertical: 8.h,horizontal: 10.w),
                        decoration:pw.BoxDecoration(
                            color: PdfColor.fromHex("F8F7FF"),
                            border: pw.Border(
                                top: pw.BorderSide(width: 2, color: PdfColor.fromHex("7C5CFC"),),
                                bottom: pw.BorderSide(width: 7, color: PdfColor.fromHex("7C5CFC"),)
                            )
                        ),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.SizedBox(
                                width: 150.w,
                                child:pw.Image(pw.MemoryImage(_smerpBottom))),
                            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                txt(text: "Powered By Fifthlab", size: 13,maxLine: 1,
                                    align: pw.TextAlign.end,weight: pw.FontWeight.bold),
                                pw.SizedBox(width: 250.w,
                                  child: pw.Align(
                                    alignment: pw.Alignment.centerRight,

                                    child: pw.RichText(
                                        textAlign: pw.TextAlign.end,
                                        text:
                                        pw.TextSpan(
                                            text: "You are receiving this because \n ${loginData!.storeName} is a user  of",
                                            style:pw.TextStyle(
                                              fontSize: 10,
                                              color: PdfColor.fromHex("888888"),
                                            ),
                                            children: [
                                              pw.TextSpan(
                                                  text: " SmerpGo",
                                                  style: pw.TextStyle(
                                                    color: PdfColor.fromHex("695ACD"),
                                                    // fontWeight: pw.FontWeight.w600,
                                                  )
                                              )
                                            ]
                                        )),
                                  ),
                                )
                              ],)
                          ],
                        ),
                      ),
                    ]
                ),
                pw.Image( pw.MemoryImage(imageData),)
              ]
          ),
          pw.Column(
              children: [
                pw.Column(
                    children: [
                      pw.Table(
                        border: pw.TableBorder.symmetric(
                          outside: pw.BorderSide.none,
                          inside: pw.BorderSide.none,
                        ),
                        children: [
                          pw.TableRow(
                            children: [
                              txt(text: "Item Name", size: 14,weight: pw.FontWeight.bold,maxLine: 1,align: pw.TextAlign.start),
                              pw.Center(child: txt(text: "Quantity/Price", size: 14,weight: pw.FontWeight.bold,maxLine: 1)),
                              txt(text: "Value", size: 14,weight: pw.FontWeight.bold,maxLine: 1,align: pw.TextAlign.end),
                            ],
                          ),
                        ],
                      ),

                      pw.Container(
                        height: 640.h,
                        color: PdfColor.fromHex("FFFFFF"),
                        padding: pw.EdgeInsets.zero,
                        child: pw.ListView.builder(

                            padding: pw.EdgeInsets.zero,
                            itemCount: (isOrder)?(
                                splitOrderListData(orderData!, 2,position).length):
                            (splitSaleListData(data[0].saleProducts,2,position).length),
                            itemBuilder: (context, index){

                              var items =(isOrder)?
                              splitOrderListData(orderData!, 2,position)![index]:null;
                              var currentData=(isOrder)?null:
                              splitSaleListData(data[0].saleProducts,2,position)[index];
                              return (isOrder)?
                              pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Container(
                                    width: 120.w,
                                    height: 50.h,
                                    child:pw.Align(
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Padding(
                                        padding:  pw.EdgeInsets.zero,
                                        child: pw.SizedBox(
                                          width: 300.w,
                                          child: txt(
                                              text:items!.productName,size: 14.sp,
                                              color:  PdfColors.black, weight: pw.FontWeight.normal),
                                        ),
                                      ),
                                    ) ,
                                  ),
                                  gapW(40),
                                  pw.Container(
                                    width: 120.w,
                                    height: 50.h,
                                    child:pw.Align(
                                      alignment: pw.Alignment.center,
                                      child: pw.Padding(
                                        padding:  pw.EdgeInsets.only(left: 10.w),
                                        child: customTextnaira1("${items.quantity.toString()} x NGN ${
                                            double.parse(
                                                items.sellingPrice.toString()
                                            ).toString().split(".")[0]}",
                                            PdfColors.black,
                                            14.sp,dataFont, fontWeight: pw.FontWeight.normal),
                                      ),
                                    ) ,
                                  ),

                                  pw.Container(
                                    width: 120.w,
                                    height: 50.h,
                                    child:pw.Align(
                                      alignment: pw.Alignment.centerRight,
                                      child: pw.Padding(
                                          padding:  pw.EdgeInsets.only(right: 5.w),
                                          child:  customTextnaira1(
                                              "NGN ${double.parse(
                                                  (items.quantity*items.sellingPrice).toString()
                                              ).toString().split(".")[0]}", kBlack,
                                              14.sp,dataFont,
                                              fontWeight: pw.FontWeight.normal)
                                      ),
                                    ) ,
                                  ),
                                ],
                              ):
                              pw.Row(
                                mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Container(
                                    width: 120.w,
                                    height: 50.h,
                                    child:pw.Align(
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Padding(
                                        padding:  pw.EdgeInsets.zero,
                                        child: txt(
                                            text: (currentData!.productName.length>=8)?
                                            currentData.productName.replaceRange(8,
                                                currentData.productName.length, '...'):
                                            currentData.productName,color:PdfColors.black,
                                            size:14.sp, weight: pw.FontWeight.normal),
                                      ),
                                    ) ,
                                  ),
                                  pw.Container(
                                    width: 120.w,
                                    height: 50.h,
                                    child: pw.Align(
                                      alignment:  pw.Alignment.centerLeft,
                                      child:  pw.Padding(
                                        padding:   pw.EdgeInsets.only(left: 10.w),
                                        child: customTextnaira1("${currentData.quantity.toString()} x NGN ${
                                            double.parse(
                                                currentData.sellingPrice.toString()
                                            ).toString().split(".")[0]}",
                                            PdfColors.black,
                                            14.sp,dataFont, fontWeight: pw.FontWeight.normal),
                                      ),
                                    ) ,
                                  ),
                                  pw.Container(
                                    width: 120.w,
                                    height: 50.h,
                                    // color:kAppBlue,
                                    child: pw.Center(child:
                                    pw.Align(
                                      alignment:  pw.Alignment.centerRight,
                                      child: customTextnaira1(
                                          " NGN ${double.parse(
                                              (currentData.quantity*currentData.sellingPrice).toString()
                                          ).toString().split(".")[0]}",PdfColors.black,
                                          14.sp,dataFont, fontWeight: pw.FontWeight.normal),
                                    ) ,
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                      pw.Row(
                          children: [
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end,
                                    children: [
                                      pw.Column(
                                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                                        children: [
                                          txt(text: " ${storeBankDetail?.bankName??""}", size: 13,maxLine: 1,
                                              weight: pw.FontWeight.bold,
                                              color:  PdfColor.fromHex("7C5CFC"),align: pw.TextAlign.start),

                                          txt(text: "${storeBankDetail?.accountNumber??""}", size: 12,
                                              color: PdfColor.fromHex("7C5CFC"),weight: pw.FontWeight.bold,align: pw.TextAlign.start),

                                          txt(text: "${storeBankDetail?.accountName??""}", size: 12,
                                              color: PdfColor.fromHex("7C5CFC"),weight: pw.FontWeight.bold,align: pw.TextAlign.start),
                                        ],),
                                    ],),
                                ]
                            ),
                            pw.Spacer(),
                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end,
                                  children: [
                                    txt(text: "Subtotal:", size: 12,maxLine: 1,color:  PdfColor.fromHex("888888"),align: pw.TextAlign.end),
                                    gap2(null),
                                    txt(text: "Grand Total:", size: 16,
                                        color: PdfColor.fromHex("7C5CFC"),weight: pw.FontWeight.bold,align: pw.TextAlign.end),
                                  ],),
                                pw.SizedBox(width: 40,),
                                pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end,
                                  children: [
                                    customTextnaira1(
                                        "NGN${double.parse(
                                            getTotalAmount(isOrder,orderData,data)
                                        ).toString().split(".")[0]}", PdfColor.fromHex("888888"),
                                        14.sp,dataFont,
                                        fontWeight: pw.FontWeight.bold),
                                    gap2(null),
                                    customTextnaira1(
                                        "NGN${double.parse(
                                            getTotalAmount(isOrder,orderData,data)
                                        ).toString().split(".")[0]}", PdfColor.fromHex("695ACD"),
                                        18.sp,dataFont,
                                        maxLines: 3,
                                        fontWeight: pw.FontWeight.bold)
                                  ],),

                              ],),
                          ]
                      ),

                      gap(null),
                    ]
                ),
                // ),
                pw.Container(
                  padding: pw.EdgeInsets.symmetric(vertical: 20.h,horizontal: 10.w),
                  decoration:pw.BoxDecoration(
                      color: PdfColor.fromHex("F8F7FF"),
                      border: pw.Border(
                          top: pw.BorderSide(width: 2, color: PdfColor.fromHex("7C5CFC"),),
                          bottom: pw.BorderSide(width: 7, color: PdfColor.fromHex("7C5CFC"),)
                      )
                  ),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.SizedBox(
                          width: 150.w,
                          child:pw.Image(pw.MemoryImage(_smerpBottom))),
                      pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          txt(text: "Powered By Fifthlab", size: 13,maxLine: 1,
                              align: pw.TextAlign.end,weight: pw.FontWeight.bold),
                          pw.SizedBox(width: 250.w,
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,

                              child: pw.RichText(
                                  textAlign: pw.TextAlign.end,
                                  text:
                                  pw.TextSpan(
                                      text: "You’re receiving this because \n ${loginData!.storeName} is a user  of",
                                      style:pw.TextStyle(
                                        fontSize: 10,
                                        color: PdfColor.fromHex("888888"),
                                      ),
                                      children: [
                                        pw.TextSpan(
                                            text: " SmerpGo",
                                            style: pw.TextStyle(
                                              color: PdfColor.fromHex("695ACD"),
                                              // fontWeight: pw.FontWeight.w600,
                                            )
                                        )
                                      ]
                                  )),
                            ),
                          )
                        ],)
                    ],
                  ),
                ),
              ]
          ),
          pw.Image( pw.MemoryImage(imageData),),
        ];
      },
    ),
  ):
  pdf.addPage(

    pw.Page(
      theme: pw.ThemeData.withFont(
          icons: pw.Font.ttf(await rootBundle.load("font/graphik_regular.ttf"))
      ),
      build: (pw.Context context) {

        datePlaced = formatDate(
          (orderPlacedAt??DateTime.now()).toLocal(),
          [dd, '/',mm, '/', yyyy, hh,":",mm," ", am],
        );
        dateCompleted= formatDate(
          (orderCompletedAt??DateTime.now()).toLocal(),
          [dd, '/',mm, '/', yyyy," ", hh,":",mm," ", am],
        );
        return
          pw.Stack(
              alignment: pw.Alignment.center,
              fit:pw.StackFit.passthrough,
              children:[
                pw.Column(
                    children: [
                      pw.Container(
                          height: 100.w,
                          width: double.infinity,
                          child: pw.Image(pw.MemoryImage(imaging))
                      ),
                      // pw.Expanded(
                      //   child:
                      pw.Column(
                          children: [
                            pw.Column(children: [
                              txt(text: "${customerName}!"
                                  " Here are your order details", size: 12.sp,
                                maxLine: 3,
                                color: PdfColor.fromHex("111827"),
                                weight: pw.FontWeight.bold, ),
                              gap(null),
                              txt(text: "RECEIPT", size: 14,
                                  color: PdfColor.fromHex("7C5CFC"),weight: pw.FontWeight.bold),
                            ],),
                            gap(null),
                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Expanded(
                                  flex: 1,
                                  child: pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    children: [
                                      txt(text: 'Order placed at:', size: 12),
                                      txt(text: dateCompleted, size: 10,
                                          weight: pw.FontWeight.bold),
                                      gap(45),
                                      txt(text: 'Ordered from:', size: 12,),
                                      txt(text: "${loginData!.storeName}", size: 12,
                                          weight: pw.FontWeight.bold),
                                      gap2(null),
                                      txt(text: "${loginData!.storeEmail}",
                                        size: 12,color:PdfColor.fromHex("888888"),),
                                      gap2(null),
                                      txt(text: "${loginData!.storePhoneNumber}",
                                        size: 12,color: PdfColor.fromHex("888888"),)
                                    ],
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 1,
                                  child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end,
                                    children: [
                                      txt(text: 'Order completed at:',
                                          size: 12,align: pw.TextAlign.end),
                                      txt(text: dateCompleted,
                                          size: 10,weight: pw.FontWeight.bold,
                                          align: pw.TextAlign.end),
                                      gap(45),
                                      txt(text: 'Delivered to:', size: 12,
                                          align: pw.TextAlign.end),
                                      // gap2(),
                                      txt(text: "${customerName}",
                                          size: 12,weight: pw.FontWeight.bold,
                                          align: pw.TextAlign.end),
                                      gap2(null),
                                      txt(text: deliveryAddress??"none", size: 10,
                                          color: PdfColor.fromHex("888888"),
                                          maxLine: 2,align: pw.TextAlign.end),
                                    ],
                                  ),
                                ),
                              ],),
                            gap(50),
                            pw.Table(
                              border: pw.TableBorder.symmetric(
                                outside: pw.BorderSide.none,
                                inside: pw.BorderSide.none,
                              ),
                              children: [
                                pw.TableRow(
                                  children: [
                                    txt(text: "Item Name", size: 14,weight: pw.FontWeight.bold,maxLine: 1,align: pw.TextAlign.start),
                                    pw.Center(child: txt(text: "Quantity/Price", size: 14,weight: pw.FontWeight.bold,maxLine: 1)),
                                    txt(text: "Value", size: 14,weight: pw.FontWeight.bold,maxLine: 1,align: pw.TextAlign.end),
                                  ],
                                ),
                              ],
                            ),

                            pw.Container(
                              height: 240.h,
                              color: PdfColor.fromHex("FFFFFF"),
                              padding: pw.EdgeInsets.zero,
                              child: pw.ListView.builder(

                                  padding: pw.EdgeInsets.zero,
                                  // itemCount: (isOrder)?orderData!.length:
                                  // data[0].saleProducts.length,
                                  itemCount:  (isOrder)?(splitOrderListData(orderData!, 1,position).length):
                                  (splitSaleListData(data[0].saleProducts,1,position).length),
                                  itemBuilder: (context, index){
                                    var items =(isOrder)?
                                    orderData![index]:null;
                                    var currentData=(isOrder)?null:
                                    data[0].saleProducts[index];
                                    return (isOrder)?
                                    pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Container(
                                          width: 120.w,
                                          height: 50.h,
                                          child:pw.Align(
                                            alignment: pw.Alignment.centerLeft,
                                            child: pw.Padding(
                                              padding:  pw.EdgeInsets.zero,
                                              child: pw.SizedBox(
                                                width: 300.w,
                                                child: txt(
                                                    text:items!.productName,size: 14.sp,
                                                    color:  PdfColors.black, weight: pw.FontWeight.normal),
                                              ),
                                            ),
                                          ) ,
                                        ),
                                        gapW(40),
                                        pw.Container(
                                          width: 120.w,
                                          height: 50.h,
                                          child:pw.Align(
                                            alignment: pw.Alignment.center,
                                            child: pw.Padding(
                                              padding:  pw.EdgeInsets.only(left: 15.w),
                                              child: customTextnaira1("${items.quantity.toString()} x NGN ${
                                                  double.parse(
                                                      items.sellingPrice.toString()
                                                  ).toString().split(".")[0]}",
                                                  PdfColors.black,
                                                  14.sp,dataFont, fontWeight: pw.FontWeight.normal),
                                            ),
                                          ) ,
                                        ),

                                        pw.Container(
                                          width: 120.w,
                                          height: 50.h,
                                          child:pw.Align(
                                            alignment: pw.Alignment.centerRight,
                                            child: pw.Padding(
                                                padding:  pw.EdgeInsets.only(right: 5.w),
                                                child:  customTextnaira1(
                                                    "NGN ${double.parse(
                                                        (items.quantity*items.sellingPrice).toString()
                                                    ).toString().split(".")[0]}", kBlack,
                                                    14.sp,dataFont,
                                                    fontWeight: pw.FontWeight.normal)
                                            ),
                                          ) ,
                                        ),
                                      ],
                                    ):
                                    pw.Row(
                                      mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Container(
                                          width: 200.w,
                                          height: 50.h,
                                          child:pw.Align(
                                            alignment: pw.Alignment.centerLeft,
                                            child: pw.Padding(
                                              padding:  pw.EdgeInsets.zero,
                                              child: txt(
                                                  text: (currentData!.productName.length>=8)?
                                                  currentData.productName.replaceRange(8,
                                                      currentData.productName.length, '...'):
                                                  currentData.productName,color:PdfColors.black,
                                                  size:14.sp, weight: pw.FontWeight.normal),
                                            ),
                                          ) ,
                                        ),
                                        pw.Container(
                                          width: 120.w,
                                          height: 50.h,
                                          child: pw.Align(
                                            alignment:  pw.Alignment.centerLeft,
                                            child:  pw.Padding(
                                              padding:   pw.EdgeInsets.only(left: 10.w),
                                              child: customTextnaira1("${currentData.quantity.toString()} x NGN ${
                                                  double.parse(
                                                      currentData.sellingPrice.toString()
                                                  ).toString().split(".")[0]}",
                                                  PdfColors.black,
                                                  14.sp,dataFont, fontWeight: pw.FontWeight.normal),
                                            ),
                                          ) ,
                                        ),
                                        pw.Container(
                                          width: 120.w,
                                          height: 50.h,
                                          // color:kAppBlue,
                                          child: pw.Center(child:
                                          pw.Align(
                                            alignment:  pw.Alignment.centerRight,
                                            child: customTextnaira1(
                                                " NGN ${double.parse(
                                                    (currentData.quantity*currentData.sellingPrice).toString()
                                                ).toString().split(".")[0]}",PdfColors.black,
                                                14.sp,dataFont, fontWeight: pw.FontWeight.normal),
                                          ) ,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                            pw.Row(
                                children: [
                                  pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end,
                                          children: [
                                            pw.Column(
                                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                                              children: [
                                                txt(text: "${storeBankDetail?.bankName??""}", size: 13,maxLine: 1,
                                                    weight: pw.FontWeight.bold,
                                                    color:  PdfColor.fromHex("7C5CFC"),align: pw.TextAlign.start),

                                                txt(text: "${storeBankDetail?.accountNumber??""}", size: 12,
                                                    color: PdfColor.fromHex("7C5CFC"),weight: pw.FontWeight.bold,align: pw.TextAlign.start),

                                                txt(text: "${storeBankDetail?.accountName??""}", size: 12,
                                                    color: PdfColor.fromHex("7C5CFC"),weight: pw.FontWeight.bold,align: pw.TextAlign.start),
                                              ],),
                                          ],),
                                      ]
                                  ),
                                  pw.Spacer(),
                                  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end,
                                    children: [
                                      pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end,
                                        children: [
                                          txt(text: "Subtotal:", size: 12,maxLine: 1,color:  PdfColor.fromHex("888888"),align: pw.TextAlign.end),
                                          gap2(null),
                                          txt(text: "Grand Total:", size: 16,
                                              color: PdfColor.fromHex("7C5CFC"),weight: pw.FontWeight.bold,align: pw.TextAlign.end),
                                        ],),
                                      pw.SizedBox(width: 40,),
                                      pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end,
                                        children: [
                                          customTextnaira1(
                                              "NGN ${double.parse(
                                                  getTotalAmount(isOrder,orderData,data)
                                              ).toString().split(".")[0]}", PdfColor.fromHex("888888"),
                                              14.sp,dataFont,
                                              fontWeight: pw.FontWeight.bold),
                                          gap2(null),
                                          customTextnaira1(
                                              "NGN ${double.parse(
                                                  getTotalAmount(isOrder,orderData,data)
                                              ).toString().split(".")[0]}", PdfColor.fromHex("695ACD"),
                                              18.sp,dataFont,
                                              maxLines: 3,
                                              fontWeight: pw.FontWeight.bold)
                                        ],),

                                    ],),
                                ]
                            ),
                            gap(null),
                          ]
                      ),
                      // ),
                      pw.SizedBox(height: 10),
                      pw.Container(
                        padding: pw.EdgeInsets.symmetric(vertical: 8.h,horizontal: 10.w),
                        decoration:pw.BoxDecoration(
                            color: PdfColor.fromHex("F8F7FF"),
                            border: pw.Border(
                                top: pw.BorderSide(width: 2, color: PdfColor.fromHex("7C5CFC"),),
                                bottom: pw.BorderSide(width: 7, color: PdfColor.fromHex("7C5CFC"),)
                            )
                        ),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.SizedBox(
                                width: 150.w,
                                child:pw.Image(pw.MemoryImage(_smerpBottom))),
                            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                txt(text: "Powered By Fifthlab", size: 13,maxLine: 1,
                                    align: pw.TextAlign.end,weight: pw.FontWeight.bold),
                                pw.SizedBox(width: 250.w,
                                  child: pw.Align(
                                    alignment: pw.Alignment.centerRight,

                                    child: pw.RichText(
                                        textAlign: pw.TextAlign.end,
                                        text:
                                        pw.TextSpan(
                                            text: "You are receiving this because \n ${loginData!.storeName} is a user  of",
                                            style:pw.TextStyle(
                                              fontSize: 10,
                                              color: PdfColor.fromHex("888888"),
                                            ),
                                            children: [
                                              pw.TextSpan(
                                                  text: " SmerpGo",
                                                  style: pw.TextStyle(
                                                    color: PdfColor.fromHex("695ACD"),
                                                    // fontWeight: pw.FontWeight.w600,
                                                  )
                                              )
                                            ]
                                        )),
                                  ),
                                )
                              ],)
                          ],
                        ),
                      ),
                    ]
                ),
                pw.Image( pw.MemoryImage(imageData),)
              ]
          );
      },
    ),
  );
  return pdf.save();

}
pw.SizedBox gap(double? value) =>  pw.SizedBox(height: value??20,);
pw.SizedBox gapW(double? value) =>  pw.SizedBox(width: value??20,);
pw.SizedBox gap2(double? value) =>  pw.SizedBox(height: value??10,);

String getTotalAmount(bool isOrder,List<OrderItems>? orderData,
    List<SaleListDataInfo>data){
  double amount =0.0;
  if(isOrder){
    for(var element in orderData!){
      amount = amount +(element.quantity*element.sellingPrice);
    }
  }else{
    for(var element in data[0].saleProducts){
      amount = amount +(element.quantity*element.sellingPrice);
    }
  }

  return amount.toString();
}

pw.Text txt({required String text,required double size,
  align = pw.TextAlign.center,color = PdfColors.black,weight = pw.FontWeight.normal,maxLine= 1,
  fontF = "Graphik"
}) {
  return pw.Text(text,
      textAlign: align,
      maxLines: maxLine,
      //  overflow: TextOverflow.clip,
      style: pw.TextStyle(
        fontSize: size,
        color: color,
        fontWeight: weight,
        // fontFamily: fontF
        /// color:  Color(0xFF7C5CFC)
      )
  );
}

pw.Text customTextnaira1(String text, color, double size, dataFont,
    {indent = pw.TextAlign.start, fontWeight = pw.FontWeight.normal, maxLines = 1,
    }) {

  return pw.Text(
    text,
    textAlign: indent,
    maxLines: maxLines,
    // overflow: TextOverflow.ellipsis,
    // softWrap: false,

    style: pw.TextStyle(
      fontFallback: [pw.Font.times()],
      color: color,
      fontSize: size,
      font: pw.Font.ttf(dataFont),
      fontWeight: fontWeight,
    ),
  );
}