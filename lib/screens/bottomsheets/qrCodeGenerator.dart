import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

import '../../utils/appColors.dart';
import '../../utils/appDesignUtil.dart';

class GenerateQRCode extends StatefulWidget {
  String link;
   GenerateQRCode({super.key, required this.link});

  @override
  State<GenerateQRCode> createState() => _GenerateQRCodeState();
}

class _GenerateQRCodeState extends State<GenerateQRCode> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350.h,
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
              child: customText1("Scan code", kBlack, 18.sp,
                fontWeight: FontWeight.w500,fontFamily: fontFamily
              ),
            ),
          ),
          gapHeight(20.h),
        Center(
          child: Container(
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r)
            ),
            child: SfBarcodeGenerator(value: widget.link,
            symbology: QRCode()),
          ),
        )
        ],
      ),
    );
  }
}
