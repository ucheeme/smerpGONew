import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:screenshot/screenshot.dart';
import 'package:image/image.dart' as img;
// import 'package:excel/excel.dart';
import 'package:share_plus/share_plus.dart';

import '../../utils/appCalendar.dart';
import '../../utils/appColors.dart';
import '../../utils/appDesignUtil.dart';

class DownloadFornmat extends StatefulWidget {
  Uint8List? image;
  String? title;
   DownloadFornmat({Key? key, required this.image,  this.title}) : super(key: key);

  @override
  State<DownloadFornmat> createState() => _DownloadFornmatState();
}

class _DownloadFornmatState extends State<DownloadFornmat> {
  // ScreenshotController _screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270.h,
      color: kWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: kLightPink,
            height: 60.h,
            child: Align(
              alignment: Alignment.centerLeft,
              child: customText1(" Report download format", kBlack, 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          gapHeight(20.h),
          GestureDetector(
            onTap: (){
              getPdf("Sale Report", widget.image!);
             Get.back();
            },
            child: Container(
              width: double.infinity,
              height: 54.h,
              child: Padding(
                padding: EdgeInsets.only(left: 20.h),
                child: customText1("Download in PDF", kBlackB800, 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              saveAsImage(widget.image!);
              Get.back();

            },
            child: Container(
              width: double.infinity,
              height: 54.h,
              child: Padding(
                padding: EdgeInsets.only(left: 20.h),
                child: customText1("Download as an image", kBlackB800, 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // GestureDetector(
          //   onTap: (){
          //     downloadImageAsExcel(widget.image!);
          //     Get.back();
          //
          //   },
          //   child: Container(
          //     width: double.infinity,
          //     height: 54.h,
          //     child: Padding(
          //       padding: EdgeInsets.only(left: 20.h),
          //       child: customText1("Download in excel format", kBlackB800, 16.sp,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
  Future<void> saveAsImage(Uint8List image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(image);
        await Share.shareXFiles([imagePath as XFile]);
      }

  }


}
Future<dynamic> ShowCapturedWidget(
    BuildContext context, Uint8List capturedImage) {
  return showDialog(
    useSafeArea: false,
    context: context,
    builder: (context) => Scaffold(
      appBar: AppBar(
        title: Text("Captured widget screenshot"),
      ),
      body: Center(child: Image.memory(capturedImage)),
    ),
  );

}

Future getPdf(String fileName,Uint8List screenShot) async {
  pw.Document pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Expanded(
            child:  pw.Image(pw.MemoryImage(screenShot), fit: pw.BoxFit.contain)
       );
      },
    ),
  );
  String path = (await getTemporaryDirectory()).path;
  File pdfFile = await File('$path/$fileName.pdf').create();

  pdfFile.writeAsBytesSync(await pdf.save());
  await Share.shareXFiles([pdfFile as XFile]);
}
