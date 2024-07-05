import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'package:date_format/date_format.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/src/widgets/text.dart';
import 'dart:async';
// import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smerp_go/model/response/inventoryList.dart';
import 'package:smerp_go/model/response/order/orderDetails.dart';
import 'package:smerp_go/model/response/sales/saleList.dart';
import 'package:smerp_go/model/response/sales/saleListInfo.dart';
import 'package:smerp_go/model/response/salesList.dart';
import 'package:smerp_go/screens/authentication_signup/signInFlow/forgotPin.dart';
import 'package:smerp_go/screens/bottomNav/screens/inventory/editProduct.dart';
import 'package:smerp_go/screens/bottomNav/screens/sales/editSale.dart';
import 'package:smerp_go/screens/bottomsheets/customerReceipt.dart';
import 'package:smerp_go/screens/bottomsheets/deleteOption.dart';
import 'package:smerp_go/screens/bottomsheets/updateQuantityStock.dart';
import 'package:smerp_go/utils/appColors.dart';
import 'package:smerp_go/utils/app_services/helperClass.dart';
import 'package:smerp_go/utils/customPin.dart';
import 'package:smerp_go/utils/fileStorage.dart';
import 'package:smerp_go/utils/mockdata/mockProductsData.dart';
import 'package:image/image.dart' as img;
import 'package:smerp_go/utils/mockdata/tempData.dart';
import 'package:smerp_go/utils/slideUpRoute.dart';

import '../controller/addNewProduct.dart';
import '../controller/addSaleController.dart';
import '../controller/catalogueController.dart';
import '../controller/inventoryController.dart';
import '../model/response/order/allOrders.dart';
import '../screens/bottomsheets/addProductSaleEdit.dart';
import '../screens/bottomsheets/notification.dart';
import 'AppUtils.dart';
import 'UserUtils.dart';
import 'mockdata/mockInventoryData.dart';

String fontFamily = "TomatoGrotesk";
String fontFamilyGraphilk = "Graphik";
String fontFamilyInter = "inter";
Text customText1(String text, color, double size,
    {indent = TextAlign.start,
      fontWeight = FontWeight.normal,
      maxLines = 1,
      fontFamily = 'inter'}) {
  return Text(
    text,
    textAlign: indent,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      color: color,
      fontSize: size,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
    ),
  );
}

SizedBox gapHeight(double space) =>
    SizedBox(
      height: space,
    );

SizedBox gapWeight(double space) =>
    SizedBox(
      width: space,
    );

Text customTextnaira(String text, color, double size,
    {indent = TextAlign.start, fontWeight = FontWeight.normal, maxLines = 1,
    fotFamily ="TomatoGrotesk"}) {
  return Text(
    text,
    textAlign: indent,
    maxLines: maxLines,
   // overflow: TextOverflow.ellipsis,
   // softWrap: false,
    style: TextStyle(
      color: color,
      fontSize: size,
      fontWeight: fontWeight,
    ),
  );
}

Widget titleSignUp(TextEditingController controller, {
  TextInputType textInput = TextInputType.text,
  String hintText = "",
  bool readOnly = false,
  dynamic onChanged,
  dynamic focus
  //String initialValue = ""
}) {
  return Container(
    height: 60.h,
    width: 390.w,
    child: TextFormField(
      focusNode: focus,
      readOnly: readOnly,
      decoration: InputDecoration(
          constraints: BoxConstraints.loose(Size(390.w, 102.h)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kAppBlue),
            borderRadius: BorderRadius.circular(10.r),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            borderSide: BorderSide(
              color: kAppBlue,
              width: 0.3,
                style: BorderStyle.none
            ),
          ),
          labelText: hintText,
          labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              color: kBlackB700,
              fontSize: 14.sp,
              fontFamily: "inter_regular")),
      controller: controller,
      onChanged: onChanged,
      //  initialValue:initialValue ,
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontFamily: 'inter_regular',
          fontSize: 16.sp),
      keyboardType: textInput,
    ),
  );
}

Widget titleSignUp2(TextEditingController controller, {
  TextInputType textInput = TextInputType.text,
  String hintText = "",
  bool readOnly = false,
  dynamic onChanged,
  dynamic focus,
  height =102,
  width = 390

}) {
  return Container(
    height: height,
    width: width,
    child: TextFormField(
      focusNode: focus,
      readOnly: readOnly,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
         // constraints: BoxConstraints.loose(Size(390.w, 102.h)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kAppBlue),
            borderRadius: BorderRadius.circular(10.r),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            borderSide: BorderSide(
              color: kAppBlue,
            ),
          ),
          labelText: hintText,
          labelStyle: TextStyle(
              fontWeight: FontWeight.w300,
              color: kBlack,
              fontSize: 16.sp,
              fontFamily: "inter regular")),
      controller: controller,
      onChanged: onChanged,
      //  initialValue:initialValue ,
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontFamily: 'inter regular',
          fontSize: 18.sp),
      keyboardType: textInput,
    ),
  );
}


Widget textFieldAmount(
    TextEditingController controller, {
  TextInputType textInput = TextInputType.text,
  String hintText = "",
  bool readOnly = false,
  dynamic onChanged,
  //String initialValue = ""
}) {
  return Container(
    height: 102.h,
    width: 390.w,
    child: TextFormField(
      readOnly: readOnly,
      decoration: InputDecoration(
          constraints: BoxConstraints.loose(Size(390.w, 102.h)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kAppBlue),
            borderRadius: BorderRadius.circular(10.r),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            borderSide: BorderSide(
              color: kAppBlue,
            ),
          ),
          labelText: hintText,
          labelStyle: TextStyle(
              fontWeight: FontWeight.w300,
              color: kBlack,
              fontSize: 16.sp,
              fontFamily: "inter regular")),
      controller: controller,
      onChanged: onChanged,
      inputFormatters: [CurrencyInputFormatter()],
      //  initialValue:initialValue ,
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontFamily: 'inter regular',
          fontSize: 18.sp),
      keyboardType: textInput,
    ),
  );
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue) {
    String formattedText = '₦' + _formatNumber(newValue.text);
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatNumber(String text) {
    // Remove any non-digit characters from the input
    String cleanedText = text.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanedText.isEmpty) return '0';

    // Format the number with comma as thousands separator
    final number = int.parse(cleanedText);
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }
}

Widget customSearchDesign(String hintTitle, onTap,
    {TextInputType inputType = TextInputType.text}) {
  return Container(
    height: 50.h,
    width: double.infinity,
    decoration: BoxDecoration(
      border: Border.all(color: kSalesListColor.withOpacity(0.4), width: 0.3),
      borderRadius: BorderRadius.circular(10.r),
    ),
    child: TextField(
      onChanged: onTap,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 20.w),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kAppBlue, width: 0.5),
          borderRadius: BorderRadius.circular(10.r),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0.5.w),
            borderRadius: BorderRadius.circular(10.r)),
        labelText: hintTitle,
        //labelText: 'Enter Expenses details',,
        labelStyle: TextStyle(
          color: kBlackB600,
          fontSize: 14.sp,
          fontFamily: fontFamilyInter
        ),

        suffixIcon: Padding(
          padding: EdgeInsets.only(bottom: 15.h, right: 15.w, top: 15.h),
          child: Image.asset(
            "assets/search-normal.png",
            fit: BoxFit.contain,
            width: 20.w,
            height: 20.h,
            color: kBlack,
          ),
        ),
        filled: false,
        isCollapsed: true,
      ),
      style: TextStyle(
        color: kBlack,
        fontSize: 14.sp,
      ),
      keyboardType: inputType,
    ),
  );
}

Widget dynamicContainer(Widget child, Color color, double height,
    {double radius = 15.0, double width = 370,
    }) {
  return Container(
    height: height,
    width: width.w,
    child: child,
    decoration: BoxDecoration(
       shape: BoxShape.rectangle,
        border: Border.all(color: kAppBlue, width: 0.5.w),
        borderRadius: BorderRadius.circular(radius.r),
        color: color),
  );
}

Widget appBarDesign(Function() onTap,
    {String title = "Welcome to SmerpGo👋",
      String footer = "Create your account with your phone number. \n"
          "Enter your phone number."}) {
  return Container(

    child: SingleChildScrollView(
      child: Container(
        height: 245.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        width: double.infinity,
        color: kLightPink,
       // color: kAppBlue,
       child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.only(top: 56.h),
                  child: Icon(
                    Icons.arrow_back,
                    size: 20,
                    weight:0.3,
                  ),
                )),
            // gapHeight(40.h),
            Spacer(),
            customText1(title, kBlack, 30.sp, fontWeight: FontWeight.w600),
           Spacer(),
            Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: customText1(footer, kBlack, 16.sp, fontWeight: FontWeight.w200,
                maxLines: 2)),
            Spacer()
          ],
        ),
      ),
    ),
  );
}

Widget altTextButton(onClicked, String text2,
    {String text1 = '', fontStyle = FontStyle.normal}) {
  return GestureDetector(
    onTap: onClicked,
    child: SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text1,
            style: TextStyle(
              color: kBlackB800,
              fontSize: 16.sp,
              fontFamily: 'euclid_circular_a_regular',
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(
            width: 5.h,
          ),
          Text(
            text2,
            style: TextStyle(
                color: kBlack,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'inter regular',
                fontStyle: FontStyle.normal),
          ),
        ],
      ),
    ),
  );
}

Image getImageString(String image) {
  var data = base64Decode(image);
  if (image != '') {
    return Image(
      loadingBuilder: (context, widget, stacktrace){
        return CircularProgressIndicator();
      },
      image: MemoryImage(data),
      fit: BoxFit.fill,
      errorBuilder: (ed, th, st) {
        return const Image(
        // image: AssetImage('assets/waaz.png'),
         image: AssetImage('assets/person.jpg.avif'),
          fit: BoxFit.fill,
        );
      },
    );
  } else {
    return  Image(
      loadingBuilder: (context, widget, stacktrace){
        return CircularProgressIndicator();
      },
      image: AssetImage(''),
      fit: BoxFit.fill,
    );
  }
}

Image displayImage(File? file) {
  if (file == null) {
    return Image(
      image: AssetImage('assets/waaz.png'),
      fit: BoxFit.fill,
    );
  } else {
    return Image(image: FileImage(file));
  }
}

Image base64ToImage(String base64String) {
  //rint(base64String);
  bool isEncoded = isBase64(base64String);
// base64String =
  if (isEncoded) {
    Uint8List bytes = const Base64Decoder().convert(base64String);
    // img.Image? image = img.decodeImage(bytes);
    return Image.memory(
      bytes,
      errorBuilder: (context, obj, trace) {
        return Image(
          image: AssetImage('assets/waaz.png'),
          fit: BoxFit.fill,
        );
      },
    );
  } else {
    return Image(
      image: AssetImage('assets/waaz.png'),
      fit: BoxFit.fill,
    );
  }
}

Widget overLay(Widget widget, {bool isLoading = false}) {
  return OverlayLoaderWithAppIcon(
    isLoading: isLoading,
    overlayBackgroundColor: kWhite,
    circularProgressColor: kAppBlue,
    appIconSize: 40.h,
    appIcon: SizedBox(),
    child: widget,
  );
}

bool isBase64(String value) {
  try {
    base64.decode(value);
    return true;
  } catch (e, trace) {
    print(e);
    print(trace);
    return false;
  }
}

Widget headerWithImage(String img,
    String storeName,
    StreamController<ErrorAnimationType> errorController,
    TextEditingController pinValueController,
    Function(String) onTap) {
  return Container(
    height: 444.h,
    width: double.infinity,
    color: kCalendarLightPink,
   // color: kPaidColor,
    child: Column(
      children: [
        Spacer(),
        Container(
          width: 108.45.w,
          height: 99.88.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: getImageNetwork(img).image, 
                fit: BoxFit.fill),
          ),
          // child: ,
        ),
        gapHeight(20.12.h),
        customText1("Welcome back $storeName 👋", kBlack, 24.sp,
            indent: TextAlign.center, fontWeight: FontWeight.bold),
        gapHeight(48.36.h),
        customText1("Enter your 4 digit pin to login", kBlackB800, 18.sp,
            fontWeight: FontWeight.w500),
        gapHeight(30.h),
        Padding(
          padding: EdgeInsets.only(left: 30.w, right: 30.w),
          child: Container(
            constraints: BoxConstraints.tight(Size(398.58.w, 101.64.h)),
            child: CustomPinTheme(
              pinLength: 4,
              errorController: errorController,
              pinValueController: pinValueController,
              onTap: onTap,
              isOTP: false,
            ),
          ),
        ),
        GestureDetector(
            onTap: () {
              Get.off(ForGotSignInPin(),
                  duration: Duration(seconds: 1), curve: Curves.easeIn);
            },
            child: customText1("Forgot your pin?", kBlackB800, 16.sp)),
     Spacer()
      ],
    ),
  );
}

InkWell card(title, subtext, control, tap) {
  return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: tap,
      child: AnimatedContainer(
        // margin: EdgeInsets.only(left: 20.w, right: 20.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        //height: control ? 78.h : 200.h,
        curve: Curves.fastLinearToSlowEaseIn,
        duration: Duration(milliseconds: 1200),
        decoration: BoxDecoration(
            color: kDashboardColorBorder,
            borderRadius: BorderRadius.circular(20.r)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 54.h,
              child: Visibility(
                visible: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 305.w,
                      child: customText1(title, kBlack, 16.sp),
                    ),
                    Icon(
                      control
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                      color: kHashBlack50,
                      size: 27,
                    ),
                  ],
                ),
              ),
            ),
            // isExpanded ? SizedBox() : SizedBox(
            //     height: 0.h),
            control
                ? SizedBox()
                : AnimatedContainer(
              duration: Duration(milliseconds: 1200),
              curve: Curves.easeInOut,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: customText1(subtext, kBlack, 16.sp, maxLines: 10),
              ),
            ),
          ],
        ),
      ));
}

Widget iconAndRow(String iconPath, String title, String supportText,
    {onTap, isSvg = true}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 80.h,
      color: kWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.67.w),
                  child: (isSvg)
                      ? SvgPicture.asset(iconPath)
                      : Image.asset(
                    iconPath,
                    height: 30.h,
                    width: 30.w,
                  ),
                ),
                gapWeight(21.35.w),
                customText1(title, kBlack, 18.sp),
              ],
            ),
          ),

         Icon(Icons.arrow_forward_ios,color:kBlack.withOpacity(0.5),
         size: 15,
           weight: 10,

         )
        ],
      ),
    ),
  );
}

Image getImage(String? image) {
  return getImageString(image!);
}

Widget dashboardAppBarWidget(iconTaped, String? image, String title,
   BuildContext context
) {
  Image getImage() {
    if (image == "N/A") {
      return getImageNetwork("");
    } else {
      return getImageNetwork(image!);
    }
  }

  return AppBar(
    elevation: 0,
    backgroundColor: kLightPinkPin,
    leadingWidth: 58.8.w,
    leading: Padding(
      padding: EdgeInsets.only(left: 16.w,top:5.h),
      child: GestureDetector(
        onTap: iconTaped,
        child: Container(
         decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            image:
            DecorationImage(image: getImage().image, fit: BoxFit.contain,
            scale: 0.2),
         ),
        ),
      ),
    ),
    title: Align(
      alignment: Alignment.center,
      child: customText1("           $title", kBlack, 20.sp,
         fontWeight: FontWeight.normal, fontFamily: fontFamilyGraphilk),
    ),

    actions: [
      Container(
        width: 30.w,
      ),
      GestureDetector(
        onTap: () {
          // Get.to(()=>NotficationApp(),
          //     duration: Duration(seconds: 1),
         //     transition: Transition.cupertino);
          Navigator.push(context, SlideUpRoute(page: NotificationApp()));
        },
        child: Padding(
          padding: EdgeInsets.only(right: 24.72.w),
          child: Container(
            height: 44.h,
            width: 44.w,
            decoration: BoxDecoration(shape:BoxShape.circle,
              color:kWhite2
  ),
            child:Icon(Icons.notifications_none_rounded,
            size: 22,
            color: kBlack,)
            ),
          ),
        ),
      // ),
    ],
  );
}

Widget defaultDashboardAppBarWidget(iconTaped, String title,{context,
isVisible = true}) {
  return AppBar(
    elevation: 0,
    toolbarHeight: 89.h,
    backgroundColor: kLightPinkPin.withOpacity(0.4),
    leadingWidth: 48.8.w,
    leading: Padding(
      padding: EdgeInsets.only(left: 16.w),
      child: GestureDetector(
        onTap: iconTaped,
        child: Image.asset("assets/arrow_back.png",
         fit: BoxFit.contain,
         // height: 14.h,
         // width: 14.w,
         // color: kBlack.withOpacity(0.8),
        ),
      ),
    ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        customText1(title, kBlack, 18.sp, fontWeight: FontWeight.w500,
            fontFamily: fontFamilyGraphilk),
      ],
    ),
    actions: [
      Container(
        width: 30.w,
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(context, SlideUpRoute(page: NotificationApp()));
        },
        child: Visibility(
          visible: isVisible,
          child: Padding(
            padding: EdgeInsets.only(right: 24.72.w),
            child: SvgPicture.asset(
              'assets/notification.svg',
              width: 25.w,
              height: 25.h,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget customerReceiptDashboardAppBarWidget(iconTaped,
    String title,{context,
  isVisible = true,
 dynamic downloadReceipt}) {
  return AppBar(
    elevation: 0,
    toolbarHeight: 89.h,
    backgroundColor: kLightPink,
    leadingWidth: 48.8.w,
    leading: Padding(
      padding: EdgeInsets.only(left: 16.w),
      child: GestureDetector(
        onTap: iconTaped,
        child: SvgPicture.asset("assets/backWard.svg",
          fit: BoxFit.scaleDown,
          height: 20.h,
          width: 10.w,
          // color: kBlack.withOpacity(0.8),
        ),
      ),
    ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        customText1(title, kBlack, 18.sp, fontWeight: FontWeight.w500),
      ],
    ),
    actions: [
      Container(
        width: 30.w,
      ),
      GestureDetector(
        onTap:downloadReceipt,
        child: Padding(
          padding: EdgeInsets.only(right: 24.72.w),
          child: Icon(Icons.download,
          color: kBlack,
          size: 30),
        ),
      ),
    ],
  );
}

var _controller = Get.put(AddNewSaleController());

Widget salesMockData(SalesDatum? mockData, BuildContext context,
    {dynamic deleteItem, dynamic editSale}) {
  //print(mockData!.createdOn.toIso8601String());
  var date = formatDate(
    (mockData!.createdOn).toLocal(),
    [dd, '/', mm, '/', yy,],);
  return Container(
    height: 110.h,
    width: 398.w,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r),
        color: kSalesListColor.withOpacity(0.8)
      //color: kGreen70
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // gapHeight(18.h),
          Container(
           // color: kRed70,
            width: 200.w, height: 80.h,
            padding: EdgeInsets.only(top: 10.h,bottom: 3.6.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customText1(
                mockData!.customerName, kBlackB800, 16.sp,
                    fontWeight: FontWeight.w400),
                Spacer(),
                //Gap(10),
                customTextnaira(
                    NumberFormat.simpleCurrency(name: 'NGN')
                        .format(double.parse(mockData.salesAmount.toString()))
                        .split(".")[0],
                    kAppBlue,
                    18.sp,
                    fontWeight: FontWeight.w500,fotFamily: fontFamily),

              ],
            ),
          ),
          // gapHeight(15.h),
          Container(
            width: 160.w,
            height: 80.h,
            // padding: EdgeInsets.only(top: 10.h,bottom: 10.h),
            child: Column(
             // mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                Container(
                  width: 140.w,
                  // color: kAppBlue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: editSale,
                          child: Visibility(
                            visible: (mockData.paymentStatus=='Paid')?false:true,
                            child: Image.asset(
                              "assets/rename.png",
                              height: 20.h,
                              width: 20.w,
                             fit: BoxFit.contain,
                            ),
                          )),
                    Spacer(),
                      GestureDetector(
                          onTap: deleteItem,
                          child: Image.asset("assets/Page-1.png",
                            height: 20.h,
                            width: 20.w,
                           fit: BoxFit.contain,)),
                     Spacer(),
                      Image.asset("assets/Icon-Set.png",
                        height: 20.h,
                        width: 20.w,
                        fit: BoxFit.contain,),
                    ],
                  ),
                ),
              Spacer(),
                Container(
                 width: 210.w,
                  height: 40.h,
                  child: SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       paymentStatusDesign(mockData.paymentStatus),
                      //  gapWeight(3.w),
                        Spacer(),
                        Icon(Icons.circle, color: kBlack.withOpacity(0.5),
                            size: 6),
                       // gapWeight(3.w),
                        Spacer(),
                        Container(
                          child: Row(
                            children: [
                              customText1(mockData.itemCount.toString(),
                                  kBlackB600, 12.sp,
                                  fontWeight: FontWeight.w300),
                               Gap(.5),
                              customText1("Product", kBlackB600, 12.sp,
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

Widget ordersMockData(Orders? mockData, BuildContext context,
    {dynamic receipt, dynamic editSale}) {
  print("This is the value: ${mockData!.custormerName} and ${mockData!.totalAmount}");
  var date = formatDate(
    (mockData!.orderDate).toLocal(),
    [
      dd,
      '/',
      mm,
      '/',
      yy,
    ],
  );
  return Container(
    height: 93.h,
    width: 398.w,
    padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
   decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: kSalesListColor.withOpacity(0.8)
     // color: kGreen70
    ),
    child: Row(
     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // gapHeight(18.h),
        Container(
         // color: kPaidColor,
          width: 180.w,
          height: 80.h,
          // padding: EdgeInsets.only(top: 10.h,bottom: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customText1((mockData.custormerName.length>10)?
              mockData.custormerName.replaceRange(10, mockData.custormerName.length, "..."):
              mockData!.custormerName, kBlackB800, 16.sp,
                  fontWeight: FontWeight.w400),
           Spacer(),
              customTextnaira(
                  NumberFormat.simpleCurrency(name: 'NGN')
                      .format(double.parse( mockData.totalAmount.toString()))
                      .split(".")[0],
                  kAppBlue,
                  18.sp,
                  fontWeight: FontWeight.w500,fotFamily: fontFamily),

            ],
          ),
        ),
      Spacer(),
        Container(
          width: 180.w,
          height: 84.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 140.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: editSale,
                        child: Container(
                          color: kSalesListColor.withOpacity(0.8),
                          height: 24.h,
                          width: 24.w,
                          child: Visibility(
                            visible: (mockData!.isAccepted=="Accepted"||mockData!.isAccepted=="Pending"),
                            child: Visibility(
                              visible: mockData.isAccepted=="Accepted",
                              child: Image.asset(
                                "assets/rename.png",
                                height: 20.h,
                                width: 20.w,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                        )),
                    Spacer(),
                    GestureDetector(
                     onTap: receipt,
                      child: Container(
                         color: kSalesListColor.withOpacity(0.8),
                          height: 24.h,
                          width: 24.w,
                          child: Visibility(
                            visible: (mockData!.isAccepted=="Accepted"||mockData!.isAccepted=="Pending"),
                            child: SvgPicture.asset("assets/receipt.svg",
                              fit: BoxFit.contain,),
                          ),
                      ),
                    ),
                  ],
                ),
              ),
             Spacer(),
              Container(
                width: 212.w,
                child: SingleChildScrollView(
                  child: Row(
                    children: [
                      paymentStatusDesign(mockData.isAccepted!),
                      Gap(2),
                      Icon(Icons.circle, color: kBlack.withOpacity(0.5), size: 6),
                      Gap(2),
                      Container(
                        width: 59.w,
                        child: Row(
                          children: [
                            customText1( mockData.totalItems.toString(),
                                kBlackB600, 13.sp,
                                fontWeight: FontWeight.w300),
                            Spacer(),
                            customText1("Product", kBlackB600, 13.sp,
                                fontWeight: FontWeight.w300),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // gapHeight(21.h)
      ],
    ),
  );
}


var _controllerInventory = Get.put(InventoryController());

Widget inventoryMockDataDesign(InventoryInfo? mockData,
    {dynamic editProduct}) {
  // InventoryInfo? info = mockData;
  return Container(
    height: 84.24.h,
    width: 398.w,
    padding: EdgeInsets.only(right: 15.w, left: 15.w),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: kSalesListColor.withOpacity(0.5)
      //color: kRed70
   ),
    child: Row(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 40.h,
          width: 40.w,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kInactiveLightPinkSwitch,
              image: DecorationImage(
                  image: getImageNetwork(
                      (mockData!.productImage == null)
                      ? "" : mockData!.productImage).image,
                  fit: BoxFit.contain)
          ),
        ),
        gapWeight(15.w),
        Container(
          width: 310.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(top: 10.h,bottom: 10.h),
               // color: kRed70,
                height: 85.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      //color: Colors.black,
                      width:150.w,
                      child: customText1(
                      mockData!.productName, kBlackB800, 16.sp,
                         fontWeight: FontWeight.w500),
                    ),
                   Spacer(),
                    Container(
                      width: 160.w,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customTextnaira(
                              NumberFormat.simpleCurrency(name: 'NGN')
                                  .format(double.parse(
                                  mockData.sellingPrice.toString()))
                                  .split(".")[0],
                              kAppBlue,
                              17.sp,
                             fontWeight: FontWeight.w500),
                       Spacer(),
                          Icon(Icons.circle, color: kBlack.withOpacity(0.5),
                              size: 6),
                         Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText1(
                                  "${mockData.quantity}", kBlackB600, 14.sp,
                                  fontWeight: FontWeight.w400),
                              gapWeight(4.w),
                              customText1(
                                  (mockData.unitCategory.length>10)?
                                      mockData.unitCategory.replaceRange(6, mockData.unitCategory.length, "..."):
                                  mockData.unitCategory, kBlackB600, 14.sp,
                                  fontWeight: FontWeight.w400),
                            ],
                          ),
                        ],
                      ),
                   ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                width: 144.w,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Spacer(),
                    GestureDetector(
                        onTap: () async {
                          Get.bottomSheet(
                              backgroundColor: kWhite,
                              ignoreSafeArea: false,
                              isScrollControlled: true,
                              Obx(() {
                                return Container(
                                    height: (isKeyboardOpen.value) ? 550.h : 300.h,
                                    child: UpdateInventoryStock(
                                        productId: mockData!.id));
                              })
                          );
                        },
                        child: Container(
                          width: 34.w,
                          height: 34.h,
                          decoration: BoxDecoration(
                              color: kLightPinkPin.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(7.r)),
                          child: SvgPicture.asset(
                            "assets/addInventoryCount.svg",
                            height: 22.h,
                            width: 22.w,
                            fit: BoxFit.scaleDown,
                          ),
                        )
                    ),
                    Spacer(),
                    GestureDetector(
                        onTap: editProduct,
                        child: Container(
                            width: 34.w,
                            height: 34.h,
                            decoration: BoxDecoration(
                                color: kLightPinkPin.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(7.r)),
                            child: SvgPicture.asset("assets/Vector.svg",
                                height: 22.h,
                                width: 22.w,
                                fit: BoxFit.scaleDown)
                        )
                    ),
                    Spacer(),
                    GestureDetector(
                        onTap: () async {
                          int response = await Get.bottomSheet(DeleteOption(
                              title: "stock",
                              productName: mockData.productName));
                          if (response == 1) {
                            _controllerInventory.deleteInventory(
                                mockData.id, mockData.productName);
                          }
                        },
                        child: Container(
                          width: 34.w,
                          height: 34.h,
                          decoration: BoxDecoration(
                              color: kLightPinkPin.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(7.r)),
                          child: SvgPicture.asset(
                            "assets/trash.svg",
                            fit: BoxFit.scaleDown,
                          ),
                        )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}

Image getImageNetwork(String image,) {
  print(image.isEmpty);
  if (image.isNotEmpty) {
    return Image.network(image,
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
      print("testing");
      Fluttertoast.showToast(msg: "Profile image failed to load");
        return Image.asset(
          'assets/pCircle.png',
        fit: BoxFit.fill,
        );
      },
      fit: BoxFit.fill,
    );
  } else {
    return const Image(
      image: AssetImage('assets/pCircle.png'),
      fit: BoxFit.fill,
    );
  }
}


Widget saleSeletedDesign(SaleCreateItem mockData,
    {int quantity = 0,
      int? qtyList = 0,
      int index = 0,
      dynamic deleteItem,
      dynamic updateItem}) {
  // var date = formatDate(
  //  (DateTime.now()).toLocal(), [dd,'/',mm,'/',yy,' ',h,':',nn,'',am],);
  return Container(
    height: 98.h,
    width: double.infinity,
    child: Row(
      children: [
        Container(
          margin: EdgeInsets.only(
            left: 15.w,
          ),
          height: 40.h,
          width: 40.w,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: getImageNetwork((mockData.data.productImage != null)
                      ? (mockData.data.productImage != null)
                      ? mockData.data.productImage
                      : ""
                      : ""
                    // ""
                  )
                      .image,
                  fit: BoxFit.fill),
              shape: BoxShape.circle),
        ),
        Container(
          width: 340.w,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 250.w,
                  height: 60.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.w, right: 8.h),
                        child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customText1(
                                (mockData.data.productName.length>10)?
                                mockData.data.productName.replaceRange(10,
                                    mockData.data.productName.length, "..."):
                                mockData.data.productName, kBlackB800, 18.sp,
                                fontWeight: FontWeight.w500),
                          ],
                        ),
                      ),
                     Spacer(),
                      Padding(
                        padding: EdgeInsets.only(left: 8.w, right: 8.w),
                        child: Container(
                          //  width: double.infinity,
                          child: (mockData.hasQty && qtyList != null)
                              ? customTextnaira(
                              "${NumberFormat.simpleCurrency(name: 'NGN')
                                  .format(double.parse(
                                  (qtyList! * mockData.data.sellingPrice)
                                      .toString())).split(".")[0]} = $qtyList x "
                                  "${NumberFormat.simpleCurrency(name: 'NGN')
                                  .format(mockData.data.sellingPrice)
                                  .split(".")[0]}",
                              kAppBlue,
                              18.sp,
                              maxLines: 2)
                              : customTextnaira(
                            " ${NumberFormat.simpleCurrency(name: 'NGN')
                                .format(double.parse(
                                (quantity! * mockData.data.sellingPrice)
                                    .toString()))
                                .split(".")[0]} = $quantity x "
                                "${NumberFormat.simpleCurrency(name: 'NGN')
                                .format(mockData.data.sellingPrice)
                                .split(".")[0]}",
                            kAppBlue,
                            18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 90.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: updateItem,
                        child: Container(
                          height: 40.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                              color: kLightPink.withOpacity(0.5),
                              borderRadius:
                              BorderRadius.all(Radius.circular(8.r))),
                          child: SvgPicture.asset(
                            "assets/Vector.svg",
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                      // gapWeight(12.w),
                      GestureDetector(
                          onTap: deleteItem,
                          child: Container(
                              height: 40.h,
                              width: 40.w,
                              decoration: BoxDecoration(
                                  color: kLightPink.withOpacity(0.5),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8.r))),
                              child: SvgPicture.asset(
                                "assets/trash.svg",
                                fit: BoxFit.scaleDown,
                              ))),
                    ],
                  ),
                )
              ]),
        )
      ],
    ),
  );
}

Widget saleDetailSeveralItemDesign(SalesItemInfo mockData,
    {int quantity = 0,
      int? qtyList = 0,
      int index = 0,
      dynamic deleteItem,
      dynamic updateItem,
      required String payment}) {
  return Container(
    height: 98.h,
    width: double.infinity,
    child: Row(
      children: [
        Align(
          alignment:Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(
              left: 15.w,
            ),
            height: 40.h,
            width: 40.w,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: getImageNetwork((mockData.productImage != null)
                        ? (mockData.productImage != null)
                        ? mockData.productImage
                        : ""
                        : ""
                      // ""
                    )
                        .image,
                    fit: BoxFit.fill),
                shape: BoxShape.circle),
          ),
        ),
        Container(
          width: 340.w,
          child: Padding(
            padding: EdgeInsets.only(left: 15.w,),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    width: 200.w,
                   height: 100.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8.w, right: 8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText1((mockData.productName.length>10)?
                              "${mockData.productName.replaceRange(10, mockData.productName.length,
                                  "...")}":
                              mockData.productName, kBlackB800, 18.sp,
                                  fontWeight: FontWeight.w500),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          //  width: double.infinity,
                          child: customTextnaira(
                            " ${NumberFormat.simpleCurrency(name: 'NGN').format(
                                double.parse((mockData!.quantity
                                    * mockData.sellingPrice).toString())).split(
                                ".")[0]} = "
                                "${mockData!.quantity} x "
                                "${NumberFormat.simpleCurrency(name: 'NGN').
                            format(mockData.sellingPrice).split(".")[0]}",
                            kAppBlue,
                            18.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: (payment=="Paid")?false:true,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      width: 90.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: updateItem,
                            child: Image.asset(
                              "assets/rename.png",
                             height: 30.h,
                              width: 30.h,
                              scale: 4,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          // gapWeight(12.w),
                         GestureDetector(
                              onTap: deleteItem,
                              child: Image.asset(
                                "assets/Page-1.png",
                                height: 30.h,
                                width: 30.h,
                                scale: 4,
                                fit: BoxFit.scaleDown,
                              )),
                        ],
                      ),
                    ),
                  )
                ]),
          ),
        )
      ],
    ),
  );
}


Widget saleDetailSeveralItemDesignOrder(OrderItems mockData,
    {int quantity = 0,
      int? qtyList = 0,
      int index = 0,}) {
  return Container(
    height: 60.h,
    width: double.infinity,
   //color: Colors.green,
    child: Row(
      children: [
        Container(
          // margin: EdgeInsets.only(
          //   left: 15.w,
          // ),
          height: 30.h,
          width: 30.w,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: getImageNetwork((mockData.productImage != null)
                      ? (mockData.productImage != null)
                      ? mockData.productImage
                      : ""
                      : ""
                    // ""
                  )
                      .image,
                  fit: BoxFit.fill),
              shape: BoxShape.circle),
        ),
        gapWeight(10.w),
        Container(
          width: 328.w,
          height: 30.h,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
           // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: customText1((mockData.productName.length>10)?
                "${mockData.productName.replaceRange(10, mockData.productName.length,
                    "...")}":
                    mockData.productName, kBlack, 16.sp,

                    fontWeight: FontWeight.w500),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  //  width: double.infinity,
                  child: customTextnaira(
                    " ${NumberFormat.simpleCurrency(name: 'NGN').format(
                        double.parse((mockData!.quantity
                            * mockData.sellingPrice).toString())).split(
                        ".")[0]} = "
                        "${mockData!.quantity} x "
                        "${NumberFormat.simpleCurrency(name: 'NGN').
                    format(mockData.sellingPrice).split(".")[0]}",
                    kAppBlue,
                    14.sp,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

String paymentStatusIntToString(int value){
  switch (value){
    case 0:
      return "Unpaid";
    case 1:
      return "Pending";
    case 2:
      return "Paid";
    default:
      return "Unpaid";
  }
}

String orderPaymentStatusIntToString(int value){
  switch (value){
    case 0:
      return "Unpaid";
    case 1:
      return "Pending";
    case 2:
      return "Paid";
    default:
      return "Unpaid";
  }
}

int orderPaymentStatusStringToInt(String value) {
  switch (value) {
    case 'Paid':
      return 1;
    case 'Unpaid':
      return 0;
    case 'Notpaid':
      return 0;
    case 'Pending':
      return 2;
    default:
      return 0;
  }
}

int paymentStatusStringToInt(String value) {
  switch (value) {
    case 'Paid':
      return 1;
    case 'Unpaid':
      return 0;
    case 'Notpaid':
      return 0;
    case 'Pending':
      return 2;
    default:
      return 0;
  }
}

Widget editSaleSelectedDesign(SalesItemInfo mockData, InventoryInfo? info,
    {int quantity = 0, int qtyList = 0, String category = "Box",
      int paymentStatus = 0}) {
  print(info?.productImage);
  var date = formatDate(
    (DateTime.now()).toLocal(),
    [dd, '/', mm, '/', yy, ' ', h, ':', nn, '', am],
  );
  return Container(
    height: 108.h,
    width: double.infinity,
    child: Row(
      children: [
        Container(
          margin: EdgeInsets.only(
            left: 15.w,
          ),
          height: 40.h,
          width: 40.w,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: getImageNetwork((info != null)
                      ? (info.productImage != null)
                      ? info.productImage
                      : ""
                      : (mockData.productImage == null ||
                      mockData.productImage.isEmpty)
                      ? ""
                      : mockData.productImage
                    // ""
                  )
                      .image,
                  fit: BoxFit.fill),
              shape: BoxShape.circle),
        ),
        Container(
          width: 340.w,
          child: Padding(
            padding: EdgeInsets.only(
                left: 15.w, top: 30.h, bottom: 8.h, right: 15.h),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 200.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8.w, right: 8.h),
                          child: customText1(
                              (info != null)
                                  ? truncateText(info.productName,10)
                                  : truncateText(mockData.productName, 10),
                              kBlackB800,
                              18.sp,
                              fontWeight: FontWeight.w500),
                        ),
                       Spacer(),
                        Padding(
                          padding: EdgeInsets.only(left: 8.w, right: 8.w),
                          child: Container(
                            //  width: double.infinity,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    customText1(
                                        quantity.toString(), kBlackB600, 14.sp,
                                        fontWeight: FontWeight.w400),
                                    gapWeight(4.w),
                                    customText1(
                                        mockData.productCategory.toString(),
                                        kBlackB600,
                                        14.sp,
                                        fontWeight: FontWeight.w400),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 110.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        paymentStatusDesignId(paymentStatus),
                      Spacer(),
                        customTextnaira(
                            NumberFormat.simpleCurrency(name: 'NGN')
                                .format(
                                (info == null)
                                ? double.parse((quantity * mockData.sellingPrice).toString())
                                : double.parse((quantity * info.sellingPrice).toString())
                            )
                                .split(".")[0],
                            kAppBlue,
                            18.sp,
                            fontWeight: FontWeight.w400),

                      ],
                    ),
                  )
                ]),
          ),
        )
      ],
    ),
  );
}

Widget viewOrderListDesign(OrderItems mockData,
    {int quantity = 0, int qtyList = 0, String category = "Box",
      int paymentStatus = 0}) {

  var date = formatDate(
    (DateTime.now()).toLocal(),
    [dd, '/', mm, '/', yy, ' ', h, ':', nn, '', am],
  );
  return Container(
    height: 100.h,
    width: double.infinity,
    child: Row(
      children: [
        Container(
          margin: EdgeInsets.only(
            left: 15.w,
          ),
          height: 40.h,
          width: 40.w,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: getImageNetwork((mockData != null)
                      ? (mockData.productImage != null)
                      ? mockData.productImage
                      : ""
                      : (mockData.productImage == null ||
                      mockData.productImage.isEmpty)
                      ? ""
                      : mockData.productImage
                    // ""
                  )
                      .image,
                  fit: BoxFit.fill),
              shape: BoxShape.circle),
        ),
        Container(
          width: 340.w,
          child: Padding(
            padding: EdgeInsets.only(
                left: 15.w, top: 30.h, bottom: 4.h, right: 15.h),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 200.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8.w, right: 8.h),
                          child: customText1(
                              (mockData != null)
                                  ? truncateText(mockData.productName,10)
                                  : truncateText(mockData.productName, 10),
                              kBlackB800,
                              18.sp,
                              fontWeight: FontWeight.w500),
                        ),
                        gapHeight(15.h),
                        Padding(
                          padding: EdgeInsets.only(left: 8.w, right: 8.w),
                          child: Container(
                            //  width: double.infinity,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    customText1(
                                        mockData.quantity.toString(), kBlackB600, 14.sp,
                                        fontWeight: FontWeight.w400),
                                    gapWeight(4.w),
                                    customText1(

                                        mockData.name.toString(),
                                        kBlackB600,
                                        14.sp,
                                        fontWeight: FontWeight.w400),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 110.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        paymentStatusDesignId(paymentStatus),
                        gapHeight(10.h),
                        customTextnaira(
                            NumberFormat.simpleCurrency(name: 'NGN')
                                .format(
                                double.parse((mockData.quantity * mockData.sellingPrice).toString())
                            )
                                .split(".")[0],
                            kAppBlue,
                            18.sp,
                            fontWeight: FontWeight.w400),
                        Container()
                      ],
                    ),
                  )
                ]),
          ),
        )
      ],
    ),
  );
}


Widget paymentStatusDesign(String status) {
  switch (status) {
    case 'Paid':
      return paymentStatuDesignColor(status, kPaidColor, 'assets/paid.png');
    case 'Accepted':
      return paymentStatuDesignColor(status, kPaidColor, 'assets/paid.png');
    case 'NotPaid':
      return paymentStatuDesignColor(
          "Not Paid", kUnpaidColor, 'assets/cancelled.png');
      case 'Rejected':
      return paymentStatuDesignColor(
          "Rejected", kUnpaidColor, 'assets/cancelled.png');
    case 'Unpaid':
      return paymentStatuDesignColor(
          status, kUnpaidColor, 'assets/cancelled.png');
    case 'Pending':
      return paymentStatuDesignColor(
          status, kPendingColor, 'assets/pending.png');
    case 'Processing':
      return paymentStatuDesignColor(
          "Pending", kPendingColor, 'assets/pending.png');
    default:
      return SizedBox();
  }
}

Widget paymentStatusDesign2(String status) {
  switch (status) {
    case 'Paid':
      return paymentStatuDesignColor2(status, kPaidColor, 'assets/paid.png');
    case 'NotPaid':
      return paymentStatuDesignColor2(
          "Not Paid", kUnpaidColor, 'assets/cancelled.png');
    case 'Unpaid':
      return paymentStatuDesignColor2(
          status, kUnpaidColor, 'assets/cancelled.png');
    case 'Pending':
      return paymentStatuDesignColor2(
          status, kPendingColor, 'assets/pending.png');
    case 'Processing':
      return paymentStatuDesignColor2(
          "Pending", kPendingColor, 'assets/pending.png');
    default:
      return SizedBox();
  }
}


var _controllerProduct = Get.put(AddNewProductController());

Future<int> productCategoryId(String name) async {
  int id = 0;
  // productUnitCategoryList
  if (productCategoryList.isEmpty) {
    await _controllerProduct.allProductCategoryList();
  }
  for (var element in productCategoryList) {
    print(element.name);
    if (element.name.toLowerCase() == name.toLowerCase()) {
      // print("hshhs");
      id = element.id;
      break;
    }
    //return id;
  }
  return id;
}

Future<int> productUnitCategoryId(String name) async {
  int id = 0;
  print(name);
  //
  if (productUnitCategoryList.isEmpty) {
    await _controllerProduct.allProductUnitCategoryList();
  }
  for (var element in productUnitCategoryList) {
    print(element.name);
    if (element.name.toLowerCase() == name.toLowerCase()) {
      print("hshhs");
      id = element.id;
      break;
    }
    //return id;
  }
  return id;
}

Widget paymentStatusDesignId(int status) {
  print(status);
  switch (status) {
    case 1:
      return paymentStatuDesignColor("Paid", kPaidColor, 'assets/paid.png');
    case 0:
      return paymentStatuDesignColor(
          "Unpaid", kUnpaidColor, 'assets/cancelled.png');
    case 2:
      return paymentStatuDesignColor(
          "Pending", kPendingColor, 'assets/pending.png');

    default:
      return SizedBox();
  }
}

Widget orderPaymentStatusDesignId(int status) {
  print(status);
  switch (status) {
    case 1:
      return paymentStatuDesignColor("Paid", kPaidColor, 'assets/paid.png');
    case 0:
      return paymentStatuDesignColor(
          "Unpaid", kUnpaidColor, 'assets/cancelled.png');
    case 2:
      return paymentStatuDesignColor(
          "Pending", kPendingColor, 'assets/pending.png');

    default:
      return SizedBox();
  }
}

Container paymentStatuDesignColor2(String status, color, String assetName) {
  return Container(
      padding: EdgeInsets.only(left: 6.w, right: 6.w),
      constraints: BoxConstraints.tight(Size(setSize2(status), 38.h)),
      height: 38.h,
     width: setSize2(status),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(8.21.r)),
      child: Row(

        children: [
          Image.asset(assetName,
              height: 20.h,
              width: 20.w,
              fit: BoxFit.contain),
          Gap(2),
          customText1(status, kBlackB800, 14.sp, fontWeight: FontWeight.w400),
        ],
      ));
}

Container paymentStatuDesignColor(String status, color, String assetName) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal:3.5.w, vertical: 4.11.h),
      width: setSize(status),
   //  height: 23.h,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(8.r)),
      child: SingleChildScrollView(
        child: Row(
          children: [
            Image.asset(assetName,
              height: 20.h,
              width: 20.w,
              fit: BoxFit.contain),
            Gap(2),
            customText1(status, kBlackB800, 13.sp, fontWeight: FontWeight.w300),
          ],
        ),
      ));
}

Container orderStatuDesignColor(String status, color, String assetName) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 4.11.h),
      //width: setSize(status),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(8.r)),
      child: SingleChildScrollView(
        child: Row(
          children: [
            Image.asset(assetName,
                height: 20.h,
                width: 20.w,
                fit: BoxFit.contain),
            Gap(2),
            customText1(status, kBlackB800, 14.sp, fontWeight: FontWeight.w300),
          ],
        ),
      ));
}

double setSize(String status) {
  switch (status) {
    case 'Paid':
      return 70.43.w;
      break;
    case 'Unpaid':
      return 89.43.w;
      break;
    case 'Pending':
      return 90.43.w;
      break;
    case 'Not Paid':
      return 101.w;
      break;
    default:
      return 107.43.w;
      break;
  }
}

double setSize2(String status) {
  switch (status) {
    case 'Paid':
      return 75.43.w;
      break;
    case 'Unpaid':
      return 91.43.w;
      break;
    case 'Pending':
      return 95.43.w;
      break;
    case 'Not Paid':
      return 106.w;
      break;
    default:
      return 67.43.w;
      break;
  }
}

Widget textInputCalendar(TextEditingController controller,
    {TextInputType textInput = TextInputType.text,
      String hintText = "",
      DateTime? dateTime}) {
  // controller.text =
  // dateTime != null ? DateFormat('dd-MMMM-yyyy').format(dateTime) : '';
  return TextFormField(
    readOnly: true,
    onChanged: (value) {
      if (value.length == 2 || value.length >= 6) {
        value = '$value-';
        // _dosyaNo.value = TextEditingValue(text:
        // value,selection: TextSelection.collapsed(offset:
        // value.length),);
      }
    },
    decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            borderSide: BorderSide(
              color: kBlack,
            )),
        labelText: hintText,
        labelStyle: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.sp,
            fontFamily: fontFamilyInter)),
    controller: controller,
    style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontFamily: 'inter regular',
        fontSize: 16.sp),
  );
}

Widget textInputBorder(TextEditingController controller, {
  TextInputType textInput = TextInputType.text,
  String hintText = "",
}) {
  return TextFormField(
    readOnly: true,
    decoration: InputDecoration(
        suffixIcon: Icon(Icons.keyboard_arrow_down_sharp),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            borderSide: BorderSide(
              color: kBlack,
            )),
        labelText: hintText,
        labelStyle: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.sp,
            fontFamily: "inter regular")),
    controller: controller,
    style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontFamily: 'inter regular',
        fontSize: 16.sp),
  );
}

Widget textFieldBorderWidgetPD(Widget widget, String title) {
  return FormField<String>(
    builder: (FormFieldState<String> state) {
      return InputDecorator(
        decoration: InputDecoration(
         contentPadding: EdgeInsets.fromLTRB(12.w, 10.h, 20.w, 10.h),
          labelText: title,
          labelStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontFamily: 'inter regular',
              fontSize: 18.sp),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kAppBlue),
            borderRadius: BorderRadius.circular(10.r),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide(color: Colors.amberAccent)),
        ),
        child: widget,
      );
    },
  );
}
Widget textFieldBorderWidget(Widget widget, String title) {
  return FormField<String>(
    builder: (FormFieldState<String> state) {
      return InputDecorator(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(12.w, 10.h, 20.w, 10.h),
          labelText: title,
          labelStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontFamily: 'inter regular',
              fontSize: 18.sp),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kAppBlue),
            borderRadius: BorderRadius.circular(10.r),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide(color: Colors.amberAccent)),
        ),
        child: widget,
      );
    },
  );
}
//kjkgkj
Widget textFieldBorderWidget2(Widget widget, String title) {
  return InputDecorator(

    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      labelText: title,
      labelStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontFamily: 'inter regular',
          fontSize: 18.sp),
      enabledBorder: OutlineInputBorder(
        gapPadding: 2,
        borderSide: BorderSide(color: kAppBlue),
        borderRadius: BorderRadius.circular(10.r),
      ),
    ),
    child: widget,
  );
}

//String _bankChoose;

Widget emptyOrder(String title, onTap,
    {String image = "assets/emptySales.svg",
      header= "",
      headerDetail=""
    }) {
  return SingleChildScrollView(
    child: Column(
      children: [
        gapHeight(59.71.h),
        Center(child: SvgPicture.asset(image,)),
        gapHeight(40.4.h),
        Center(
            child: Column(
              children: [
                customText1(header,
                    kBlack, 18.sp, fontWeight: FontWeight.w400),
                gapHeight(10.h),
                customText1(headerDetail, kBlack.withOpacity(0.6), 14.sp)
              ],
            )
        ),
      ],
    ),
  );
}

Widget emptyPart(String title, onTap,
    {String image = "assets/emptySales.svg",
        header= "",
     headerDetail=""
    }) {
  return SingleChildScrollView(
    child: Center(
      child: Container(
        height: 450.h,
        width: 381.w,
        child: Column(
          children: [
            Gap(30),
            Center(child: SvgPicture.asset(image,
            height: 174.19.h,
            width: 200.w,)),
            Gap(30),
            Center(
              child: Column(
                children: [
                  customText1(header,
                      kBlack, 18.sp, fontWeight: FontWeight.w400),
                  Gap(10),
                  customText1(headerDetail, kBlack.withOpacity(0.6), 14.sp,
                  fontFamily: fontFamily,
                  indent: TextAlign.center,
                  maxLines: 2)
                ],
              )
            ),
           Spacer(),
            GestureDetector(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.only(left: 16.w,right: 16.w),
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: kAppBlue,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Center(
                    child: customText1(
                        "Add new ${title.toLowerCase()}", kDashboardColorBorder, 16.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget quickSearchRow(String title, onTap, {bool isTap = false}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
      height: 38.h,
     width: searchWidth(title.length),
      decoration: BoxDecoration(
          color: kCalendarLightPink,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
              color: isTap ? kAppBlue : kCalendarLightPink, width: 0.5.w)),
      child: Align(
        alignment: Alignment.center,
        child: customText1(title, isTap ? kAppBlue : kBlack, 14.sp),
      ),
    ),
  );
}

double searchWidth(int titleLength) {
  switch (titleLength) {
    case 3:
      return 40.w;
    case 8:
      return 78.w;
    case 7:
      return 78.w;
    case 9:
      return 90.w;
    case 10:
      return 100.w;
    case 11:
      return 100.w;
    case 13:
      return 130.w;
    case 15:
      return 140.w;
    default:
      return 70.w;
  }
}

class SwitchDesign extends StatefulWidget {
  bool isSwitched;
  int productId = 0;
  final Function(bool) onChamge;

  SwitchDesign({Key? key, required this.isSwitched, required this.productId, required this.onChamge})
      : super(key: key);

  @override
  State<SwitchDesign> createState() => _SwitchDesignState();
}

class _SwitchDesignState extends State<SwitchDesign> {
  var _controllerCatalog = Get.put(CatalogueController());
  bool isSwitched = false;
  bool initialValue=false;
  @override
  void initState() {
    isSwitched = widget.isSwitched;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45.w,
      height: 25.h,
      decoration: BoxDecoration(
        color: isSwitched ? kAppBlue : kInactiveLightPinkSwitch,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Switch(
        value: isSwitched,
        onChanged:widget.onChamge,
        inactiveTrackColor: kInactiveLightPinkSwitch,
        dragStartBehavior: DragStartBehavior.down,
        activeTrackColor: kAppBlue,
        activeColor: kLightPink,
        inactiveThumbColor: kInactiveLightPinkSwitchBu,
      ),
    );
  }
}


//
// Widget showLoader(bool isLoading){
//   return OverlayLoaderWithAppIcon(
//       isLoading: isLoading,
//
//       appIcon: Image.asset("assets/smerp_dev"));
// }
