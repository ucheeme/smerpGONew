import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smerp_go/controller/faqsController.dart';
import 'package:smerp_go/utils/app_services/helperClass.dart';

import '../../../../utils/appColors.dart';
import '../../../../utils/appDesignUtil.dart';

class FAQs extends StatefulWidget {
  const FAQs({Key? key}) : super(key: key);

  @override
  State<FAQs> createState() => _FAQsState();
}

class _FAQsState extends State<FAQs> {
  var _controller = Get.put(FaqsController());
  bool isSwitched = false;
  String category= "";
  bool isExpanded = true;
  bool isExpanded1 = true;
  bool isExpanded2 = true;
  bool isExpanded3 = true;
  bool isExpanded4 = true;
  bool isExpanded5 = true;
  bool isExpanded6 = true;
  bool isExpanded7 = true;
  bool isExpanded8 = true;
  bool isExpanded9 = true;
  bool isExpanded10 = true;
  bool isExpanded11 = true;
  bool isExpanded12 = true;
  bool isExpanded13 = true;
  bool isExpanded14 = true;
  bool isExpanded15 = true;
  bool isExpanded16 = true;
  bool isExpanded17 = true;
  bool isExpanded18 = true;
  bool isExpanded19 = true;
  bool isExpanded20 = true;
  bool isExpanded21 = true;
  bool isExpanded22 = true;
  List<String>_faqs =["What is Smerp Go?", "How to View all sales records?",
  "How to record a new sale?", "How to edit a sale?", "How to delete a sale?",
    "How to print a sale receipt?", "How to add a new product?", "How to view all product?",
     "How to edit a product?", "What is catalog?", "How does catalogue work?",
    "How to download reports?", "How can I add or edit my information?",
    "How can I delete my account?",
    ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: PreferredSize(
            child: defaultDashboardAppBarWidget(() {
              Get.back();
           },"FAQs",context: context),
            preferredSize: Size.fromHeight(60.h)),
        body: Padding(
          padding: EdgeInsets.only(left: 16.w,right: 16.w),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                gapHeight(19.h),
                customSearchDesign("Search topic",(String value){
                //  _faqs.where((element) => element.contains(value));
                },
                  inputType: TextInputType.text,),
                gapHeight(20.h),
                ButtonsTabBar(
                  //  controller: _controllerTab,
                  //height: 58.h,
                  height: 58.h,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15.w,
                      vertical: 10.h),
                  unselectedDecoration: BoxDecoration(
                      color:kLightPink.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                          color: kLightPink.withOpacity(0.4), width: 0.5.w)),
                  unselectedBorderColor: kCalendarLightPink,
                  decoration: BoxDecoration(
                    color: kLightPink,

                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  borderColor: kAppBlue,
                  borderWidth: 0.5.w,
                  radius: 15.r,
                  unselectedLabelStyle: TextStyle(
                    color: kBlack,
                    fontSize: 14.sp,
                    fontFamily: "inter",
                    fontWeight: FontWeight.normal,
                  ),
                  labelStyle: TextStyle(
                    color: kAppBlue,
                    fontSize: 14.sp,
                    fontFamily: "inter",
                    fontWeight: FontWeight.normal,
                  ),

                  tabs: [
                    Tab(text: "All"),
                    Tab(text: "Sales"),
                    Tab(text: "Inventory"),
                    Tab(text: "Catalog"),
                    Tab(text: "Report"),
                    Tab(text: "Account"),
                    Tab(text: "Order"),

                  ],
                ),
               Container(
                 height: 850.h,
                 child: TabBarView(
                  children: [
                    Container(
                      color: kWhite,
                      height: 800.h,
                      child: ListView(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          children: [
                            card('Q:${_faqs[0]}',
                                'A: Smerp Go is a lite version of SMERP which is a cloud-based ERP solution. \n'
                                    'Smerp Go helps you keep records of your sales and inventory, gives a report on your records and provides '
                                    'you with a website to display your available products. ',
                                isExpanded,
                                    (){
                                  setState(() {
                                    isExpanded = !isExpanded;
                                  });
                                }
                            ),
                            gapHeight(20.h),
                            card('Q: ${_faqs[1]}',
                                'A: On the home screen, click add new sale. Fill in the details of the new sale; \n'
                                    'enter product, enter quantity, enter the units of the product (which is how '
                                    'the product is measured), enter the payment status, click add sale.',
                                isExpanded1,
                                    (){
                                  setState(() {
                                    isExpanded1 = !isExpanded1;
                                  });
                                }
                            ),
                            gapHeight(20.h),
                            card('Q: ${_faqs[2]}',
                                'A: On the home screen, click on the edit icon for the sale you’d like to edit.',
                                isExpanded2,
                                    (){
                                  setState(() {
                                    isExpanded2 = !isExpanded2;
                                  });
                                }
                            ),

                            gapHeight(20.h),
                            card('Q: ${_faqs[3]}',
                                'A: On the home screen, click on the delete icon for the sale you’d like to delete',
                                isExpanded3,
                                    (){
                                  setState(() {
                                    isExpanded3 = !isExpanded3;
                                  });
                                }
                            ),
                            gapHeight(20.h),
                            card('Q:${_faqs[4]}',
                                'A: On the home screen, click on the receipt icon for the sale you’d like to see the receipt.',
                                isExpanded4,
                                    (){
                                  setState(() {
                                    isExpanded4 = !isExpanded4;
                                  });
                                }
                            ),
                            gapHeight(20.h),
                            card('Q: ${_faqs[5]}',
                                'A: On the home screen, click on the receipt icon for the sale you’d like to see the receipt.',
                                isExpanded5,
                                    (){
                                  setState(() {
                                    isExpanded5 = !isExpanded5;
                                  });
                                }
                            ),
                            gapHeight(20.h),
                            card('Q: ${_faqs[6]}',
                                'A: On the Inventory screen, click add new product. Fill in the details of the new product; \n'
                                    'enter product name, enter product image, enter product category, enter product selling \n'
                                    'price, enter product selling price, enter quantity, enter the units of the product \n'
                                    '(which is how the product is measured), click add product',
                                isExpanded6,
                                    (){
                                  setState(() {
                                    isExpanded6 = !isExpanded6;
                                  });
                                }
                            ),
                            gapHeight(20.h),
                            card('Q:${_faqs[7]}',
                                'A: On the home screen, click on the edit icon for the sale you’d like to edit.',
                                isExpanded7,
                                    (){
                                  setState(() {
                                    isExpanded7 = !isExpanded7;
                                  });
                                }
                            ),
                            gapHeight(20.h),
                            card('Q: ${_faqs[8]}',
                              "",
                                isExpanded8,
                                    (){
                                  setState(() {
                                    isExpanded8 = !isExpanded8;
                                  });
                                }
                            ),
                            gapHeight(20.h),
                            card('Q: ${_faqs[9]}',
                               'A: On the inventory screen, click on the delete icon for the product you’d like to delete.',
                                isExpanded9,
                                    (){
                                  setState(() {
                                    isExpanded9 = !isExpanded9;
                                  });
                                }
                            ),
                            gapHeight(20.h),
                            card('Q: ${_faqs[10]}',
                              "",
                                isExpanded10,
                                   (){
                                  setState(() {
                                    isExpanded10 = !isExpanded10;
                                  });
                                }
                            ),
                            gapHeight(20.h),
                            card('Q: ${_faqs[11]}',
                              "",
                               isExpanded11,
                                    (){
                                  setState(() {
                                    isExpanded11 = !isExpanded11;
                                  });
                                }
                            ),

                            gapHeight(20.h),
                            card('Q: ${_faqs[12]}',
                                'A:Click on the profile icon in the top left corner on any screen, \n''click personal data, you can edit your first name, last name, store name, email and phone number. Click on update info',
                               isExpanded12,
                                    (){
                                  setState(() {
                                    isExpanded12 = !isExpanded12;
                                  });
                                }
                            ),
                          gapHeight(20.h),
                            card('Q:${_faqs[13]}',
                                'A: Click on the profile icon in the top left corner on any screen, \n'
                                    'click on delete account, enter pin to delete account, click confirm.',
                                isExpanded13,
                                    (){
                                  setState(() {
                                    isExpanded13 = !isExpanded13;
                                  });
                                }
                            ),
                          ]
                      ),
                    ),
                    Container(
                      color: kWhite,
                      height: 700.h,
                      child: ListView(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          children: [

                            gapHeight(20.h),
                            card('Q: ${_faqs[1]}',
                                'A: On the home screen, click add new sale. Fill in the details of the new sale; \n'
                                    'enter product, enter quantity, enter the units of the product (which is how '
                                    'the product is measured), enter the payment status, click add sale.',
                                isExpanded1,
                                    (){
                                  setState(() {
                                    isExpanded1 = !isExpanded1;
                                  });
                                }
                            ),
                            gapHeight(20.h),
                            card('Q:  ${_faqs[2]}',
                                'A: On the home screen, click see records, you can filter by date or'
                                    ' transaction status.',
                                isExpanded2,
                                    (){
                                  setState(() {
                                    isExpanded2 = !isExpanded2;
                                  });
                                }
                           ),
                            gapHeight(20.h),
                            card('Q:${_faqs[3]}',
                                'A: On the home screen, click on the edit icon for the sale you’d like to edit.',
                                isExpanded7,
                                    (){
                                  setState(() {
                                    isExpanded7 = !isExpanded7;
                                  });
                                }
                            ),
                            gapHeight(20.h),
                            card('Q: ${_faqs[4]}',
                                'A: On the home screen, click on the delete icon for the sale you’d like to delete',
                                isExpanded8,
                                    (){
                                  setState(() {
                                    isExpanded8 = !isExpanded8;
                                  });
                                }
                            ),
                            gapHeight(20.h),
                            card('Q: ${_faqs[5]}',
                                'A: On the home screen, click on the receipt icon for the sale you’d like to see the receipt.',
                                isExpanded9,
                                    (){
                                  setState(() {
                                    isExpanded9 = !isExpanded9;
                                  });
                                }
                            ),
                          ]
                      ),
                    ),
                    Container(
                      color: kWhite,
                      height: 700.h,
                      child: ListView(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          children: [

                            gapHeight(20.h),
                            card('Q: How do I add products on the Smerp app?',
                                'A: Go to Products, add new products, fill in the details e.g. Product name, type, description, '
                                    'image etc. and you are good to go.',
                                isExpanded3,
                                    (){
                                  setState(() {
                                    isExpanded3 = !isExpanded3;
                                  });
                                }
                            ),

                            gapHeight(20.h),
                            card('Q: How to Add a New Product?',
                                'A: On the Inventory screen, click add new product. Fill in the details of the new product; \n'
                                    'enter product name, enter product image, enter product category, enter product selling \n'
                                    'price, enter product selling price, enter quantity, enter the units of the product \n'
                                    '(which is how the product is measured), click add product',
                                isExpanded11,
                                    (){
                                  setState(() {
                                    isExpanded11 = !isExpanded11;
                                  });
                                }
                            ),
                            gapHeight(20.h),
                            card('Q: How to View all Products?',
                                'A: On the inventory screen, click inventory records, you can filter by date or category',
                                isExpanded12,
                                    (){
                                  setState(() {
                                    isExpanded12 = !isExpanded12;
                                  });
                                }
                            ),
                            gapHeight(20.h),
                            card('Q: How to Edit a Product',
                                'A: On the inventory screen, click on the edit icon for the product you’d like to edit.',
                                isExpanded13,
                                    (){
                                  setState(() {
                                    isExpanded13 = !isExpanded13;
                                  });
                                }
                            ),
                            gapHeight(20.h),
                            card('Q: How to Delete a Product',
                               'A: On the inventory screen, click on the delete icon for the product you’d like to delete.',
                                isExpanded14,
                                    (){
                                  setState(() {
                                    isExpanded14 = !isExpanded14;
                                  });
                                }
                            ),
                          ]
                      ),
                    ),
                    Container(
                      color: kWhite,
                      height: 700.h,
                      child: ListView(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          children: [

                            gapHeight(20.h),
                            card('Q: What is Catalogue?',
                                'A: Smerp Go gives you a website for your customers to have access to your products listing, this is called catalogue',
                                isExpanded15,
                                   (){
                                  setState(() {
                                    isExpanded15 = !isExpanded15;
                                  });
                                }
                            ),
                            gapHeight(20.h),
                            card('Q: How does Catalogue work?',
                                'A: On the catalogue screen, select which products you’d like to show available on your website by toggling them on/off.',
                               isExpanded16,
                                    (){
                                  setState(() {
                                    isExpanded16 = !isExpanded16;
                                  });
                                }
                            ),
                          ]
                      ),
                    ),
                    Container(
                      color: kWhite,
                      height: 700.h,
                      child: ListView(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          children: [
                              gapHeight(20.h),
                            card('Q: How to Download Reports?',
                                'A: On the reports screen, select the range of the report, click download report.',
                                isExpanded17,
                                    (){
                                  setState(() {
                                    isExpanded17 = !isExpanded17;
                                  });
                                }
                            ),

                          ]
                      ),
                    ),
                    Container(
                      color: kWhite,
                      height: 700.h,
                      child: ListView(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          children: [
                            gapHeight(20.h),
                            card('Q: How can I add or edit my information?',
                                'A:Click on the profile icon in the top left corner on any screen, \n''click personal data, you can edit your first name, last name, store name, email and phone number. Click on update info',
                               isExpanded18,
                                    (){
                                  setState(() {
                                    isExpanded18 = !isExpanded18;
                                  });
                                }
                            ),
                            gapHeight(20.h),
                            card('Q: How can I delete my account?',
                                'A: Click on the profile icon in the top left corner on any screen, \n'
                                    'click on delete account, enter pin to delete account, click confirm.',
                                isExpanded19,
                                    (){
                                  setState(() {
                                    isExpanded19 = !isExpanded19;
                                  });
                                }
                            ),
                          ]
                      ),
                    ),
                    Container(
                      color: kWhite,
                      height: 700.h,
                      child: ListView(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          children: [
                            gapHeight(20.h),
                            card('Q: How can I accept or reject order?',
                                'A:Click on the order you received, when the bottom-sheet shows, select any of the options you want., \n',
                                isExpanded20,
                                    (){
                                  setState(() {
                                    isExpanded20 = !isExpanded20;
                                  });
                                }
                            ),
                            gapHeight(20.h),
                            card('Q: How can I cancel an order?',
                                'A: Click on the order you accepted when the bottom-sheet opens up, \n'
                                    'click on cancel order.',
                                isExpanded21,
                                    (){
                                  setState(() {
                                    isExpanded21 = !isExpanded21;
                                  });
                                }
                            ),
                            gapHeight(20.h),
                            card('Q: How can I update the payment of an order?',
                                'A: Click on the pen icon on the order you accepted, \n'
                                    'You will be taken to a new screen on the screen enter the delivery code sent to your customer \n'
                                    'select the payment status and click on Update payment status',
                                isExpanded22,
                                    (){
                                  setState(() {
                                    isExpanded22 = !isExpanded22;
                                  });
                                }
                            ),
                          ]
                      ),
                    ),
                  ],
                  ),
               ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}
