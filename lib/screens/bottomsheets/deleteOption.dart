import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utils/appColors.dart';
import '../../utils/appDesignUtil.dart';

class DeleteOption extends StatefulWidget {
  String title;
  String productName;
  DeleteOption({Key? key, required this.title,
    required this.productName}) : super(key: key);

  @override
  State<DeleteOption> createState() => _DeleteOptionState();
}

class _DeleteOptionState extends State<DeleteOption> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      color: kWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: kLightPinkPin.withOpacity(0.4),
            height: 73.h,
            child: Padding(
              padding:  EdgeInsets.only(top: 30.h,bottom: 20.h,left: 20.w),
              child: customText1("Delete ${widget.title}", kBlack, 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          gapHeight(20.h),
          Padding(
            padding: EdgeInsets.only(left: 20.h),
            child: customText1("Are you sure you want to delete ‘${widget.productName}’ "
                "?", kBlackB800, 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          gapHeight(55.h),
          Padding(
            padding:  EdgeInsets.only(left: 12.w,right: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){
                    Get.back(result: 0);
                  },
                  child: Container(
                    height: 60.h,
                    width: 192.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: kDashboardColorBlack3,
                    ),
                    child: Center(child: customText1( "No, Discard",kBlack,
                        18.sp)),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Get.back(result: 1);
                  },
                  child: Container(
                    height: 60.h,
                    width: 192.w,
                    decoration: BoxDecoration(
                      color: kRed50,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Center(
                        child: customText1("Yes, Delete",kRed60, 18.sp)
                    ),
                  ),
                )
              ],
            ),
          ),
         //gapHeight(20.h)
        ],
      ),
    );
  }
}
