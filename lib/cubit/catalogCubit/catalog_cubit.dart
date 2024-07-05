import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smerp_go/apiServiceLayer/api_status.dart';

import '../../controller/catalogueController.dart';
import '../../model/response/defaultApiResponse.dart';
import '../../model/response/inventoryList.dart';
import '../../utils/AppUtils.dart';


part 'catalog_state.dart';

class CatalogCubit extends Cubit<CatalogState> {


  CatalogCubit() :super(CatalogInitial())  {
    // initUuid();
  }
  var controller = Get.put(CatalogueController());
  void updateAllCatalogPublishCubit(bool isVisible,int category) async {
    try {
      emit(ApiLoadingState() );
      final response = await controller.updateCatalogAllProductCata(isVisible, category);
      if (response == true ) {
        emit(CatalogUpdateAllProductFetchSuccessState(response));
        AppUtils.debug("success cubit");
      }else{
        emit(CatalogErrorState(response));
        AppUtils.debug("cubit response not successfully fetched");
      }
    } catch (e) {
      emit(CatalogErrorState(false));
      AppUtils.debug("cubit response error caught");
    }
  }

  void resetState() {
    // emit(PaymentManagementInitial());
  }
}