import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:date_format/date_format.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_saver/flutter_image_saver.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
// import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smerp_go/screens/bottomsheets/customerReceipt.dart';
import 'package:smerp_go/screens/bottomsheets/downloadFormat.dart';
import 'package:smerp_go/utils/downloadAsImage.dart';
import 'package:smerp_go/utils/newReceipt.dart';

import '../../controller/addSaleController.dart';
import '../../controller/dashboardController.dart';
import '../../controller/orderController.dart';
import '../../controller/signupController.dart';
import '../../model/response/order/orderDetails.dart';
import '../../model/response/sales/saleListInfo.dart';
import '../../utils/AppUtils.dart';
import '../../utils/UserUtils.dart';
import '../../utils/appColors.dart';
import '../../utils/appDesignUtil.dart';
import '../../utils/fileStorage.dart';
import '../../utils/pdfReceiptDesign.dart';

class ReceiptInApp extends StatefulWidget {
  int? saleId;
  DateTime date;
  String? customerName;
  bool isOrder =false;
  int? orderId;
  String? paymentStatus;
  ReceiptInApp({super.key, this.saleId, required this.date,
    required this.isOrder,this.orderId,this.paymentStatus,
    this.customerName
  });
  @override
  State<ReceiptInApp> createState() => _ReceiptInAppState();
}

class _ReceiptInAppState extends State<ReceiptInApp> {
  final repaintBoundary = GlobalKey();
  var _controller = Get.put(AddNewSaleController());
  var _controllerDashboard = Get.put(DashboardController());
  var _controllerOrders= Get.put(OrderController());
  OrderInformation? orderInformation;
  var paymentStatus = "";
  String customersName = "";
  var date = "";
  int paymentStatusId = 0;
  double totalAmount = 0.0;
   Uint8List image =Uint8List(0);
 // XFile file = XFile();
  final doc = pw.Document();

  RxBool isLoading = false.obs;
  List<SaleListDataInfo> saleListInfo = [SaleListDataInfo(salesId: 0, customerName: '', saleProducts: [])];
  ScreenshotController _screenshotController = ScreenshotController();
@override
  void initState() {
  customersName=  widget.customerName??"";
  print("this is the customerName:${widget.customerName}");
  paymentStatus = widget.paymentStatus??"";
  print("this is the payment=${widget.paymentStatus}");
  if(widget.isOrder){
    getOrderDetails();
  }else{
   getDetails();
  }
    super.initState();
  }
  void getDetails() async {
    isLoading.value = true;
    saleListInfo = await _controller.saleListData(widget.saleId!, isLoading);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        saleListInfo = saleListInfo;
        isLoading.value = false;
        _controller.isLoading.value = false;
        date = formatDate(saleListInfo[0].saleProducts[0].createdOn, [dd, '/', mm, '/', yy]);
      });
      if (saleListInfo[0].saleProducts.length == 1) {
        _controller.prodName = saleListInfo[0].saleProducts[0].productName;
        _controller.quantityController.text = saleListInfo[0].saleProducts[0].quantity.toString();
        _controller.prodUnitName = saleListInfo[0].saleProducts[0].productUnitCategory;
        _controller.editTotalSaleCost = saleListInfo[0].saleProducts[0].salesAmount;
        paymentStatus = saleListInfo[0].saleProducts[0].paymentStatus;
        print("the payment is: $paymentStatus");
       _controller.paymentStatus.value = _controller.paymentStatusid(paymentStatus);
        _controller.qty = saleListInfo[0].saleProducts[0].quantity;
        (widget.customerName==null)? saleListInfo[0].customerName : widget.customerName!;
        _controller.customerName.text =(widget.customerName==null)? saleListInfo[0].customerName :widget.customerName!;
      }
      else {
        setState(() {
          customersName =(widget.customerName==null)? saleListInfo[0].customerName :widget.customerName!;
        });
        print("user name is $customersName");
       // _controller.paymentStatus.value=_controller.paymentStatusid(saleListInfo[0].saleProducts[0].paymentStatus);
        _controller.paymentStatus.value=_controller.paymentStatusid(paymentStatus);
        print("user name payment status is ${saleListInfo[0].saleProducts[0].paymentStatus}");
        totalAmount = 0;
        for (var element in saleListInfo[0].saleProducts) {
          setState(() {
           totalAmount =
                totalAmount + (element.sellingPrice * element.quantity);
          });
        }
     }
    });
  }


  @override
  void dispose() {
    customersName="";
    _controller.dispose();
    _controllerDashboard.dispose();
    super.dispose();
  }
    @override
  Widget build(BuildContext context) {
     // getCustomerReceipt();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.h),
        child: Column(
          children: [
            (isLoading.value)?
            Center(
              child: Container(
                height: 350.h,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 300.h,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          backgroundColor: kAppBlue,
                 ),
                        gapHeight(15.h),
                        customText1("loading sale information, please wait..",
                            kBlack, 14.sp,fontWeight: FontWeight.w400,fontFamily: fontFamily)
                      ],
                    ),
                  ),
                ),
              ),
            )
                :
            (saleListInfo[0].saleProducts.length==1)?
                Column(
                children: [
                    gapHeight(15.h),

                    Container(
                        width: double.infinity,
                        height: 320.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15.r),
                                topLeft: Radius.circular(15.r),
                              ),
                              color: kLightPink.withOpacity(0.7),
                            ),
                            height: 52.h,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: 10.w, left: 10.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    //color: kAppBlue,
                                    width: 200.w,
                                    child: customText1(
                                        "${customersName} "
                                            "sales receipt" , kBlack.withOpacity(0.6), 16.sp),
                                  ),
                                  customText1(
                                      date, kBlack.withOpacity(0.6), 14.sp),
                                ],
                              ),
                            ),
                          ),

                          Container(
                            height: 100.h,
                            width: double.infinity,
                            child: editSaleSelectedDesign(
                                saleListInfo[0].saleProducts[0],
                                null,
                                quantity: saleListInfo![0].saleProducts[0].quantity,
                                paymentStatus: paymentStatusStringToInt(saleListInfo[0]
                                    .saleProducts[0].paymentStatus)),
                          ),
                          gapHeight(10.h),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(15.r),
                                bottomLeft: Radius.circular(15.r),
                              ),
                              color: kLightPink.withOpacity(0.7),
                            ),
                            height: 85.h,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 10.h, right: 10.w, left: 10.w),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(top: 10.h,bottom: 10.h),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        customText1("Items", kBlack, 14.sp),
                                        customText1("Total", kBlack, 18.sp),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(top: 5.h,bottom: 5.h),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        customText1( saleListInfo[0].
                                        saleProducts.length.toString(), kBlack, 14.sp),
                                        customTextnaira(
                                            NumberFormat.simpleCurrency(
                                                name: 'NGN')
                                                .format(double.parse(_controller
                                                .editTotalSaleCost
                                                .toString()))
                                                .split(".")[0],
                                            kAppBlue,
                                            24.sp,
                                            fontWeight: FontWeight.w500),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ])),
                    gapHeight(40.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                      children: [
                        GestureDetector(
                          onTap: () async {
                              generateAndDownloadAsImage(customersName,paymentStatusId,
                              widget.isOrder);
                              },
                          child: Column(
                            children: [
                              Container(
                                  child:SvgPicture.asset(
                                     "assets/shareCopy.svg",
                                      fit: BoxFit.scaleDown),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(10.r),
                                      color:kLightPink.withOpacity(0.7)),
                                  height:44.h,
                                  width: 44.w),
                              gapHeight(10.h),
                              customText1("Share", kBlack, 14.sp,fontWeight: FontWeight.w300)
                            ],
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: () async {
                        //     Get.to(SmerpGoReceipt(saleListInfo: saleListInfo, isOrder: false));
                        //     // if(image!=null){
                        //     //   generateAndDownloadAsImage(image!,customersName,paymentStatusId);
                        //     // }
                        //   },
                        //   child: Column(
                        //     children: [
                        //       Container(
                        //           child:SvgPicture.asset(
                        //               "assets/import.svg", fit: BoxFit.scaleDown),
                        //           decoration: BoxDecoration(
                        //               shape: BoxShape.rectangle,
                        //              borderRadius: BorderRadius.circular(10.r),
                        //              color:kLightPink.withOpacity(0.7)),
                        //           height:44.h,
                        //          width: 44.w),
                        //       gapHeight(10.h),
                        //       customText1("Download", kBlack, 14.sp,fontWeight: FontWeight.w300)
                        //     ],
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: (){
                            generatePdf(
                              (widget.isOrder)?[]:saleListInfo,
                              (widget.isOrder)?orderInformation!.items:[],
                            paymentStatus:(widget.isOrder)?orderInformation!.paymentStatus:
                                _controller.paymentStatus.value,
                              orderCompletedAt:(widget.isOrder)?orderInformation?.deliveryDate:
                                  saleListInfo[0].saleProducts[0].createdOn,
                              isOrder: widget.isOrder,
                              deliveryAddress: (widget.isOrder)?
                                  orderInformation!.buyer.address:"none available",
                              orderPlacedAt: (widget.isOrder)?orderInformation!.orderDate:
                                  saleListInfo[0].saleProducts[0].timeStamp,
                              customerName:(widget.isOrder)?orderInformation!.buyer.name
                                  :saleListInfo[0].customerName,
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                child:SvgPicture.asset(
                                    "assets/printer.svg", fit: BoxFit.scaleDown),
                                  decoration: BoxDecoration(
                                     shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(10.r),
                                      color:kLightPink.withOpacity(0.7)),
                                  height:44.h,
                                  width: 44.w),
                              gapHeight(10.h),
                              customText1("Print", kBlack, 14.sp,fontWeight: FontWeight.w300)
                            ],
                          )
                        ),
                      ],
                    ),
                  ],
                ):
            Column(
              children: [
                gapHeight(15.h),
                Container(
                    width: double.infinity,
                    height:_controllerDashboard.getReceiptHeight(saleListInfo[0].saleProducts.length)-200.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Column(children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15.r),
                            topLeft: Radius.circular(15.r),
                          ),
                          color: kLightPink.withOpacity(0.7),
                        ),
                        height: 52.h,
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: 10.w, left: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 200.w,
                                child: customText1(
                                    "${customersName} "
                                        "sales receipt" , kBlackB700, 18.sp),
                              ),
                              customText1(
                                  date, kBlack.withOpacity(0.3), 14.sp),
                            ],
                          ),
                        ),
                      ),
                      // (_controller.product == null) ? Container(
                      //   height: 90.h,
                      //   width: double.infinity,
                      // ) :
                      gapHeight(20.h),
                      Container(
                        height: _controllerDashboard.getReceiptHeight(saleListInfo[0].saleProducts.length)-370.h,
                        width: double.infinity,
                        child: ListView.builder(
                          itemCount: saleListInfo[0].saleProducts.length,
                          itemBuilder: (context,index){
                            return editSaleSelectedDesign(
                            saleListInfo[0].saleProducts[index],
                        null,
                        quantity: saleListInfo![0].saleProducts[index].quantity,
                        paymentStatus: paymentStatusStringToInt(saleListInfo[0]
                            .saleProducts[index].paymentStatus));
                        }

                        ),
                      ),
                      gapHeight(10.h),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15.r),
                            bottomLeft: Radius.circular(15.r),
                          ),
                          color: kLightPink.withOpacity(0.7),
                        ),
                        height: 85.h,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.h,
                              right: 15.w, left: 15.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      customText1(
                                          saleListInfo[0].saleProducts.length.toString(),
                                          kBlack, 16.sp),
                                      gapWeight(3.w),
                                      customText1("Items", kBlack, 16.sp),

                                    ],
                                  ),
                                  customText1("Total", kBlack, 16.sp),
                                  gapHeight(1.h)
                                ],
                              ),
                              customTextnaira(
                                  NumberFormat.simpleCurrency(
                                      name: 'NGN').format(
                                      double.parse(
                                          totalAmount.toString())
                                  ).split(".")[0], kAppBlue,
                                  24.sp,
                                  fontWeight: FontWeight.w500),
                            ],
                          ),
                        )
                      )
                    ])),
                gapHeight(40.h),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: [
                      GestureDetector(
                        onTap: () async {
                            generateAndDownloadAsImage(customersName,paymentStatusId,widget.isOrder);

                         // Get.to(CustomerReceipt(saleListInfo: saleListInfo));
                         // Uint8List res=await   getCustomerReceipt();
                         // if(image!=null){
                         //    getPdf("${saleListInfo[0].customerName} receipt", image!);
                         //  }else{
                         //   Fluttertoast.showToast(msg: "Unable to generate receipt");
                         // }
                        },
                        child:  Column(
                          children: [
                            Container(
                                child:SvgPicture.asset(
                                    "assets/shareCopy.svg",
                                    fit: BoxFit.scaleDown),
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10.r),
                                    color:kLightPink.withOpacity(0.7)),
                                height:44.h,
                                width: 44.w),
                            gapHeight(10.h),
                            customText1("Share", kBlack, 14.sp,fontWeight: FontWeight.w300)
                          ],
                        ),
                      ),

                      GestureDetector(
                          onTap: (){
                            // printWidget(SmerpGoReceipt(saleListInfo: saleListInfo,
                            // isOrder: false,items: [],), PdfPageFormat.a4);
                            generatePdf(saleListInfo, [],
                              paymentStatus: (widget.isOrder)?orderInformation!.paymentStatus:
                              _controller.paymentStatus.value,);
                          },
                          child:  Column(
                            children: [
                              Container(
                                  child:SvgPicture.asset(
                                      "assets/printer.svg", fit: BoxFit.scaleDown),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(10.r),
                                      color:kLightPink.withOpacity(0.7)),
                                  height:44.h,
                                  width: 44.w),
                              gapHeight(10.h),
                              customText1("Print", kBlack, 14.sp,fontWeight: FontWeight.w300)
                            ],
                          )
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }




  void generatePdf( List<SaleListDataInfo> data,
      List<OrderItems>? orderData,{String? customerName, int? paymentStatus,
        bool isOrder= false,
      DateTime? orderPlacedAt,
      DateTime? orderCompletedAt,
      String? deliveryAddress}  ) async {
    FirebaseAnalytics.instance.logEvent(
      name: trackedPagesAndActions[6],
      parameters: <String, dynamic>{
        'string_parameter': 'Print receipt',
        'int_parameter': 6,
      },
    );
    const title = 'SmerpGo Receipt';
    await Printing.layoutPdf(
        format: PdfPageFormat.a4,
        name: '$customersName SmerpGo Receipt',
        onLayout: (format) => generate2Pdf(format, data:data,
    orderData: orderData,customerName: customerName,orderPlacedAt: orderPlacedAt,
    deliveryAddress: deliveryAddress, isOrder: isOrder,orderCompletedAt: orderCompletedAt,
     paymentStatus: paymentStatus));
  }


  String getTotalAmount(){
    double amount =0.0;
    for(var element in saleListInfo[0].saleProducts){
      amount = amount +(element.quantity*element.sellingPrice);
    }
    return amount.toString();
  }
  Future<void> delay() async {
    await Future.delayed(Duration(seconds: 4));
    generatePdf( (widget.isOrder)?[]:saleListInfo,
      (widget.isOrder)?orderInformation!.items:[],
      paymentStatus:(widget.isOrder)?orderInformation!.paymentStatus:
      _controller.paymentStatus.value,
      orderCompletedAt:(widget.isOrder)?orderInformation?.deliveryDate:
      saleListInfo[0].saleProducts[0].createdOn,
      isOrder: widget.isOrder,
      deliveryAddress: (widget.isOrder)?
      orderInformation!.buyer.address:"none available",
      orderPlacedAt: (widget.isOrder)?orderInformation!.orderDate:
      saleListInfo[0].saleProducts[0].timeStamp,
      customerName:(widget.isOrder)?orderInformation!.buyer.name
          :saleListInfo[0].customerName,);// Delay for 2 seconds
  }
  Future<void> generateAndDownloadAsImage(String customerName,int? paymentStatus,
      bool isOrder) async {
  List<OrderItems> items=(widget.isOrder)?orderInformation!.items:[];
       if(widget.isOrder){
  if(items.length.isGreaterThan(6)){
    callPrintPdf(this.context);
  }else{
    callScreenShotWidget(customerName, isOrder);
  }
} else {
         if (saleListInfo[0].saleProducts.length.isGreaterThan(6)) {
           callPrintPdf(this.context);
          // print("I am here");
         } else {
           callScreenShotWidget(customerName, isOrder);
         }
       }
    }

  void callPrintPdf(context) {
    final snackBar = SnackBar(
      content: Text('Image file cant allow more than 6 product item.'
          ' System generating pdf file to allow all items'),
    );
    Get.snackbar(
        "Alert",
      "Image file cant allow more than 6 product item. "
          "System generating pdf file to allow all items",
      snackPosition: SnackPosition.BOTTOM,
    );
    delay();
  }

  void callScreenShotWidget(String customerName, bool isOrder) {
       FirebaseAnalytics.instance.logEvent(
      name: trackedPagesAndActions[5],
      parameters: <String, dynamic>{
        'string_parameter': 'Share receipt',
        'int_parameter': 5,
      },
    );
    print(customerName);
    _screenshotController.captureFromWidget(

        InheritedTheme.captureAll(context,
          Material(child: SmerpGoReceipt(saleListInfo: (isOrder)?[]:
          saleListInfo,isOrder: isOrder,
            items: (isOrder)?orderInformation!.items:[],
            customerName: customersName,
            paymentStatus: (isOrder)?orderInformation!.paymentStatus:
            _controller.paymentStatus.value,
            orderCompletedAt:(widget.isOrder)?orderInformation?.deliveryDate:
            saleListInfo[0].saleProducts[0].createdOn,
            deliveryAddress: (widget.isOrder)?
            orderInformation!.buyer.address:"none available",
            orderPlacedAt: (widget.isOrder)?orderInformation!.orderDate:
            saleListInfo[0].saleProducts[0].timeStamp,
          )),
        )
    ).then((value)async{
      print(value.runtimeType);
      if (value != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(value);
        /// Share Plugin
        await Share.shareFiles([imagePath.path]);
      }
    });
    checkAndRequestPermission();
  }


  Future<bool> checkAndRequestPermission() async {
    if (!await Permission.storage.isGranted) {
      PermissionStatus status = await Permission.storage.request();
      return status.isGranted;
    }
    return true;
  }

  void getOrderDetails()async {
    isLoading.value = true;
    isLoading.value = true;

    await _controllerOrders
        .getOrderDetails(widget.orderId!.toString(), isLoading)
        .then((orderInformation) {
      setState(() {
        this.orderInformation = orderInformation;
        date = AppUtils.convertDate(orderInformation!.orderDate!);
        date = formatDate(
            orderInformation!.orderDate!, [dd, '/', mm, '/', yy]);
        paymentStatusId = orderInformation!.paymentStatus;
        customersName= orderInformation.buyer.name;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isLoading.value = false;
        // paymentStatusId = 0;
      });

      setState(() {
        customersName =orderInformation!.buyer.name;
      });
      print("user name is $customersName");
     totalAmount = 0;
      for (var element in orderInformation!.items) {
        setState(() {
          totalAmount =
              totalAmount + (element.sellingPrice * element.quantity);
        });
      }
    });}










}
