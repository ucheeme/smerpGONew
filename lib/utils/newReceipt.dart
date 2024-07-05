import 'dart:io';
import 'dart:typed_data';

import 'package:date_format/date_format.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smerp_go/utils/AppUtils.dart';
import 'package:smerp_go/utils/appDesignUtil.dart';

import '../cubit/bankDetail/bank_details_cubit.dart';
import '../model/response/order/orderDetails.dart';
import '../model/response/sales/saleListInfo.dart';
import 'appColors.dart';

class SmerpGoReceipt extends StatefulWidget {
  List<SaleListDataInfo> saleListInfo=[];
  List<OrderItems>? items =[];
  bool isOrder= false;
  String? customerName;
  int? paymentStatus;
  DateTime? orderPlacedAt;
  DateTime? orderCompletedAt;
  String? deliveryAddress;
   SmerpGoReceipt({super.key,required this.saleListInfo,
     this.items,required this.isOrder,this.customerName, this.paymentStatus,
   this.deliveryAddress,this.orderCompletedAt,this.orderPlacedAt,});
  @override
  State<SmerpGoReceipt> createState() => _SmerpGoReceiptState();
}

class _SmerpGoReceiptState extends State<SmerpGoReceipt> {
  final customerReceiptKey = GlobalKey();
  final GlobalKey<ScreenshotState> _screenshotKey = GlobalKey<ScreenshotState>();
  var datePlaced="";
  var dateCompleted="";
  ScreenshotController screenshotController = ScreenshotController();
  List<SaleListDataInfo> data =[];
  List<OrderItems>? orderData =[];
  @override
  void initState() {
    data = widget.saleListInfo;
    orderData = widget.items;
    print("this is the payment status:${widget.paymentStatus}");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.now();
    print(dateTime.format(DateTimeFormats.american));
    datePlaced = (widget.orderPlacedAt==null)?
    formatDate(
        widget.orderPlacedAt!,
       [dd, '/',mm, '/', yyyy, hh,":",mm," ", am],
    ):dateTime.format(DateTimeFormats.american);

    dateCompleted= (widget.orderCompletedAt==null)?
    formatDate(widget.orderCompletedAt!,
      [dd, '/',mm, '/', yyyy," ", hh,":",mm," ", am],
    ):dateTime.format(DateTimeFormats.american);
    return MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: SafeArea(top: false,
              child: Container(
                color: Colors.white,
                child: Stack(
                  alignment: Alignment.center,
                  fit:StackFit.passthrough,
                  children: [
                    Column(
                    children: [
                      Image.asset("assets/smerp_heading.png",height: 100,
                        width: double.infinity,fit: BoxFit.contain,),///header
                      Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Column(children: [
                              Column(children: [
                                txt(text: "${widget.customerName}!"
                                    " Here are your order details", size: 12.sp,
                                  maxLine: 3,
                                  color: Color(0xFF111827),
                                  weight: FontWeight.w600, ),
                                gap(),
                                txt(text: (widget.paymentStatus==1)?"RECEIPT":"INVOICE", size: 14,
                                    color: const Color(0xFF7C5CFC),weight: FontWeight.w700),
                            ],
                              ),
                              gap(),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        txt(text: 'Order placed at:', size: 12),
                                        txt(text: dateCompleted, size: 10,
                                            weight: FontWeight.w700),
                                        Gap(45),
                                        txt(text: 'Ordered from:', size: 12,),
                                        txt(text: "${loginData!.storeName}", size: 12,
                                            weight: FontWeight.w700),
                                        gap2(),
                                        txt(text: "${loginData!.storeEmail}",
                                          size: 12,color: Color(0xFF888888),),
                                        gap2(),
                                        txt(text: "${loginData!.storePhoneNumber}",
                                          size: 12,color: Color(0xFF888888),)
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        txt(text: 'Order completed at:',
                                            size: 12,align: TextAlign.end),
                                        txt(text: dateCompleted,
                                            size: 10,weight: FontWeight.w700,
                                            align: TextAlign.end),
                                        Gap(45),
                                        txt(text: (widget.paymentStatus==1)?
                                        'Delivered to:':'Billed to:', size: 12,
                                            align: TextAlign.end),
                                       // gap2(),
                                        txt(text: "${widget.customerName}",
                                            size: 12,weight: FontWeight.w700,
                                            align: TextAlign.end),
                                        gap2(),
                                        txt(text: widget.deliveryAddress??"none", size: 10,color: Color(0xFF888888),maxLine: 2,align: TextAlign.end),
                                      ],
                                    ),
                                  ),
                                ],),
                              Gap(50),
                              Table(
                                border: TableBorder.symmetric(
                                  outside: BorderSide.none,
                                  inside: BorderSide.none,
                                ),
                                children: [
                                  TableRow(
                                    children: [
                                      TableCell(child: txt(text: "Item Name", size: 14,weight: FontWeight.w700,maxLine: 1,align: TextAlign.start)),
                                      TableCell(child: txt(text: "Quantity/Price", size: 14,weight: FontWeight.w700,maxLine: 1)),
                                      TableCell(child: txt(text: "Value", size: 14,weight: FontWeight.w700,maxLine: 1,align: TextAlign.end)),
                                    ],
                                  ),
                                ],
                              ),
                              // gap(),
                              Container(
                                height: 300.h,
                                color: kWhite,
                                padding: EdgeInsets.zero,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: (widget.isOrder)?orderData!.length:
                                    data[0].saleProducts.length,
                                    itemBuilder: (context, index){
                                      var items =(widget.isOrder)?
                                      orderData![index]:null;
                                      var currentData=(widget.isOrder)?null:
                                      data[0].saleProducts[index];
                                      return (widget.isOrder)?
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 120.w,
                                            height: 50.h,

                                            child:Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding:  EdgeInsets.zero,
                                                child: SizedBox(
                                                  width: 300.w,
                                                  child: customText1(
                                                      items!.productName,kBlack,
                                                      14.sp, fontWeight: FontWeight.w300),
                                                ),
                                              ),
                                            ) ,
                                          ),
                                          Container(
                                            width: 120.w,
                                            height: 50.h,
                                            child:Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding:  EdgeInsets.only(left: 10.w),
                                                child: customTextnaira("${items.quantity.toString()} x${
                                                    NumberFormat.simpleCurrency(
                                                        name: 'NGN').format(
                                                        double.parse(
                                                            items.sellingPrice.toString()
                                                        )).split(".")[0]}",
                                                    kBlack,
                                                    14.sp, fontWeight: FontWeight.w300),
                                              ),
                                            ) ,
                                          ),

                                          Container(
                                            width: 120.w,
                                            height: 50.h,
                                            child:Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                  padding:  EdgeInsets.only(right: 5.w),
                                                  child:  customTextnaira(
                                                      "${NumberFormat.simpleCurrency(
                                                          name: 'NGN').format(
                                                          double.parse(
                                                              (items.quantity*items.sellingPrice).toString()
                                                          )).split(".")[0]}", kBlack,
                                                      14.sp,
                                                      fontWeight: FontWeight.w300)
                                              ),
                                            ) ,
                                          ),
                                        ],
                                      ):
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 120.w,
                                            height: 50.h,
                                            child:Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding:  EdgeInsets.zero,
                                                child: customText1(
                                                    (currentData!.productName.length>=8)?
                                                    currentData.productName.replaceRange(8,
                                                        currentData.productName.length, '...'):
                                                    currentData.productName,kBlack,
                                                    14.sp, fontWeight: FontWeight.w300),
                                              ),
                                            ) ,
                                          ),
                                          Container(
                                            width: 120.w,
                                            height: 50.h,
                                            child:Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding:  EdgeInsets.only(left: 10.w),
                                                child: customTextnaira("${currentData.quantity.toString()} x${
                                                    NumberFormat.simpleCurrency(
                                                        name: 'NGN').format(
                                                        double.parse(
                                                            currentData.sellingPrice.toString()
                                                        )).split(".")[0]}",
                                                    kBlack,
                                                    14.sp, fontWeight: FontWeight.w300),
                                              ),
                                            ) ,
                                          ),
                                          Container(
                                            width: 120.w,
                                            height: 50.h,
                                            // color:kAppBlue,
                                            child:Align(
                                              alignment: Alignment.centerRight,
                                              child: customTextnaira(
                                                  "${NumberFormat.simpleCurrency(
                                                      name: 'NGN').format(
                                                      double.parse(
                                                          (currentData.quantity*currentData.sellingPrice).toString()
                                                      )).split(".")[0]}", kBlack,
                                                  14.sp,
                                                  fontWeight: FontWeight.w300),
                                            ) ,
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                              Row(
                                children: [
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                txt(text: "${storeBankDetail?.bankName??""}", size: 13,maxLine: 1,
                                                    weight: FontWeight.bold,
                                                    color: const Color(0xFF7C5CFC),align: TextAlign.start),

                                                txt(text: "${storeBankDetail?.accountNumber??""}", size: 12,
                                                    color: const Color(0xFF7C5CFC),weight: FontWeight.bold,align: TextAlign.start),

                                                txt(text: "${storeBankDetail?.accountName??""}", size: 12,
                                                    color: const Color(0xFF7C5CFC),weight: FontWeight.bold,align: TextAlign.start),
                                              ],),
                                          ],),
                                      ]
                                  ),
                                  Spacer(),
                                  Row(mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          txt(text: "Subtotal:", size: 12,maxLine: 1,color: const Color(0xFF888888),align: TextAlign.end),
                                          gap2(),
                                          txt(text: "Grand Total:", size: 16,
                                              color: const Color(0xFF7C5CFC),weight: FontWeight.w700,align: TextAlign.end),
                                        ],),
                                      const SizedBox(width: 40,),

                                      Column(crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          customTextnaira(
                                              "${NumberFormat.simpleCurrency(
                                                  name: 'NGN').format(
                                                  double.parse(
                                                      getTotalAmount()
                                                  )).split(".")[0]}", Color(0xFF888888),
                                              14.sp,
                                              fontWeight: FontWeight.w500),
                                          gap2(),
                                          customTextnaira(
                                              "${NumberFormat.simpleCurrency(
                                                  name: 'NGN').format(
                                                  double.parse(
                                                      getTotalAmount()
                                                  )).split(".")[0]}", kAppBlue,
                                              18.sp,
                                              maxLines: 3,
                                              fontWeight: FontWeight.w500)
                                        ],),

                                    ],),
                                ],
                              ),
                              gap(),
                            ],),
                          )),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                        decoration: BoxDecoration(
                            color: Color(0xFFF8F7FF),
                            border: Border(
                                top: BorderSide(width: 2, color: Color(0xFF7C5CFC),),
                                bottom: BorderSide(width: 7, color: Color(0xFF7C5CFC),)
                            )
                        ),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/smerp_logo.png",width: 100,fit: BoxFit.contain,),
                            Column(crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                txt(text: "Powered By Fifthlab", size: 13,maxLine: 1,
                                    align: TextAlign.end,weight: FontWeight.w600),
                                SizedBox(width: 250,
                                  child: Align(
                                    alignment: Alignment.centerRight,

                                    child: RichText(
                                      textAlign: TextAlign.end,
                                        text:
                                    TextSpan(
                                     text: "You’re receiving this because \n ${loginData!.storeName} is a user of",
                                        style:TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF888888),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: fontFamilyGraphilk
                                        ),
                                      children: [
                                        TextSpan(
                                          text: " SmerpGo",
                                          style: TextStyle(
                                            color: kAppBlue,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: fontFamilyGraphilk
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
                    ],
                  ),
                   Image.asset ((widget.paymentStatus==1)?
                       "assets/receiptPaid.png":"assets/receiptUnpaid.png")
              ]
                ),
              ),
            ),
          ),
        ),
    );
  }

  String getTotalAmount(){
    double amount =0.0;
    if(widget.isOrder){
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


  Future<void> saveAsImage(Uint8List image) async {
    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/image.png').create();
      await imagePath.writeAsBytes(image);
      Fluttertoast.showToast(msg: "Receipt downloaded successfully at ${imagePath.path}");
      await Share.shareFiles([imagePath.path]);
    }

  }


  // Future<void> _saveWidgetAsImage(BuildContext context) async {
  //   try {
  //     // Capture the screenshot of the widget
  //     final imageBytes = await _screenshotKey.currentState!.capture();
  //
  //     // Get the directory for saving images
  //     final directory = (await getTemporaryDirectory()).path;
  //
  //     // Save the image to a file
  //     final imagePath = '$directory/flutter_widget.png';
  //     await File(imagePath).writeAsBytes(imageBytes);
  //
  //     // Save the image to the device's gallery
  //     await ImageGallerySaver.saveFile(imagePath);
  //
  //     // Show a success message
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Widget saved as image'),
  //     ));
  //   } catch (e) {
  //     print('Error saving widget as image: $e');
  //     // Show an error message
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Error saving widget as image'),
  //     ));
  //   }
  // }


  SizedBox gap() => const SizedBox(height: 20,);
  SizedBox gap2() => const SizedBox(height: 10,);

  Text txt({required String text,required double size,
    align = TextAlign.center,color = Colors.black
    ,weight = FontWeight.w500,maxLine= 1,
    fontF = "Graphik"
  }) {
    return Text(text,
        textAlign: align,
        maxLines: maxLine,
        style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: weight,
          fontFamily: fontF
          /// color:  Color(0xFF7C5CFC)
        )
    );
  }
}
