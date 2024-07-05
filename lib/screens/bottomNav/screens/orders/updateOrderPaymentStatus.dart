import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smerp_go/model/response/order/orderDetails.dart';
import 'package:smerp_go/screens/bottomsheets/paymentStatus.dart'
    as statusPayment;
import 'package:smerp_go/utils/appDesignUtil.dart';

import '../../../../controller/addSaleController.dart';
import '../../../../controller/orderController.dart';
import '../../../../model/response/inventoryList.dart';
import '../../../../model/response/sales/saleListInfo.dart';
import '../../../../utils/AppUtils.dart';
import '../../../../utils/appColors.dart';
import '../../../bottomsheets/productsList.dart';

class UpdatePaymentStatus extends StatefulWidget {
  String? information;

  UpdatePaymentStatus({super.key, required this.information});

  @override
  State<UpdatePaymentStatus> createState() => _UpdatePaymentStatusState();
}

class _UpdatePaymentStatusState extends State<UpdatePaymentStatus> {
  var controller = Get.put(OrderController());
  var customerName = "Prosper Ehinze";
  var phoneNumber = "08166896835";
  var email = "smailblacktiger@tiger.com";
  var deliveryAddress =
      "Road 4, House 22 Olori street, Lekki county homes Ikota, Lagos";
  var _controller = Get.put(AddNewSaleController());
  var _controllerDashboard = Get.put(AddNewSaleController());
  var _controllerOrders = Get.put(OrderController());
  var paymentStatus = "";
  var date = "";
  int paymentStatusId = 0;
  double totalAmount = 0.0;
  RxBool isLoading = false.obs;
   OrderInformation orderInformation = OrderInformation(orderId: "0",
       paymentMode: 1, paymentStatus:1 , orderDate: DateTime.now(),
       deliveryDate: DateTime.now(), expectedDelivery: DateTime.now(),
       acceptance: 1, acceptanceDateTime: DateTime.now(),
       deliveryStatus: "", buyer: Buyer(name: "Unknown",
           phoneNumber: "0903324", emailAddress: "", address: ""), items: [],
       orderTotalAmount: 0.0);

  @override
  void initState() {
    getDetails();
    super.initState();
    //  getDetails();
  }

  void getDetails() async {
    isLoading.value = true;

    await _controllerOrders
        .getOrderDetails(widget.information!, isLoading)
        .then((orderInformation) {
      setState(() {
       this.orderInformation = orderInformation!;
        date = AppUtils.convertDate(orderInformation!.orderDate!);
        customerName = orderInformation!.buyer.name;
        phoneNumber = orderInformation!.buyer.phoneNumber;
        email = orderInformation!.buyer.emailAddress;
        deliveryAddress = orderInformation!.buyer.address;
        paymentStatusId = orderInformation!.paymentStatus;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isLoading.value = false;
        _controller.isLoading.value = false;
        paymentStatusId = orderInformation!.paymentStatus;
        paymentStatus = orderPaymentStatusIntToString(orderInformation!.paymentStatus);
      });
      totalAmount = 0;
      for (var element in orderInformation!.items) {
        setState(() {
          totalAmount = totalAmount + (element.sellingPrice * element.quantity);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.product = null;
    totalAmount = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return overLay(
        Scaffold(
          backgroundColor: kWhite,
          appBar: PreferredSize(
              child: defaultDashboardAppBarWidget(() {
                Get.back();
              }, "Update payment status", context: context),
              preferredSize: Size.fromHeight(80.h)),
          body: Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  (isLoading.value)
                      ? Center(
                    child: Container(

                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: kAppBlue,
                        ),
                      ),
                    ),
                  )
                      :
                  gapHeight(20.h),
                  Container(
                    // height: 200.h,
                    width: 398.w,
                    decoration: BoxDecoration(
                      // color: kViewOrderColor,
                      color: kLightPink.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: Column(
                        children: [
                          gapHeight(15.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText1("Customer name", kBlackB700, 14.sp),
                              customText1("$customerName", kBlack, 16.sp,
                                  fontFamily: fontFamily,
                                  fontWeight: FontWeight.w400),
                            ],
                          ),
                          gapHeight(20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText1("Phone number", kBlackB700, 14.sp),
                              customText1("$phoneNumber", kBlack, 16.sp,
                                  fontFamily: fontFamily,
                                  fontWeight: FontWeight.w400),
                            ],
                          ),
                          gapHeight(20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText1("E-mail address", kBlackB700, 14.sp),
                              customText1("$email", kBlack, 16.sp,
                                  fontFamily: fontFamily,
                                  fontWeight: FontWeight.w400),
                            ],
                          ),
                          gapHeight(20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText1(
                                  "Delivery address", kBlackB700, 14.sp),
                              Container(
                                width: 200.w,
                                child: customText1(
                                    "$deliveryAddress", kBlack, 16.sp,
                                    maxLines: 3,
                                    indent: TextAlign.right,
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          gapHeight(15.h)
                        ],
                      ),
                    ),
                  ),
                  gapHeight(30.h),
                  Column(
                    children: [

                      Container(
                              height:(orderInformation==null)?500.h:
                                  getEditHeight(orderInformation!.items.length)+200.h,
                              child: SingleChildScrollView(
                               // physics: NeverScrollableScrollPhysics(),
                                child: Column(
                                  children: [
                                    Container(
                                        width: double.infinity,
                                        height: getItemListContainerHeight(
                                            orderInformation!.items.length
                                            ) +
                                            80.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.r),
                                            border: Border.all(
                                                color: kHashBlack30,
                                                width: 0.5.w)),
                                        child: Column(children: [
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(15.r),
                                                topLeft: Radius.circular(15.r),
                                              ),
                                              color:
                                                  kLightPink.withOpacity(0.5),
                                            ),
                                            height: 53.h,
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 10.h,
                                                    right: 10.w,
                                                    left: 10.w),
                                                child: customText1(
                                                    (customerName.length > 15)
                                                        ? "${customerName.replaceRange(10, customerName.length, "...")} order"
                                                        : "${customerName} order",
                                                    kBlack,
                                                    18.sp,
                                                    fontFamily: fontFamily)),
                                          ),
                                          gapHeight(15.h),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 12.w, right: 12.w),
                                            height: getItemListContainerHeight(
                                                  orderInformation!
                                                      .items.length,
                                                ) -
                                                60.h,
                                            width: double.infinity,
                                            child: ListView.builder(
                                                itemCount: orderInformation!
                                                    .items.length,
                                                itemBuilder: (context, index) {
                                                  return saleDetailSeveralItemDesignOrder(
                                                      orderInformation!
                                                          .items[index],
                                                      index: index);
                                                }),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(15.r),
                                                bottomLeft:
                                                    Radius.circular(15.r),
                                              ),
                                              color:
                                                  kLightPink.withOpacity(0.5),
                                            ),
                                            height: 70.h,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10.h,
                                                  right: 15.w,
                                                  left: 15.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          customText1(
                                              orderInformation.items.length
                                                                  .toString(),
                                                              kBlack,
                                                              16.sp),
                                                          gapWeight(3.w),
                                                          customText1("Items",
                                                              kBlack, 16.sp),
                                                        ],
                                                      ),
                                                      customText1("Total",
                                                          kBlack, 16.sp),
                                                      gapHeight(1.h)
                                                    ],
                                                  ),
                                                  customTextnaira(
                                                      NumberFormat
                                                              .simpleCurrency(
                                                                  name: 'NGN')
                                                          .format(double.parse(
                                                              totalAmount
                                                                  .toString()))
                                                          .split(".")[0],
                                                      kAppBlue,
                                                      24.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ],
                                              ),
                                            ),
                                          )
                                        ])),
                                    gapHeight(30.h),

                                   GestureDetector(
                                      onTap: (_controller.isDone.value)
                                          ? null
                                          : () async {
                                              var response =
                                                  await Get.bottomSheet(
                                                      statusPayment
                                                          .OrderPaymentStatus());
                                              if (response != null) {
                                                setState(() {
                                                  paymentStatus = response[0];
                                                  _controllerOrders.paymentStatus
                                                      .value = response[1];
                                                  paymentStatusId = orderPaymentStatusStringToInt(paymentStatus);
                                                });
                                              }

                                            },
                                      child: Container(
                                        child: textFieldBorderWidget2(
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                orderPaymentStatusDesignId(
                                                   paymentStatusId),
                                                const Icon(
                                                    Icons.keyboard_arrow_down)
                                              ],
                                            ),
                                            "Select payment status"),
                                      ),
                                    ),
                                    // gapHeight(30.h),
                                    // Container(
                                    //   height: 50.h,
                                    //   width: double.infinity,
                                    //  child: titleSignUp(_controllerOrders.customerNameController,
                                    //       textInput: TextInputType.text,
                                    //       hintText: "Enter customer code"),
                                    // ),
                                    gapHeight(73.h),
                                    GestureDetector(
                                      onTap: () async {
                                      var res =  await _controllerOrders.orderPayment(
                                            widget.information!,
                                            _controllerOrders.customerNameController.text);
                                      if(res){

                                        Navigator.pop(context);
                                      }

                                      //    Navigator.pop(con
                                      },
                                      child: dynamicContainer(
                                          Center(
                                              child: customText1(
                                                  //     (_controller.isDone.value) ?
                                                  // "Create sale" : "Done",
                                                  "Change payment status",
                                                  kWhite,
                                                  18.sp)),
                                          kAppBlue,
                                          60.h,
                                          width: double.infinity),
                                    ),
                                  ],
                                ),
                              ),
                            )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        isLoading: _controllerOrders.isLoading.value,
      );
    });
  }

  double getEditHeight(int num) {
    switch (num) {
      case 1:
        return 430.h;
      case 2:
        return 430.h;
      case 3:
        return 512.h;
      case 4:
        return 650.h;
      case 5:
        return 670.h;
      default:
        return 800.h;
    }
  }



  Future<void> executeEditSale(BuildContext context) async {
    // setState(() {
    //   isLoading.value = true;
    // });
    Get.snackbar("Updating sale item", "Please wait..",
        snackStyle: SnackStyle.FLOATING,
        showProgressIndicator: true,
        borderRadius: 8.r,
        overlayBlur: 2,
        overlayColor: kDashboardColorBorder.withOpacity(.4),
        isDismissible: false,
        backgroundColor: kWhite,
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.TOP);
    _controller.qty = int.parse(_controller.quantityController.text);

var res = true;
    if (res) {
      setState(() {
        isLoading.value = false;
      });
      ////Get.back(result: res);
      Navigator.pop(context);
    } else {
      setState(() {
        isLoading.value = false;
      });
    }
  }

}
