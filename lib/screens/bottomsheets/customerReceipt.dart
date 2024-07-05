// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:date_format/date_format.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:smerp_go/utils/AppUtils.dart';
// import 'package:smerp_go/utils/UserUtils.dart';
// import 'package:smerp_go/utils/appColors.dart';
// import 'package:smerp_go/utils/appDesignUtil.dart';
//
// import '../../model/response/order/orderDetails.dart';
// import '../../model/response/sales/saleListInfo.dart';
// import '../../utils/fileStorage.dart';
//
// class CustomerReceipt extends StatefulWidget {
//   List<SaleListDataInfo> saleListInfo=[];
//   List<OrderItems>? items =[];
//   bool isOrder= false;
//   String? customerName;
//   int? paymentStatus;
//    CustomerReceipt({super.key,required this.saleListInfo,
//    this.items,required this.isOrder,this.customerName, this.paymentStatus});
//
//   @override
//   State<CustomerReceipt> createState() => _CustomerReceiptState();
// }
//
// class _CustomerReceiptState extends State<CustomerReceipt> {
//   final customerReceiptkey = GlobalKey();
//   var date="";
//   ScreenshotController screenshotController = ScreenshotController();
//   List<SaleListDataInfo> data =[];
//   List<OrderItems>? orderData =[];
//   @override
//   void initState() {
//    data = widget.saleListInfo;
//    orderData = widget.items;
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     date = formatDate(
//         (DateTime.now()).toLocal(),
//         [dd, ', ',MM, ', ', yyyy]);
//     return Scaffold(
//       appBar: PreferredSize(
//           child: customerReceiptDashboardAppBarWidget(() {
//
//             Get.back();
//           },(widget.isOrder)?"Customer Invoice" :
//           "Customer Receipt",context: context,
//               downloadReceipt:  () {
//                 screenshotController
//                     .capture()
//                     .then((capturedImage) async {
//                   setState(() {
//                    capturedImage;
//                   });
//                   saveAsImage(capturedImage!);
//                   // ShowCapturedWidget(context, capturedImage!);
//                 }).catchError((onError) {
//                   print(onError);
//                 });
//               }),
//           preferredSize: Size.fromHeight(80.h)),
//       backgroundColor: kWhite,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             gapHeight(20.h),
//             Screenshot(
//               controller: screenshotController,
//               child: Container(
//                 color: kWhite,
//                 height: 900.h,
//                 width: MediaQuery.of(context).size.width,
//                 child: Column(
//                   children: [
//                     Container(
//                       height: 150.h,
//                       width: MediaQuery.of(context).size.width,
//                       color: kAppBlue,
//                       child: Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               height: 45.h,
//                               width: 45.h,
//                               decoration: BoxDecoration(
//                                 color: Colors.transparent,
//                                 shape: BoxShape.circle,
//                                 image:
//                                 DecorationImage(image: getImageNetwork(userImage.value).image,
//                                     fit: BoxFit.fill),
//                               ),
//                             ),
//                             gapHeight(12.h),
//                            customText1((widget.isOrder)?"${userBusinessName.value} Store invoice"
//                                :"${userBusinessName.value} Store receipt",
//                                 kWhite, 24.sp,
//                                fontWeight: FontWeight.w500,
//                                fontFamily: fontFamilyGraphilk),
//                            // gapHeight(12.h),
//                             customText1(date,
//                                 kWhite, 15.sp,fontWeight: FontWeight.w500),
//                           ],
//                         ),
//                       ),
//                     ),
//                 gapHeight(30.h),
//                 Padding(
//                   padding:  EdgeInsets.only(left:10.w,right:10.w),
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.vertical,
//                     child:Container(
//                       color: kWhite,
//                       child: Column(
//                         children: [
//                           Container(
//                             color: kWhite,
//                             child: Row(
//                               children: [
//                                 Container(
//                                   width: 120.w,
//                                   height: 50.h,
//                                   decoration: BoxDecoration(
//                                      color: Colors.grey.withOpacity(0.05),
//                                       borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(20.r))
//                                   ),
//                                   child:Align(
//                                     alignment: Alignment.centerLeft,
//                                     child: Padding(
//                                       padding:  EdgeInsets.only(left: 10.w),
//                                       child: customText1("Item",kBlack,
//                                           16.sp,
//                                           fontFamily: fontFamilyInter,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                   ) ,
//                                 ),
//                                 Container(
//                                   width: 120.w,
//                                   height: 50.h,
//                                   decoration: BoxDecoration(
//                                       color: Colors.grey.withOpacity(0.05),
//                                   ),
//
//                                   child:Align(
//                                     alignment: Alignment.centerLeft,
//                                     child: Padding(
//                                       padding:  EdgeInsets.only(left: 10.w),
//                                       child: customText1("Unit price",kBlack,
//                                           16.sp, fontWeight: FontWeight.w400),
//                                     ),
//                                   ) ,
//                                 ),
//                                 Container(
//                                   width: 50.w,
//                                   height: 50.h,
//                                   decoration: BoxDecoration(
//                                       color: Colors.grey.withOpacity(0.05),
//                                   ),
//
//                                   child:Align(
//                                     alignment: Alignment.centerLeft,
//                                     child: Padding(
//                                       padding:  EdgeInsets.only(left: 10.w),
//                                       child: customText1("Qty",kBlack,
//                                           16.sp, fontWeight: FontWeight.w400),
//                                     ),
//                                   ) ,
//                                 ),
//                                 Container(
//                                   width: 120.w,
//                                   height: 50.h,
//                                   decoration: BoxDecoration(
//                                       color: Colors.grey.withOpacity(0.05),
//                                       borderRadius: BorderRadius.only(
//                                           topRight: Radius.circular(20.r))
//                                   ),
//
//                                   child:Align(
//                                     alignment: Alignment.centerRight,
//                                     child: Padding(
//                                       padding:  EdgeInsets.only(right: 10.w),
//                                       child: customText1("Amount",kBlack,
//                                           16.sp, fontWeight: FontWeight.w400),
//                                     ),
//                                   ) ,
//                                 ),
//                               ],
//                             ),
//                           ),
//                          gapHeight(20.h),
//                          Container(
//                             height: 350.h,
//                             color: kWhite,
//                             padding: EdgeInsets.zero,
//                             child: ListView.builder(
//                               shrinkWrap: true,
//                                 padding: EdgeInsets.zero,
//                                 itemCount: (widget.isOrder)?orderData!.length:
//                                 data[0].saleProducts.length,
//                                itemBuilder: (context, index){
//                                 var items =(widget.isOrder)?
//                                 orderData![index]:null;
//                                var currentData=(widget.isOrder)?null:
//                                  data[0].saleProducts[index];
//                               return (widget.isOrder)?
//                               Row(
//
//                                 children: [
//                                   Container(
//                                     width: 120.w,
//                                     height: 50.h,
//
//                                     child:Align(
//                                       alignment: Alignment.centerLeft,
//                                       child: Padding(
//                                         padding:  EdgeInsets.only(left: 10.w),
//                                         child: customText1(
//                                             (items!.productName.length>=8)?
//                                             items.productName.replaceRange(8,
//                                                 items.productName.length, '...'):
//                                             items.productName,kBlack,
//                                             16.sp, fontWeight: FontWeight.w300),
//                                       ),
//                                     ) ,
//                                   ),
//                                   Container(
//                                     width: 120.w,
//                                     height: 50.h,
//
//
//                                     child:Align(
//                                       alignment: Alignment.centerLeft,
//                                       child: Padding(
//                                         padding:  EdgeInsets.only(left: 10.w),
//                                         child: customTextnaira(NumberFormat.simpleCurrency(
//                                             name: 'NGN').format(
//                                             double.parse(
//                                                 items.sellingPrice.toString()
//                                             )).split(".")[0],
//                                             kBlack,
//                                             16.sp, fontWeight: FontWeight.w300),
//                                       ),
//                                     ) ,
//                                   ),
//                                   Container(
//                                     width: 50.w,
//                                     height: 50.h,
//                                     child:Align(
//                                       alignment: Alignment.centerLeft,
//                                       child: Padding(
//                                         padding:  EdgeInsets.only(left: 10.w),
//                                         child: customText1(items.quantity.toString(),kBlack,
//                                             16.sp, fontWeight: FontWeight.w300),
//                                       ),
//                                     ) ,
//                                   ),
//                                   Container(
//                                     width: 120.w,
//                                     height: 50.h,
//                                     child:Align(
//                                       alignment: Alignment.centerRight,
//                                       child: Padding(
//                                           padding:  EdgeInsets.only(right: 10.w),
//                                           child:  customTextnaira(
//                                               "${NumberFormat.simpleCurrency(
//                                                   name: 'NGN').format(
//                                                   double.parse(
//                                                       (items.quantity*items.sellingPrice).toString()
//                                                   )).split(".")[0]}", kBlack,
//                                               16.sp,
//                                               fontWeight: FontWeight.w300)
//                                       ),
//                                     ) ,
//                                   ),
//                                 ],
//                               ):
//                               Row(
//
//                                 children: [
//                                   Container(
//                                     width: 120.w,
//                                     height: 50.h,
//
//                                     child:Align(
//                                       alignment: Alignment.centerLeft,
//                                       child: Padding(
//                                         padding:  EdgeInsets.only(left: 10.w),
//                                         child: customText1(
//                                             (currentData!.productName.length>=8)?
//                                                 currentData.productName.replaceRange(8,
//                                                     currentData.productName.length, '...'):
//                                             currentData.productName,kBlack,
//                                             16.sp, fontWeight: FontWeight.w300),
//                                       ),
//                                     ) ,
//                                   ),
//                                   Container(
//                                     width: 120.w,
//                                     height: 50.h,
//
//
//                                     child:Align(
//                                       alignment: Alignment.centerLeft,
//                                       child: Padding(
//                                         padding:  EdgeInsets.only(left: 10.w),
//                                        child: customTextnaira(NumberFormat.simpleCurrency(
//                                            name: 'NGN').format(
//                                            double.parse(
//                                                currentData.sellingPrice.toString()
//                                            )).split(".")[0],
//                                            kBlack,
//                                             16.sp, fontWeight: FontWeight.w300),
//                                       ),
//                                     ) ,
//                                   ),
//                                   Container(
//                                     width: 50.w,
//                                     height: 50.h,
//                                     child:Align(
//                                       alignment: Alignment.centerLeft,
//                                       child: Padding(
//                                         padding:  EdgeInsets.only(left: 10.w),
//                                         child: customText1(currentData.quantity.toString(),kBlack,
//                                             16.sp, fontWeight: FontWeight.w300),
//                                       ),
//                                     ) ,
//                                   ),
//                                   Container(
//                                     width: 120.w,
//                                     height: 50.h,
//                                     child:Align(
//                                       alignment: Alignment.centerRight,
//                                       child: Padding(
//                                         padding:  EdgeInsets.only(right: 10.w),
//                                         child:  customTextnaira(
//                                             "${NumberFormat.simpleCurrency(
//                                                 name: 'NGN').format(
//                                                 double.parse(
//                                                     (currentData.quantity*currentData.sellingPrice).toString()
//                                                 )).split(".")[0]}", kBlack,
//                                             16.sp,
//                                             fontWeight: FontWeight.w300)
//                                       ),
//                                     ) ,
//                                   ),
//                                 ],
//                               );
//                             }),
//                           ),
//                           gapHeight(20.h),
//                           Container(
//                             width: 390.w,
//                             height: 50.h,
//                             decoration: BoxDecoration(
//                                 color: Colors.grey.withOpacity(0.05),
//                                 borderRadius: BorderRadius.only(
//                                     bottomLeft: Radius.circular(20.r))
//                             ),
//                             child:Padding(
//                               padding:  EdgeInsets.only(left: 10.w),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   customText1("Total",kBlack,
//                                       16.sp, fontWeight: FontWeight.w400),
//                                   customTextnaira(
//                                       "${NumberFormat.simpleCurrency(
//                                           name: 'NGN').format(
//                                           double.parse(
//                                           getTotalAmount()
//                                           )).split(".")[0]}", kBlack,
//                                       24.sp,
//                                       fontWeight: FontWeight.w500)
//                                 ],
//                               ),
//                             ) ,
//                           ),
//                           gapHeight(79.h),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               SvgPicture.asset("assets/smerpGoReceiptLogo.svg",width: 30.w,
//                                 height: 30.h,
//                           ),
//                               Container(
//                                 width: 300.h,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     customText1("Powered by Fifthlab", kBlack,12.sp,fontWeight: FontWeight.w400 ),
//                                     customText1("The simplest booking for SME business", kBlack,12.sp,fontWeight: FontWeight.w400 ),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           )
//                         ],
//                       ),
//                     )
//                   ),
//                 )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//    );
//   }
//   String getTotalAmount(){
//     double amount =0.0;
//     if(widget.isOrder){
//       for(var element in orderData!){
//         amount = amount +(element.quantity*element.sellingPrice);
//       }
//     }else{
//       for(var element in data[0].saleProducts){
//         amount = amount +(element.quantity*element.sellingPrice);
//       }
//     }
//
//     return amount.toString();
//   }
//
//   Future<void> saveAsImage(Uint8List image) async {
//     if (image != null) {
//       final directory = await getApplicationDocumentsDirectory();
//       final imagePath = await File('${directory.path}/image.png').create();
//       await imagePath.writeAsBytes(image);
//       Fluttertoast.showToast(msg: "Receipt downloaded successfully at ${imagePath.path}");
//       await Share.shareFiles([imagePath.path]);
//     }
//
//   }
// }
//
//
