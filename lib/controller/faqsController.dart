import 'package:get/get.dart';
import 'package:smerp_go/utils/app_services/helperClass.dart';

class FaqsController extends GetxController{
  RxBool isAll = false.obs;
  RxBool  isAccount= false.obs;
  RxBool isLostPassword = false.obs;
  RxBool isSales = false.obs;

  bool checkIfEnabled(SearchFaqs type) {
    switch (type) {
      case SearchFaqs.all:
        {
          isAccount.value = false;
          isLostPassword.value = false;
          isSales.value = false;

          return isAll.value = true;
        }
        break;
      case SearchFaqs.account:
        {
          isAll.value = false;
          isLostPassword.value = false;
          isSales.value = false;
          return isAccount.value = true;
        }
        break;
      case SearchFaqs.lostPassword:
        {
          isAll.value = false;
          isSales.value = false;
          isAccount.value = false;
          return isLostPassword.value = true;
        }
        break;
      case SearchFaqs.sales:
        {
          isAll.value = false;
          isAccount.value = false;
          isLostPassword.value = false;

          return isSales.value = true;
        }
        break;
    }
  }

  }