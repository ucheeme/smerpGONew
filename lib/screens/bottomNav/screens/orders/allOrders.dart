import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smerp_go/controller/orderController.dart';
import 'package:smerp_go/cubit/orderHistoryCubit/order_history_cubit.dart';
import 'package:smerp_go/screens/bottomNav/screens/orders/updateOrderPaymentStatus.dart';
import 'package:smerp_go/utils/appDesignUtil.dart';
import 'package:smerp_go/model/response/order/orderHistory.dart' as orders;
import '../../../../model/response/order/allOrders.dart';
import '../../../../model/response/order/orderFilterOption.dart';
import '../../../../model/response/order/orderHistory.dart';
import '../../../../utils/AppUtils.dart';
import '../../../../utils/appColors.dart';
import '../../../../utils/mockdata/tempData.dart';
import '../../../../utils/slideUpRoute.dart';
import '../../../bottomsheets/notification.dart';
import '../../../bottomsheets/viewOrder.dart';
import 'orderHistory.dart';

class AllOrders extends StatefulWidget {
  bool isEmpty;
   AllOrders({super.key,required this.isEmpty});
  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  late OrderHistoryCubit cubit;
  var _controllerOrders = Get.put(OrderController());
  List<Orders> orderList = [];
  List<Orders> orderListWithoutRejected = [];
  List<HistoryOrder> orderHistoryList = [];
  var loading = false;
  RxBool orderListWithoutRejectedIsEmpty = RxBool(false);

  RefreshController refreshController2 =
  RefreshController(initialRefresh: false);
  bool orderHistoryFetched = false;

  void getAllOrderCall() async {
    if (isOrderListHasRun.value == false) {
      loading = true;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //print("Icame herre");
      _controllerOrders.userOrders().then((value) {
        setState(() {
          orderList = value;
          loading = false;
          orderListWithoutRejected = orderList.where((element) =>
          element.isAccepted != "Rejected").toList();
        });
      });

      if (orderListWithoutRejected.isEmpty){
        print("noseyest");
        setState(() {
        //  orderListWithoutRejectedIsEmpty.value = true;
        });

      }
      setState(() {
        if (orderList.isNotEmpty) {
          loading = false;
        }
      });
    });
    isOrderListHasRun.value = true;
  }

  @override
  void initState() {
    if(widget.isEmpty){
      orderListWithoutRejectedIsEmpty.value = true;
    }else{
      orderListWithoutRejectedIsEmpty.value = false;
    }
    if (!isOrderListHasRun.value) {
      getAllOrderCall();
    } else {
      print("I  came herre");
      setState(() {
        orderList = orderListTemp;
        orderListWithoutRejected = orderList.where((element) =>
        element.isAccepted != "Rejected").toList();
      });

      //   orderList = orderListTemp;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    cubit = context.read<OrderHistoryCubit>();
    return Obx(
          () =>
          overLay(
            BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
                builder: (context, state) {
                  if (state is OrderHistoryErrorState) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Future.delayed(Duration.zero, () {
                        showOrderHistory(message: state.errorResponse.message);
                      });
                    });
                    print("Error");
                    cubit.resetState();
                  }
                 //print("response: ${orderHistoryList.length}");
                  if (state is OrderHistorySuccessState) {
                    orderHistoryList = state.response ?? [];
                    orderHistoryFetched = true;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Future.delayed(Duration.zero, () {
                        showOrderHistory();
                      });
                    });
                    cubit.resetState();
                  }
                  return overLay(
                      Scaffold(
                        backgroundColor: kWhite,
                        appBar: PreferredSize(
                            child: defaultDashboardAppBarWidget(() {
                              Get.back(result: true);
                            //  Navigator.pop(context,true);
                            }, "Orders", context: context),
                            preferredSize: Size.fromHeight(80.h)),
                        body: SingleChildScrollView(
                          child: Obx(() {
                            if(orderListWithoutRejectedIsEmpty.value){
                              return Container(
                                height: 800.h,
                                child: Center(
                                  child: emptyOrder("sales",
                                      image: "assets/reportEmpty.svg",
                                          () {},
                                      header: "You have not received any order yet",
                                      headerDetail: ""
                                  ),
                                ),
                              );
                            }
                            return Column(
                              children: [
                                gapHeight(12.h),
                                Padding(
                                  padding:
                                  EdgeInsets.symmetric(
                                      vertical: 16.h, horizontal: 16.w),
                                  child: customSearchDesign(
                                    "Search records",
                                        (String value) {
                                      _controllerOrders.filterByName(value);
                                      setState(() {
                                        orderList = _controllerOrders.orderList;
                                      });
                                    },
                                    inputType: TextInputType.text,
                                  ),
                                ),
                                gapHeight(12.h),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 20.w, right: 20.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      customText1(
                                          "Showing all order records",
                                          kBlackB600, 16.sp,
                                          fontWeight: FontWeight.w400),
                                      GestureDetector(
                                        onTap: () {
                                          Get.bottomSheet(
                                              OrderFilterOptions()).whenComplete(() {
                                            _controllerOrders.orderFilter(_controllerOrders.selectedFilterChoice.value);
                                            setState(() {
                                              orderList = _controllerOrders.orderList;
                                            });
                                            if (orderList.isEmpty) {
                                              setState(() {
                                                orderList = orderListTemp;
                                              });
                                              Get.snackbar(
                                                "Filter Result",
                                                "Not found",
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white,
                                              );
                                              setState(() {
                                                //   _controllerDashboard.saleList=
                                                //  saleListTemp;
                                              });
                                            } else {
                                              setState(() {
                                                orderList = orderList;
                                              });
                                            }
                                          });
                                          //   Get.bottomSheet(CustomCalendar(),
                                          //   backgroundColor:kWhite);
                                        },
                                        child: Container(
                                          height: 30.h,
                                          width: 64.w,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              customText1(
                                                  "Filter", kBlack, 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: fontFamily),
                                              SvgPicture.asset(
                                                  "assets/filter.svg")
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                gapHeight(18.h),
                                SingleChildScrollView(
                                  child: Container(
                                    height: 700.h,
                                    child: SmartRefresher(
                                      controller: refreshController2,
                                      enablePullDown: true,
                                      header: ClassicHeader(),
                                      onRefresh: onRefresh,
                                      child: ListView.builder(
                                          itemCount: orderListWithoutRejected.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    _controllerOrders.isLoading.value;
                                                    dynamic response =
                                                    await showCupertinoModalBottomSheet(
                                                        topRadius:
                                                        Radius.circular(0.r),
                                                        backgroundColor: kWhite,
                                                        context: context,
                                                        builder: (context) {
                                                          return
                                                            Container(
                                                              height: _controllerOrders.getVeiwOrderHeight(orderListWithoutRejected[index].totalItems),
                                                             color: kWhite,
                                                              child: ViewOrder(
                                                                orderId: orderListWithoutRejected[index].orderId,
                                                                isReceipt: false,),
                                                            );
                                                        });
                                                    if (response[1] == "Order") {
                                                      if (response[0]) {
                                                        await orderConfirmatiom(index, response[0]);
                                                      } else {
                                                        await orderConfirmatiom(index, response[0]);
                                                      }
                                                    } else {
                                                      await cancelOrder(
                                                          index, response[0]);
                                                    }
                                                  },
                                                  child:
                                                  ordersMockData(
                                                      orderListWithoutRejected[index],
                                                      context,
                                                      editSale: () {
                                                        _controllerOrders.isLoading.value;
                                                        Get.to(
                                                          UpdatePaymentStatus(
                                                              information:
                                                              orderListWithoutRejected[index]
                                                                  .orderId),
                                                          // transition: Transition.cupertino,
                                                          duration: Duration(seconds: 1),
                                                        );
                                                      },
                                                      receipt: () {
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
                                                                      orderListWithoutRejected[index]
                                                                          .totalItems),
                                                                  color: kWhite,
                                                                  child: ViewOrder(
                                                                    orderId: orderListWithoutRejected[index]
                                                                        .orderId,
                                                                    isReceipt: true,
                                                                  ),
                                                                );
                                                            });
                                                      }
                                                  ),
                                                ),
                                                gapHeight(20.h)
                                              ],
                                            );
                                          }),
                                    ),
                                  ),
                            ),
                              ],
                            );
                          }),
                        ),
                        floatingActionButton: GestureDetector(
                          onTap: () {
                            if (!orderHistoryFetched) {
                              cubit.getOrderHistory();
                            }
                            else {
                              showOrderHistory();
                            }
                          },
                          child: Container(
                            height: 60.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              boxShadow: CupertinoContextMenu.kEndBoxShadow,
                              color: kLightPink,
                              borderRadius: BorderRadius.circular(12.r),
                              shape: BoxShape.rectangle,
                            ),
                            child: Image.asset("assets/historyWithoutBg.png",
                              height: 20.h,
                              width: 20.w,
                            ),
                          ),
                        ),
                      ),
                      isLoading: state is OrderHistoryLoadingState
                  );
                }
            ),
            isLoading: _controllerOrders.isLoading.value,
          ),
    );
  }

  showOrderHistory({ String message=""}) {
    showCupertinoModalBottomSheet(
       // isDismissible: false,
        enableDrag: true,
        backgroundColor: kWhite,
        context: context,
        builder: (context) {
          return Container(
              height: _controllerOrders.getBottomSheetHeights(
                  orderHistoryList.length),
              child: OrderHistory(orderHistoryLists: orderHistoryList,message: message,));
        }
    );
  }

  Future<void> orderConfirmatiom(int index, bool response) async {
    bool res = await _controllerOrders
        .orderConfirmation(orderList[index].orderId, response);
    if (res) {
      orderList = await _controllerOrders.userOrders(
          isRefresh: true,
          refreshController:
          refreshController2);
      setState(() {
        orderList = orderList;
        orderListWithoutRejected = orderList.where((element) =>
        element.isAccepted != "Rejected").toList();
      });
    } else {
      Get.snackbar(
        "Failed Operation",
        "Operation failed please try again later",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> cancelOrder(int index, bool response) async {
    bool res = await _controllerOrders
        .orderCancel(orderList[index].orderId, response);
    if (res) {
      orderList = await _controllerOrders.userOrders(
          isRefresh: true,
          refreshController:
          refreshController2);
      setState(() {
        orderList = orderList;
        orderListWithoutRejected = orderList.where((element) =>
        element.isAccepted != "Rejected").toList();
      });
    } else {
      Get.snackbar(
        "Order Cancel",
        "Failed to cancel order",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> onRefresh() async {
    orderList = await _controllerOrders.userOrders(
        isRefresh: true, refreshController: refreshController2);
    setState(() {
      orderList = orderList;
      orderListWithoutRejected = orderList.where((element) =>
      element.isAccepted != "Rejected").toList();
    });
  }
}
