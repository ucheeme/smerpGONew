import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:smerp_go/model/response/order/orderHistory.dart';
import 'package:smerp_go/utils/appColors.dart';
import 'package:smerp_go/utils/appDesignUtil.dart';

import '../../../../controller/orderController.dart';
import '../../../../model/response/order/orderFilterOption.dart';
import '../../../../utils/orderStatusBottomsheet.dart';
import '../../../bottomsheets/receipt.dart';
import '../../../bottomsheets/viewOrder.dart';


class OrderHistory extends StatefulWidget {
 final List<HistoryOrder> orderHistoryLists;
 final String? message;
  const OrderHistory({required this.orderHistoryLists, this.message, super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  var _controllerOrders = Get.put(OrderController());
  List<HistoryOrder> searchResults=[];

  void filterByDate(RxList<DateTime?> dateRange) {
    print(dateRange[0]);
    print(dateRange[1]);
    if (dateRange.value.isEmpty || dateRange.value == null) {
     searchResults= widget.orderHistoryLists;
    } else {
      DateFormat format = DateFormat('yyyy-MM-dd');
      DateTime startDateObj = format.parse(dateRange[0]!.toIso8601String());
      DateTime endDateObj = format.parse(dateRange[1]!.toIso8601String());
      searchResults = widget.orderHistoryLists
          .where((date) =>
      startDateObj.isBefore(date.createdOn) ||
          startDateObj.isAtSameMomentAs(date.createdOn))
          .where((date) =>
      endDateObj.isAfter(date.createdOn) ||
          endDateObj.isAtSameMomentAs(date.createdOn))
         .toList();
    }
    if(searchResults.isEmpty){
      Get.snackbar("Filter Result", "Not Found", backgroundColor: kRed70,colorText: kWhite);
    }
  }

  void filterByOrderStatus(String status){
    searchResults = widget.orderHistoryLists
        .where((element) =>
    element.isAcceptance.toLowerCase() ==
        (status.toLowerCase()))
        .toList();

    if(searchResults.isEmpty){
      Get.snackbar("Filter Result", "Not Found", backgroundColor: kRed70,colorText: kWhite);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: Container(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Spacer(),
                    Center(child: customText1("Order History", kBlack, 17.sp,
                    fontFamily: fontFamily),),
                    Spacer(),
                    PopupMenuButton(
                      icon: Icon(Icons.more_vert_sharp,
                      size: 20) ,
                        itemBuilder: (context)=>[
                          PopupMenuItem(
                            value: 1,
                            height: 40.h,
                            child: customText1('Filter By Date',kBlack, 14.sp),
                          ),
                          PopupMenuItem(
                            value: 2,
                            height: 40.h,
                            child: customText1('Filter By Order Status',kBlack, 14.sp),
                          ),
                        ],
                      onSelected: (value){
                        if(value==1){
                              showCupertinoModalBottomSheet(
                                  animationCurve: Curves.bounceIn,
                                  backgroundColor: kWhite,
                                  topRadius: Radius.zero,
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height: 380.h,
                                      color: kWhite,
                                      child: DateFilter(),
                                    );
                                  }).whenComplete((){
                                    filterByDate(_controllerOrders.selectedDateRange);
                                    setState(() {
                                      searchResults = searchResults;
                                   });
                              });
                        }else if(value ==2){
                          showCupertinoModalBottomSheet(
                              animationCurve: Curves.bounceIn,
                              backgroundColor: kWhite,
                              topRadius: Radius.zero,
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: 230.h,
                                 color: kWhite,
                                  child: OrderStatus(),
                                );
                              }).whenComplete((){
                                filterByOrderStatus(_controllerOrders.
                                selectedOrderStatusFilterChoice.value);
                                setState(() {
                                  searchResults= searchResults;
                                });
                          });
                        }
                      },
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                height: _controllerOrders.getBottomSheetHeights(widget.orderHistoryLists.length),
                child:    (widget.orderHistoryLists.isEmpty)?
                    Center(
                      child: customText1(widget.message!, kRed70, 14.sp) ,
                    ):
                ListView.builder(
                    itemCount: (searchResults.isEmpty)?
                    widget.orderHistoryLists.length: searchResults.length,
                    itemBuilder: (context, index){
                      HistoryOrder currentIndex =(searchResults.isEmpty)?
                      widget.orderHistoryLists[index]: searchResults[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          if(currentIndex.isAcceptance=="Accepted") {
                            orderHistoryReceipt(context, index);
                          }
                        },
                        child: orderHistoryMockData(
                            (searchResults.isEmpty)?
                           widget.orderHistoryLists[index]: searchResults[index], context),
                      ),
                      Gap(10)
                    ],
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  void orderHistoryReceipt(BuildContext context, int index) {


    showCupertinoModalBottomSheet(
        topRadius:
        Radius.circular(0.r),
        backgroundColor: kWhite,
        context: context,
        builder: (context) {
          return
            Container(
              height: _controllerOrders
                  .getVeiwOrderHeight(
                  (searchResults.isEmpty)?
                  widget.orderHistoryLists[index].itemCount: searchResults[index].itemCount),
              color: kWhite,
              child: ReceiptInApp(
                orderId:(searchResults.isEmpty)?
                widget.orderHistoryLists[index].id:
                searchResults[index].id,
              saleId  :   (searchResults.isEmpty)?
                   widget.orderHistoryLists[index].id:
                        searchResults[index].id,
               date:  (searchResults.isEmpty)?
               widget.orderHistoryLists[index].createdOn:
               searchResults[index].createdOn,
                customerName:  (searchResults.isEmpty)?
                widget.orderHistoryLists[index].customerName:
                searchResults[index].customerName, isOrder: true,
                paymentStatus: widget.orderHistoryLists[index].paymentStatus,
              ),
            );
        });
  }



  Widget orderHistoryMockData(HistoryOrder? mockData, BuildContext context,) {
    var date = formatDate((mockData!.createdOn).toLocal(),[dd, '/', MM, '/', yy,],);
    return Container(
      height: 93.h,
      width: 398.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: kSalesListColor.withOpacity(0.8)
        //color: kGreen70
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 14.w),
        child: Row(
         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // gapHeight(18.h),
            Container(
              width: 200.w,
              height: 80.h,
             // color: kAppBlue,
              // padding: EdgeInsets.only(top: 10.h,bottom: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customText1(
                  mockData!.customerName, kBlackB800, 16.sp,
                      fontWeight: FontWeight.w400),
                 // gapHeight(20.h),
                  Spacer(),
                  customTextnaira(NumberFormat.simpleCurrency(name: 'NGN')
                          .format(double.parse( mockData.salesAmount.toString()))
                          .split(".")[0], kAppBlue, 18.sp, fontWeight: FontWeight.w500,
                      fotFamily: fontFamily),
                ],
              ),
            ),
            // gapHeight(15.h),
            Spacer(),
            Container(
              width: 170.w,
              height: 84.h,
              // padding: EdgeInsets.only(top: 10.h,bottom: 10.h),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  Container(
                    width: 140.w,

                    child: customText1(date, kBlackB700, 16.sp,
                    indent: TextAlign.right)
                  ),
                 Spacer(),
                  Container(
                    width: 212.w,
                    child: SingleChildScrollView(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          paymentStatusDesign(mockData.isAcceptance!),
                          gapWeight(3.w),
                          Icon(Icons.circle, color: kBlack.withOpacity(0.5), size: 6),
                          gapWeight(3.w),
                          Container(
                            child: Row(
                              children: [
                                customText1( mockData.itemCount.toString(),
                                    kBlackB600, 11.sp,
                                    fontWeight: FontWeight.w300),
                            //  Spacer(),
                                customText1("Product", kBlackB600, 11.sp,
                                    fontWeight: FontWeight.w300),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // gapWeight(110.57.w),
                ],
              ),
            ),
            // gapHeight(21.h)
          ],
        ),
      ),
    );
  }

}


