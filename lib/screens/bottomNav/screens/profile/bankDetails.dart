import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smerp_go/cubit/bankDetail/bank_details_cubit.dart';
import 'package:smerp_go/screens/bottomsheets/list_of_banks.dart';
import 'package:smerp_go/utils/AppUtils.dart';

import '../../../../model/request/bankDetails.dart';
import '../../../../model/response/bankDetail.dart';
import '../../../../utils/appColors.dart';
import '../../../../utils/appDesignUtil.dart';
import '../../../../utils/downloadAsImage.dart';
import '../../../../utils/reportUiKit.dart';

class BankDetails extends StatefulWidget {
  final BankDetailReponse response;

  const BankDetails({required this.response, super.key});

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  TextEditingController bankName = TextEditingController();
  TextEditingController acctNum = TextEditingController();
  TextEditingController acctName = TextEditingController();
  var isEdit = RxBool(false);
  late BankDetailsCubit cubit;
  @override
  void initState() {
    bankName.text = widget.response.bankName ?? "";
    acctName.text = widget.response.accountName ?? "";
    acctNum.text = widget.response.accountNumber ?? "";
    if (widget.response != null) {
      isEdit.value = false;
    } else {
      isEdit.value = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cubit= context.read<BankDetailsCubit>();
    return bloc.BlocBuilder<BankDetailsCubit, BankDetailsState>(
      builder: (context, state) {
        if (state is BankDetailErrorState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.delayed(Duration.zero, () {
              showToast(state.errorResponse.message);
              // showOrderHistory(message: state.errorResponse.message);
            });
          });
          cubit.resetState();
        }
        if (state is CreateBankDetailSuccessState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.delayed(Duration.zero, () {
              // FirebaseAnalytics.instance.logEvent(
              //   name: trackedPagesAndActions[4],
              //   parameters: <String, dynamic>{
              //     'string_parameter': 'Report Downloaded',
              //     'int_parameter': 4,
              //   },
              // );
              Get.bottomSheet(
                  backgroundColor: kWhite,
                  SuccessResponse(msg: state.response.message!,)).whenComplete(() {
                    isEdit.value=false;

              });
            });
          });
          cubit.resetState();
        }
        return Obx(() {
          return overLay(
              Scaffold(
                backgroundColor: kWhite,
                appBar: PreferredSize(
                    child: defaultDashboardAppBarWidget(() {
                      Get.back();
                    }, "Bank detail", context: context),
                    preferredSize: Size.fromHeight(80.h)),
                body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      Gap(20),
                      GestureDetector(
                        onTap: () async {
                          var response = await Get.bottomSheet(
                              ListOfBanks()
                          );
                          if (response != null) {
                            setState(() {
                              //  var paymentStatus =response;
                              bankName.text = response[0];

                            });
                          }
                        },
                        child: Container(
                          height: 65.h,
                         child: textFieldBorderWidget2(
                             Row(
                               mainAxisAlignment: MainAxisAlignment
                                   .spaceBetween,
                               children: [
                                 customText1(bankName.text,
                                     kBlack, 16.sp),
                                 const Icon(Icons.keyboard_arrow_down)
                               ],
                             ), "Bank name"),
                          // titleSignUp(bankName,
                          //     textInput: TextInputType.text,
                          //     hintText: "Bank name",
                          //     readOnly:  true
                          // ),
                        ),
                      ),
                      gapHeight(15),
                      Container(
                        height: 65.h,
                        child: titleSignUp(acctNum,
                            textInput: TextInputType.text,
                            hintText: "Account Number",
                            readOnly: (isEdit.value) ? false : true
                        ),
                      ),
                      gapHeight(15),
                      Container(
                        height: 65.h,
                        child: titleSignUp(acctName,
                            textInput: TextInputType.text,
                            hintText: "Account name",
                            readOnly: (isEdit.value) ? false : true
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          String? acctName;
                          String? bankName;
                          String? acctNum;
                          if(isEdit.isFalse){
                            setState(() {
                              isEdit.value=true;
                            });
                          }else{
                            acctName= this.acctName.text??"";
                            bankName=this.bankName.text??"";
                            acctNum=this.acctNum.text??"";
                            if(acctNum.isEmpty||bankName.isEmpty||acctName.isEmpty){
                              showToast("No field should be Empty");
                            }else if(acctNum.length>10||acctNum.length<10){
                              showToast("Invalid Account Number");
                            }else if(!acctNum.isNumericOnly){
                              showToast("Invalid Account Number Format");
                            }else{
                              cubit.createBankDetail(
                                  StoreBankDetail(actionBy: loginData!.userId,
                                    actionOn: DateTime.now(),
                                    bankName: bankName,
                                    accountName: acctName,
                                    accountNo: acctNum
                                  )
                              );
                            }
                          }
                        },
                        child: Container(
                          height: 60.h,

                          decoration: BoxDecoration(
                            color: kAppBlue,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Center(
                              child: customText1(
                                  (isEdit.value) ? "Update Bank Detail" :
                                  "Edit Bank Detail", kWhite, 18.sp)
                          ),
                        ),
                      ),
                      Gap(30)
                    ],
                  ),
                ),
              ),
              isLoading: state is BankDetailLoadingState
          );
        });
      });
  }
}
