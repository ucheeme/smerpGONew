import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smerp_go/core/content/faq_tab_entries.dart';

import '../../../../utils/appColors.dart';
import '../../../../utils/appDesignUtil.dart';

class FAQs extends StatefulWidget {
  const FAQs({Key? key}) : super(key: key);

  @override
  State<FAQs> createState() => _FAQsState();
}

class _FAQsState extends State<FAQs> {
  final List<bool> _expandedStates =
      List<bool>.filled(FaqTabEntries.expansionStateCount, true);

  final List<String> _faqs = const [
    'What is Smerp Go?',
    'How to View all sales records?',
    'How to record a new sale?',
    'How to edit a sale?',
    'How to delete a sale?',
    'How to print a sale receipt?',
    'How to add a new product?',
    'How to view all product?',
    'How to edit a product?',
    'What is catalog?',
    'How does catalogue work?',
    'How to download reports?',
    'How can I add or edit my information?',
    'How can I delete my account?',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: defaultDashboardAppBarWidget(() {
            Get.back();
          }, 'FAQs', context: context),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                gapHeight(19.h),
                customSearchDesign(
                  'Search topic',
                  (String value) {},
                  inputType: TextInputType.text,
                ),
                gapHeight(20.h),
                ButtonsTabBar(
                  height: 58.h,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 10.h,
                  ),
                  unselectedDecoration: BoxDecoration(
                    color: kLightPink.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: kLightPink.withOpacity(0.4),
                      width: 0.5.w,
                    ),
                  ),
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
                    fontFamily: 'inter',
                    fontWeight: FontWeight.normal,
                  ),
                  labelStyle: TextStyle(
                    color: kAppBlue,
                    fontSize: 14.sp,
                    fontFamily: 'inter',
                    fontWeight: FontWeight.normal,
                  ),
                  tabs: const [
                    Tab(text: 'All'),
                    Tab(text: 'Sales'),
                    Tab(text: 'Inventory'),
                    Tab(text: 'Catalog'),
                    Tab(text: 'Report'),
                    Tab(text: 'Account'),
                    Tab(text: 'Order'),
                  ],
                ),
                SizedBox(
                  height: 850.h,
                  child: TabBarView(
                    children: [
                      _buildFaqTab(
                        FaqTabEntries.all(_faqs),
                        height: 800,
                      ),
                      _buildFaqTab(
                        FaqTabEntries.sales(_faqs),
                        leadingGap: true,
                      ),
                      _buildFaqTab(
                        FaqTabEntries.inventory,
                        leadingGap: true,
                      ),
                      _buildFaqTab(
                        FaqTabEntries.catalog,
                        leadingGap: true,
                      ),
                      _buildFaqTab(
                        FaqTabEntries.report,
                        leadingGap: true,
                      ),
                      _buildFaqTab(
                        FaqTabEntries.account,
                        leadingGap: true,
                      ),
                      _buildFaqTab(
                        FaqTabEntries.order,
                        leadingGap: true,
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

  Widget _buildFaqTab(
    List<FaqEntry> entries, {
    double height = 700,
    bool leadingGap = false,
  }) {
    return Container(
      color: kWhite,
      height: height.h,
      child: ListView.separated(
        padding: leadingGap ? EdgeInsets.only(top: 20.h) : EdgeInsets.zero,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        itemCount: entries.length,
        separatorBuilder: (_, __) => gapHeight(20.h),
        itemBuilder: (context, index) {
          final entry = entries[index];
          final expansionIndex = entry.expansionIndex;

          return card(
            entry.question,
            entry.answer,
            _expandedStates[expansionIndex],
            () {
              setState(() {
                _expandedStates[expansionIndex] =
                    !_expandedStates[expansionIndex];
              });
            },
          );
        },
      ),
    );
  }
}
