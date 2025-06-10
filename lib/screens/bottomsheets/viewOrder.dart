import 'dart:io';
import 'dart:typed_data';

import 'package:date_format/date_format.dart';
// import 'package:download/download.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:smerp_go/utils/newReceipt.dart';

import '../../controller/addSaleController.dart';
import '../../controller/dashboardController.dart';
import '../../controller/orderController.dart';
import '../../model/response/order/orderDetails.dart';
import '../../model/response/sales/saleListInfo.dart';
import '../../utils/AppUtils.dart';
import '../../utils/UserUtils.dart';
import '../../utils/appColors.dart';
import '../../utils/appDesignUtil.dart';
import '../../utils/downloadAsImage.dart';
import '../bottomNav/screens/inventory/addNewProduct.dart';
import '../bottomNav/screens/inventory/allIProductd.dart';
import 'customerReceipt.dart';
import 'downloadFormat.dart';

class ViewOrder extends StatefulWidget {
  String orderId;
  bool isReceipt;

   ViewOrder({super.key,
    required this.orderId,
    required this.isReceipt
   });

  @override
  State<ViewOrder> createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {


  var _controllerOrders= Get.put(OrderController());
  OrderInformation? orderInformation;
  var paymentStatus = "";
  var customersName = "";
  var date = "";
  int paymentStatusId = 0;
  double totalAmount = 0.0;
  RxBool isLoading = false.obs;
  ScreenshotController _screenshotController = ScreenshotController();
  //RxBool isLoading = false.obs;
  // XFile file = XFile();
  late Uint8List image;
  final doc = pw.Document();
  @override
  void initState() {

    getDetails();
    getReceipt();

    super.initState();
    // getReceipt();
  }
  void getDetails() async {
    isLoading.value = true;
    isLoading.value = true;

    await _controllerOrders
        .getOrderDetails(widget.orderId!, isLoading)
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
            totalAmount = totalAmount + (element.sellingPrice * element.quantity);
          });
        }
      getReceipt();
    });
  }
  void getReceipt()async{
    //isLoading.value= true;
    image = await getCustomerReceipt();
    print("i cal");
    setState(() {
      image = image;
      isLoading.value = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // height: 505.h,
        child: SingleChildScrollView(
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
                          customText1("loading order information, please wait..",
                              kBlack, 14.sp,fontWeight: FontWeight.w400,fontFamily: fontFamily)
                        ],
                      ),
                    ),
                  ),
                ),
              )
                  :
              (orderInformation!.items.length==1) ?
              Column(
                children: [
                  // gapHeight(30.h),
                  Container(
                      width: double.infinity,
                      height: 350.h,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height:73.h ,
                              color: kViewOrderColor,
                              padding: EdgeInsets.only(left: 16.w, right: 16.h),
                              //color: kBlack,
                              child:  Align(
                                alignment: Alignment.centerLeft,
                                child: customText1(
                                    (widget.isReceipt==true)?"Order Invoice" : "View order" , kBlack,
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.w500,
                                    18.sp),
                              ),
                            ),
                            gapHeight(20.h),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 16.w, right: 16.h),
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
                                              "Order" , kBlack,
                                          18.sp,fontFamily: fontFamily),
                                    ),
                                    customText1(
                                        date, kBlack, 14.sp,
                                    fontFamily: fontFamily),
                                  ],
                                ),
                              ),
                            ),
                            // (_controller.product == null) ? Container(
                            //   height: 90.h,
                            //   width: double.infinity,
                            // ) :
                            Container(
                              height: 100.h,
                              padding: EdgeInsets.only(left: 16.w, right: 16.h),
                              width: double.infinity,
                              child: viewOrderListDesign(
                                 orderInformation!.items[0],
                                  paymentStatus: orderInformation!.paymentStatus,
                              ),
                            ),
                            gapHeight(10.h),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 16.w, right: 16.h),
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
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          customText1( orderInformation!.items
                                              .length.toString(), kBlack, 14.sp),
                                          customTextnaira(
                                              NumberFormat.simpleCurrency(
                                                  name: 'NGN')
                                                  .format(double.parse(orderInformation!.orderTotalAmount
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
                  Padding(
                    padding: EdgeInsets.only(left: 16.w, right: 16.h),
                    child:
                    (widget.isReceipt==true)?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            isLoading.value=true;
                            Future.delayed(Duration(seconds: 3)).whenComplete(() async {
                              isLoading.value=false;
                              print("I am sharing");
                              //     Uint8List res=await   getCustomerReceipt();
                              if(image != null){
                               //getPdf("${customersName} receipt", image!);
                                generateAndDownloadAsImage(image!,customersName,paymentStatusId,
                                );
                              }
                            });



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
                        //
                        //     if(image!=null){
                        //      generateAndDownloadAsImage(image!,customersName,paymentStatusId);
                        //      // _download();
                        //     }
                        //   },
                        //   child: Column(
                        //     children: [
                        //       Container(
                        //           child:SvgPicture.asset(
                        //               "assets/import.svg", fit: BoxFit.scaleDown),
                        //           decoration: BoxDecoration(
                        //               shape: BoxShape.rectangle,
                        //               borderRadius: BorderRadius.circular(10.r),
                        //               color:kLightPink.withOpacity(0.7)),
                        //           height:44.h,
                        //           width: 44.w),
                        //       gapHeight(10.h),
                        //       customText1("Download", kBlack, 14.sp,fontWeight: FontWeight.w300)
                        //     ],
                        //   ),
                        // ),
                        GestureDetector(
                            onTap: (){
                             isLoading.value=true;
                              Future.delayed(Duration(seconds: 3)).whenComplete(() async {
                              isLoading.value=false;
                               printWidget(SmerpGoReceipt(saleListInfo: [],
                               items: orderInformation!.items,
                               isOrder: true,), PdfPageFormat.a4);
                              });

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
                    )
                        :
                    (orderInformation!.acceptance==1)?
                    GestureDetector(
                      onTap: ()async {
                        Get.back(result: [false,"OrderCancel"]);
                      },
                      child: Container(
                        height: 60.h,
                        decoration: BoxDecoration(
                            color: kAppBlue,
                            borderRadius: BorderRadius.circular(
                                15.r),
                            border: Border.all(
                                color: kDashboardColorBorder,
                                width: 0.5.w
                            )
                        ),
                        child: Center(
                          child: customText1(
                              "Cancel Order", kWhite,
                              18.sp,
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    )
                        : (orderInformation!.acceptance==2)?
                    Center(
                      child: customText1("You rejected this order", kAppBlue, 16.sp),
                    ):
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      children: [

                        GestureDetector(
                          onTap: ()async {
                            Get.back(result:[ false,"Order"]);

                          },
                          child: Container(
                            height: 60.h,
                            width: 189.w,
                            decoration: BoxDecoration(
                                color: kDashboardColorBorder,
                                borderRadius: BorderRadius.circular(
                                    15.r),
                                border: Border.all(
                                    color: kDashboardColorBorder,
                                    width: 0.5.w
                                )
                            ),
                            child: Center(
                              child: customText1(
                                  "Reject order", kBlack,
                                  18.sp,
                                  fontFamily: fontFamily,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: ()async {
                            (orderInformation?.acceptance !=1)?
                            Get.back(result:[ true,"Order"]): null;

                          },
                          child: Visibility(
                            visible: orderInformation?.acceptance !=1,
                            child: Container(
                              height: 60.h,
                              width: 189.w,
                              decoration: BoxDecoration(
                                color: kAppBlue,
                                borderRadius: BorderRadius.circular(
                                    15.r),
                              ),
                              child: Center(
                                child: customText1("Accept order",
                                    kWhite, 18.sp,
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                ],
              )
                  :
              Column(
                children: [
                  // gapHeight(30.h),

                  Container(
                      width: double.infinity,
                      height:_controllerOrders.getReceiptHeight(orderInformation!.items.length),
                     child: Column(
                         children: [

                           Container(
                             height:73.h ,
                             padding: EdgeInsets.only(left: 16.w, right: 16.h),
                             color: kViewOrderColor,
                             child:  Align(
                               alignment: Alignment.centerLeft,
                               child: customText1(
                                   (widget.isReceipt==true)?"Order Invoice" : "View order" , kBlack,
                                   fontFamily: fontFamily,
                                   fontWeight: FontWeight.w500,
                                   18.sp),
                             ),
                           ),
                        gapHeight(20.h),
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
                                          "order" , kBlack, 18.sp,
                                      fontFamily: fontFamily),
                                ),
                                customText1(
                                    date, kBlack, 14.sp,
                                fontFamily: fontFamily)
                              ],
                            ),
                          ),
                        ),

                        gapHeight(20.h),
                        Container(
                          height: _controllerOrders.getReceiptHeight(orderInformation!.items.length)-270.h,
                          width: double.infinity,
                          child: ListView.builder(
                              itemCount: orderInformation!.items.length,
                              itemBuilder: (context,index){
                                return viewOrderListDesign(
                                   orderInformation!.items[index],
                                    paymentStatus: orderInformation!.paymentStatus,);
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
                                      customText1("Items", kBlack, 16.sp),
                                      customText1("Total", kBlack, 16.sp),
                                      gapHeight(1.h)
                                    ],
                                    //this is teas

                                 ),
                                  Padding(
                                    padding:  EdgeInsets.only(top: 5.h,bottom: 5.h),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        customText1(orderInformation!.items.length.toString(), kBlack, 14.sp),
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
                                  ),
                                ],
                              ),
                            )
                        )
                      ]),),
                  gapHeight(20.h),
                  Padding(
                    padding: EdgeInsets.only(left: 16.w, right: 16.h),
                    child:
                    (widget.isReceipt==true)?
                     Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          isLoading.value=true;
                          Future.delayed(Duration(seconds: 3)).whenComplete(() async {
                            isLoading.value=false;
                            print("I am sharing");
                            //     Uint8List res=await   getCustomerReceipt();
                            if(image != null){
                              //getPdf("${customersName} receipt", image!);
                              generateAndDownloadAsImage(image!,customersName,paymentStatusId,
                              );
                            }
                          });


                          // isLoading.value=true;
                          // Future.delayed(Duration(seconds: 3)).whenComplete(() async {
                          //   isLoading.value=false;
                          //   print("I am sharing");
                          //   //     Uint8List res=await   getCustomerReceipt();
                          //   if(image != null){
                          //     getPdf("${customersName} receipt", image!);
                          //   }
                          // });
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
                      //
                      //     if(image!=null){
                      //       generateAndDownloadAsImage(image!,customersName,paymentStatusId);
                      //     }
                      //   },
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //           child:SvgPicture.asset(
                      //               "assets/import.svg", fit: BoxFit.scaleDown),
                      //           decoration: BoxDecoration(
                      //               shape: BoxShape.rectangle,
                      //               borderRadius: BorderRadius.circular(10.r),
                      //               color:kLightPink.withOpacity(0.7)),
                      //           height:44.h,
                      //           width: 44.w),
                      //       gapHeight(10.h),
                      //       customText1("Download", kBlack, 14.sp,fontWeight: FontWeight.w300)
                      //     ],
                      //   ),
                      // ),
                      GestureDetector(
                          onTap: (){
                            isLoading.value=true;
                            Future.delayed(Duration(seconds: 3)).whenComplete(() async {
                              isLoading.value=false;
                              printWidget(SmerpGoReceipt(saleListInfo: [],
                                items: orderInformation!.items,
                                isOrder: true,), PdfPageFormat.a4);
                            });

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
                  ):
                    (orderInformation!.acceptance==1)?
                    GestureDetector(
                      onTap: ()async {
                       Get.back(result: [false,"OrderCancel"]);
                      },
                      child: Container(
                        height: 60.h,
                        decoration: BoxDecoration(
                            color: kAppBlue,
                            borderRadius: BorderRadius.circular(
                                15.r),
                            border: Border.all(
                                color: kAppBlue,
                                width: 0.5.w
                            )
                        ),
                        child: Center(
                          child: customText1(
                              "Cancel Order", kWhite,
                              18.sp,
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    )
                        : (orderInformation!.acceptance==2)?
                    Center(
                      child: customText1("You rejected this order", kRed50, 16.sp),
                    ):
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: ()async {
                            Get.back(result: [false,"Order"]);
                          },
                          child: Container(
                            height: 60.h,
                            width: 189.w,
                            decoration: BoxDecoration(
                                color: kDashboardColorBorder,
                                borderRadius: BorderRadius.circular(
                                    15.r),
                                border: Border.all(
                                    color: kDashboardColorBorder,
                                    width: 0.5.w
                                )
                            ),
                            child: Center(
                              child: customText1(
                                  "Reject order", kBlack,
                                  18.sp,
                                  fontFamily: fontFamily,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: ()async {
                            (orderInformation?.acceptance !=1)?
                            Get.back(result: [true,"Order"]): null;
                          },
                          child: Visibility(
                            visible: orderInformation?.acceptance !=1,
                            child: Container(
                              height: 60.h,
                              width: 189.w,
                              decoration: BoxDecoration(
                                color: kAppBlue,
                                borderRadius: BorderRadius.circular(
                                    15.r),
                              ),
                              child: Center(
                                child: customText1("Accept order",
                                    kWhite, 18.sp,
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Uint8List getCustomerReceipt(){

    bool isShow= true;
//Get.to(SmerpGoReceipt(saleListInfo: saleListInfo, isOrder: false));
    Visibility(
        visible: true,
        child: CircularProgressIndicator());
    _screenshotController
        .captureFromWidget(
        MediaQuery(
          data: MediaQueryData(),
          child: SmerpGoReceipt(saleListInfo:[], isOrder: true,
          customerName: orderInformation?.buyer.name,
          deliveryAddress: orderInformation?.buyer.address,
          orderPlacedAt: orderInformation?.acceptanceDateTime,
          orderCompletedAt: orderInformation?.deliveryDate,
          paymentStatus: orderInformation?.paymentStatus,
         items: orderInformation?.items,),
        ),
        delay: Duration.zero
    ).then((capturedImage) {
      setState(() {
        image=capturedImage;
        //  img=image;
      });
      return capturedImage;
    });
    return image;
  }


  Future<void> generateAndDownloadAsImage( Uint8List image,String customerName,int? paymentStatus,
  {DateTime? orderPlacedAt, DateTime? orderCompletedAt,String? deliveryAddress}) async {
   setState(() {
     isLoading.value= true;
   });
    _screenshotController.captureFromWidget(

        InheritedTheme.captureAll(context,
          Material(child:SmerpGoReceipt(saleListInfo:[], isOrder: true,
            customerName: orderInformation?.buyer.name,
            deliveryAddress: orderInformation?.buyer.address,
            orderPlacedAt: orderInformation?.acceptanceDateTime,
            orderCompletedAt: orderInformation?.deliveryDate,
            paymentStatus: orderInformation?.paymentStatus,
            items: orderInformation?.items,),),
        )
    ).then((value)async{
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(image);
        /// Share Plugin
        setState(() {
          isLoading.value= false;
        });
        await Share.shareXFiles([imagePath as XFile]);
      }
    });
    checkAndRequestPermission();
  }
  void printWidget(Widget widget, PdfPageFormat format) async {
     getCustomerReceipt();
    getPdf("Sale Receipt", image!);
    final pdf = await rootBundle.load("Sale Receipt");
    await Printing.layoutPdf(onLayout: (_) => pdf.buffer.asUint8List());
  }

  String getTotalAmount(){
    double amount =0.0;
    for(var element in orderInformation!.items){
      amount = amount +(element.quantity*element.sellingPrice);
    }
    return amount.toString();
  }
}