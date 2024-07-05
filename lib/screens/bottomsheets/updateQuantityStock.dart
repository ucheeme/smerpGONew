import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smerp_go/controller/addNewProduct.dart';

import '../../controller/inventoryController.dart';
import '../../utils/AppUtils.dart';
import '../../utils/appColors.dart';
import '../../utils/appDesignUtil.dart';

class UpdateInventoryStock extends StatefulWidget {
  int productId;

  UpdateInventoryStock({super.key, required this.productId});

  @override
  State<UpdateInventoryStock> createState() => _UpdateInventoryStockState();
}

class _UpdateInventoryStockState extends State<UpdateInventoryStock> with WidgetsBindingObserver {
  var _controller = Get.put(InventoryController());
  var quantity = TextEditingController();
  RxBool isLoading =RxBool(false);

  FocusNode? _focusNode;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode?.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode?.removeListener(_onFocusChange);
    _focusNode?.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      isKeyboardOpen.value = _focusNode!.hasFocus;
    });
  }
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData =MediaQuery.of(context);
    return Obx(() {
      return overLay(
        GestureDetector(
          onTap: (){
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(

            resizeToAvoidBottomInset: false,

            body: Padding(
              padding: mediaQueryData.viewInsets,
              child: Container(
                height: 400.h,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: kLightPink,
                      height: 53.h,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.w),
                          child: customText1("Update stock", kBlack, 18.sp,
                            fontWeight: FontWeight.w500,fontFamily: fontFamily
                          ),
                        ),
                      ),
                    ),
                    gapHeight(25.h),
                    Container(
                      height: 60.h,
                      child: titleSignUp(quantity,
                          textInput: TextInputType.number,
                          hintText: "Enter quantity",
                        focus:  _focusNode,
                      ),
                    ),
                    gapHeight(50.h),
                    GestureDetector(
                      onTap: () async {
                        if(quantity.text==null||quantity.text.isEmpty||
                            !quantity.text.isNumericOnly){
                          Get.snackbar("Error", "Please enter an actual number",
                            backgroundColor: Colors.red,
                            snackPosition: SnackPosition.BOTTOM,);
                        }else{
                          Get.snackbar("Updating product",
                              "Please wait..",
                              snackStyle: SnackStyle.FLOATING,
                              showProgressIndicator: true,
                              borderRadius: 8.r,
                              overlayBlur: 2,
                              isDismissible: false,
                              backgroundColor: kWhite,
                              snackPosition: SnackPosition.TOP);
                          var quant = int.tryParse(quantity.text);
                          var res= await _controller.updateInventoryStock(quant!, widget.productId,
                              isLoading
                          );
                          if(res){
                            Get.back();
                            Navigator.pop(context);
                          }
                        }

                      },
                      child: Padding(
                        padding:  EdgeInsets.only(left: 15.h,right: 15.h),
                        child: dynamicContainer(Center(
                            child: customText1(
                              //     (_controller.isDone.value) ?
                              // "Create sale" : "Done",
                                "Update stock",
                                kWhite, 18.sp)),
                            kAppBlue, 60.h,
                            width: double.infinity),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        isLoading: isLoading.value
      );
    });
  }
}
