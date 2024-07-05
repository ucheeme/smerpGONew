import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smerp_go/model/response/defaultApiResponse.dart';
import 'package:smerp_go/utils/mockdata/tempData.dart';

import '../Reposistory/apiRepo.dart';
import '../apiServiceLayer/apiService.dart';
import '../apiServiceLayer/api_status.dart';
import '../model/response/catalogListResponse.dart';
import '../model/response/inventoryList.dart';
import '../utils/AppUtils.dart';
import '../utils/appUrl.dart';
import '../utils/app_services/helperClass.dart';

class CatalogueController extends GetxController{
  RxBool isAll = false.obs;
  RxBool isFashion = false.obs;
  RxBool isFood = false.obs;
  RxBool isElectronics = false.obs;
  RxBool isSport = false.obs;
  RxBool isGadgets = false.obs;
  RxBool isHealthBeauty = false.obs;
  RxBool isOther= false.obs;
  RxBool isLoading = false.obs;
  RxBool noProductVisible = false.obs;
  RxInt catalogChoiceId=0.obs;
  RxBool allProductVisible = RxBool(false);
  RxBool allFashionVisible = RxBool(false);
  RxBool allElectronicsVisible = RxBool(false);
  RxBool allSportVisible = RxBool(false);
  RxBool allGadgetsVisible = RxBool(false);
  RxBool allOtherVisible = RxBool(false);
  RxBool allHealthBeautyVisible = RxBool(false);
  RxBool allFoodVisible = RxBool(false);
  RxBool isUpdated  = RxBool(false);
  RxList<CatalogFull> catalogsF =[
    CatalogFull(InventoryInfo(id: 0,
     productName: '', productImage: '',
      productCategory: '',
      purchasePrice: 0.0,
      quantity: 0,
      sellingPrice: 0.0,
      unitCategory: '',
      createdBy: '',
        createdOn: DateTime.now(),
        updatedBy: '',
      timeStamp: DateTime.now()), false)].obs;
//  List<CatalogData

  List<CatalogFull> filterByName(String enteredValue){
    catalogsF.value = catalogsFTemp.where((element) =>
    element.catalogData.productName.toLowerCase().
    contains(enteredValue.toLowerCase())).toList();
    return catalogsF.value;
  }

  List<CatalogFull> filterByCategoryFilter(String enterValue,String filter
      ){
    catalogsF.value =catalogsFTemp;
    List<CatalogFull> result =[];
    if(enterValue.isEmpty){
    catalogsF.value =catalogsFTemp;
    }else{
      catalogsF.value =catalogsFTemp.where((element) =>
     element.catalogData.productCategory.toLowerCase()== enterValue.toLowerCase()).toList();
    }
    result = catalogsF.value.where((element) =>
    element.catalogData.productName.toLowerCase().contains(filter.toLowerCase())).toList();
    checkIfAllProductInCategoryIsVisible(catalogsF.value,enterValue);
    return catalogsF.value;
  }

  List<CatalogFull> filterByCategory(String enterValue,
      ){
    List<CatalogFull> result =[];

    if(enterValue.isEmpty){
      print("I am all catalog");
     catalogsF.value =catalogsFTemp;
     checkIfAllProductInCategoryIsVisible(catalogsF.value,enterValue);
     return catalogsF.value;
    }else{
      catalogsF.value =catalogsFTemp.where((element) =>
      element.catalogData.productCategory.toLowerCase()== enterValue.toLowerCase()).toList();
      checkIfAllProductInCategoryIsVisible(catalogsF.value,enterValue);
    return catalogsF.value;
    }
  }
  bool checkIfEnabled(SearchOptions type){
    switch(type){
      case SearchOptions.all:{
        isFashion.value=false;
        isFood.value=false;
        isElectronics.value=false;
        isSport.value=false;
        isGadgets.value = false;
        isOther.value = false;
        isHealthBeauty.value= false;
        catalogChoiceId.value=0;
       // catalogsF.value =catalogsFTemp;
        return isAll.value=true;
      }
      break;
      case SearchOptions.fashion:{
        isAll.value=false;
        isFood.value=false;
        isElectronics.value=false;
        isSport.value=false;
        isGadgets.value = false;
        isOther.value = false;
        isHealthBeauty.value= false;
        catalogChoiceId.value=1;
        catalogsF.value = catalogsFTemp.where((element) =>
        element.catalogData.productCategory=="Fashion").toList();
        return   isFashion.value=true;
      }
      break;
      case SearchOptions.food:{
        isAll.value=false;
        isFashion.value=false;
        isElectronics.value=false;
        isSport.value=false;
        isGadgets.value = false;
        isOther.value = false;
        isHealthBeauty.value= false;
        catalogChoiceId.value=2;
        catalogsF.value = catalogsFTemp.where((element) =>
        element.catalogData.productCategory=="Food").toList();
        return isFood.value=true;
      }
      break;
      case SearchOptions.electronics:{
        isAll.value=false;
        isFashion.value=false;
        isFood.value=false;
        isSport.value=false;
        isGadgets.value = false;
        isOther.value = false;
        isHealthBeauty.value= false;
        catalogChoiceId.value=3;
        catalogsF.value = catalogsFTemp.where((element) =>
        element.catalogData.productCategory=="Electronics").toList();
        return isElectronics.value=true;
      }
      break;
      case SearchOptions.sport:{
        isAll.value=false;
        isFashion.value=false;
        isFood.value=false;
        isElectronics.value=false;
        isGadgets.value = false;
        isOther.value = false;
        isHealthBeauty.value= false;
        catalogChoiceId.value=4;
        catalogsF.value = catalogsFTemp.where((element) =>
        element.catalogData.productCategory=="Sport").toList();
        return  isSport.value=true;
      }
      break;
      case SearchOptions.gadgets:{

        isAll.value=false;
        isFashion.value=false;
        isFood.value=false;
        isElectronics.value=false;
        isOther.value = false;
        isHealthBeauty.value = false;
        isSport.value = false;
        catalogChoiceId.value=5;
        catalogsF.value = catalogsFTemp.where((element) =>
        element.catalogData.productCategory=="Gadgets").toList();
        return  isGadgets.value=true;
    }
        break;
      case SearchOptions.healthBeauty:{

        isAll.value=false;
        isFashion.value=false;
        isFood.value=false;
        isElectronics.value=false;
        isOther.value = false;
        isGadgets.value = false;
        isSport.value = false;
        catalogChoiceId.value=6;
        catalogsF.value = catalogsFTemp.where((element) =>
        element.catalogData.productCategory=="Health & Beauty").toList();
        return  isHealthBeauty.value=true;
    }
        break;
      case SearchOptions.others:{
        isAll.value=false;
        isFashion.value=false;
        isFood.value=false;
        isElectronics.value=false;
        isGadgets.value = false;
        isHealthBeauty.value = false;
        isSport.value = false;
        catalogChoiceId.value=7;
        catalogsF.value = catalogsFTemp.where((element) =>
        element.catalogData.productCategory=="Other").toList();
        return  isOther.value=true;
      }
        break;
    }
  }
//cdfrdp
  bool getActiveChioce(String value){
    print(value);
    switch(value){
      case "":{
        catalogChoiceId.value=0;
        // catalogsF.value =catalogsFTemp;
        return isAll.value=true;
      }
      case "Fashion":{

        catalogChoiceId.value=1;
        catalogsF.value = catalogsFTemp.where((element) =>
        element.catalogData.productCategory=="Fashion").toList();
        return   isFashion.value=true;
      }
      break;
      case "Food":{

        catalogChoiceId.value=2;
        catalogsF.value = catalogsFTemp.where((element) =>
        element.catalogData.productCategory=="Food").toList();
        return isFood.value=true;
      }
      break;
      case "Electronics":{

        catalogChoiceId.value=3;
        catalogsF.value = catalogsFTemp.where((element) =>
        element.catalogData.productCategory=="Electronics").toList();
        return isElectronics.value=true;
      }
      break;
      case "Sport":{

        catalogChoiceId.value=4;
        catalogsF.value = catalogsFTemp.where((element) =>
        element.catalogData.productCategory=="Sport").toList();
        return  isSport.value=true;
      }
      break;
      case "Gadgets":{
        catalogsF.value = catalogsFTemp.where((element) =>
        element.catalogData.productCategory=="Gadgets").toList();
        return  isGadgets.value=true;
      }
      break;
      case "Health & Beauty":{
        catalogChoiceId.value=6;
        catalogsF.value = catalogsFTemp.where((element) =>
        element.catalogData.productCategory=="Health & Beauty").toList();
        return  isHealthBeauty.value=true;
      }
      break;
      case "Other":{

        catalogChoiceId.value=7;
        catalogsF.value = catalogsFTemp.where((element) =>
        element.catalogData.productCategory=="Other").toList();
        return  isOther.value=true;
      }
      break;
      default:{
        return false;
      }
      }

    }


  List<CatalogFull> result = [];

  Future<List<CatalogData>> allCatalogListAsShownToUsers({isRefresh=
  false,
    RefreshController? refreshController})async{
    (isRefresh) ?isLoading.value=false:
    isLoading.value = true;
  // catalogsF.clear();
    var response = await ApiService.makeApiCall(null,
        AppUrls().getCatalogListAsShownToUsers,
        method: HTTP_METHODS.get );
    if(response is Success){
      try{
        var data = catalogListResponseFromJson(await response.response as String);
        if(data.isSuccess && data.data != null){

          catalogListTemp= data.data!;
          isUpdated.value = true;
          if(data.data.isEmpty){
            noProductVisible.value= true;
            allCatalogListdisplayed(catalogListTemp);
            print(catalogsF.length);
          }else{
            allCatalogListdisplayed(catalogListTemp);
           noProductVisible.value=false;
          }
          isLoading.value = false;
          (isRefresh)?refreshController?.refreshCompleted():null;

          return data.data;
        }else{
         // catalogsF.value=allCatalogListdisplayed(catalogListTemp);
         // catalogsFTemp= catalogsF;
          isLoading.value = false;
          noProductVisible.value=false;

          return [];
        }
      }catch(e,trace){
        isLoading.value = false;
      // catalogsF.value= allCatalogListdisplayed(catalogListTemp);
        noProductVisible.value=false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        (isRefresh)?refreshController?.refreshFailed():null;
      }
    }else{
     isLoading.value = false;
      (isRefresh)?refreshController?.refreshFailed():null;
      var repo = ApiRepository();
    //  catalogsF.value= allCatalogListdisplayed(catalogListTemp);
      noProductVisible.value=false;
      repo.handleErrorResponse(response);
    }
   return [];
  }

  Future<bool> updateCatalogProductVisibility(bool isVisible, int prodId)
  async{
    var response = await ApiService.makeApiCall(null,
        AppUrls().updateCatalogProductRecord(prodId, isVisible),
       method: HTTP_METHODS.put );
    if(response is Success){
      try{
        var data = defaultApiResponseFromJson(await response.response as String);
        if(data.isSuccess){

          isLoading.value = false;
         // (isRefresh)?refreshController?.refreshCompleted():null;
          allCatalogListAsShownToUsers();
          return true;
        }else{
          isLoading.value = false;
         return false;
        }
      }catch(e,trace){
        isLoading.value = false;
      // allCatalogListdisplayed(catalogListTemp);
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        return false;
       // (isRefresh)?refreshController?.refreshFailed():null;
      }
    }else{
     // (isRefresh)?refreshController?.refreshFailed():null;
      var repo = ApiRepository();
     // catalogsF= allCatalogListdisplayed(catalogListTemp);
      repo.handleErrorResponse(response);
      return false;
    }
  }

  Future<bool> updateCatalogAllProduct(bool isVisible)
  async{
    isLoading.value= true;
    var response = await ApiService.makeApiCall(null,
        AppUrls().updateAllProductCatalogView( isVisible),
        method: HTTP_METHODS.put );
    if(response is Success){
      try{
        var data = defaultApiResponseFromJson(await response.response as String);
        if(data.isSuccess){

          isLoading.value = false;
          // (isRefresh)?refreshController?.refreshCompleted():null;
          await allCatalogListAsShownToUsers();
          return true;
        }else{
          isLoading.value = false;
          return false;
        }
      }catch(e,trace){
        isLoading.value = false;
        // allCatalogListdisplayed(catalogListTemp);
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        return false;
        // (isRefresh)?refreshController?.refreshFailed():null;
      }
    }else{
      // (isRefresh)?refreshController?.refreshFailed():null;
      var repo = ApiRepository();
      // catalogsF= allCatalogListdisplayed(catalogListTemp);
      repo.handleErrorResponse(response);
      return false;
    }
  }


  Future<bool> updateCatalogAllProductCata(bool isVisible,int category)
  async{
    isLoading.value= true;
    var response = await ApiService.makeApiCall(null,
        AppUrls().updateCatalogProductAtCategoryRecord( category,isVisible),
        method: HTTP_METHODS.put );
    if(response is Success){
      try{
        var data = defaultApiResponseFromJson(await response.response as String);
        if(data.isSuccess){

          isLoading.value = false;
          // (isRefresh)?refreshController?.refreshCompleted():null;
         await allCatalogListAsShownToUsers();
          return true;
        }else{
          isLoading.value = false;
          return false;
        }
      }catch(e,trace){
        isLoading.value = false;
        // allCatalogListdisplayed(catalogListTemp);
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        return false;
        // (isRefresh)?refreshController?.refreshFailed():null;
      }
    }else{
      // (isRefresh)?refreshController?.refreshFailed():null;
      var repo = ApiRepository();
      // catalogsF= allCatalogListdisplayed(catalogListTemp);
      repo.handleErrorResponse(response);
      return false;
    }
  }


  List<CatalogFull> allCatalogListdisplayed(List<CatalogData> data){
    print("the length of data ${data.length}");
    result.clear();
    catalogsFTemp.clear();
    if(data.isEmpty){
      for(var element in inventoryListTemp){
        catalogsFTemp.add(CatalogFull(element, false));
        result.add(CatalogFull(element, false));
      }
      print(result.length);
      return result;
    }else{
      print("the length of data not empty ${data.length}");
      for (var element in inventoryListTemp) {
        bool found = false;
        for (var p = 0; p < data.length; p++) {
          if (data[p].id == element.id) {
            found = true;
            break;
          }
        }

        print(found ? "added" : "not added");
        catalogsFTemp.add(CatalogFull(element, found));
        result.add(CatalogFull(element, found));
      }
      print(catalogsFTemp.length);
      return catalogsFTemp;
    }
    return result;
  }

  bool checkIfAllProductInCategoryIsVisible(List<CatalogFull> data, String category){

    switch (category){
     case "":{
       List<CatalogFull> res= data.where((element) => element.isVisible==false).toList();
       if(res.isEmpty){
         print("fghj");
         allProductVisible.value = true;
         return true;
       }else{
         allProductVisible.value = false;
         return false;
       }
      };
    case "Fashion":{
      return checkForProductNotVisible(data);
    };
      case "Food":{
        List<CatalogFull> res= data.where((element) => element.isVisible==false).toList();
        if(res.isEmpty){
          allFoodVisible.value = true;
          return true;
        }else{
          allFoodVisible.value = false;
          return false;
        }
      };
      case "Sport":{
        List<CatalogFull> res= data.where((element) => element.isVisible==false).toList();
        if(res.isEmpty){
          allSportVisible.value = true;
          return true;
        }else{
          allSportVisible.value = false;
          return false;
        }
      };
      case "Electronics":{
        List<CatalogFull> res= data.where((element) =>
        (element.isVisible==false)).toList();
        if(res.isEmpty){
          print("feell");
          allElectronicsVisible.value = true;
          return true;
        }else{
          print("no value");
          allElectronicsVisible.value = false;
          return false;
        }
      };
      case "Gadgets":{
        List<CatalogFull> res= data.where((element) => element.isVisible==false).toList();
        if(res.isEmpty){
          allGadgetsVisible.value = true;
          return true;
        }else{
          allGadgetsVisible.value = false;
          return false;
        }
      };
      case "Health & Beauty":{
        List<CatalogFull> res= data.where((element) => element.isVisible==false).toList();
        if(res.isEmpty){
          allHealthBeautyVisible.value = true;
          return true;
        }else{
          allHealthBeautyVisible.value = false;
          return false;
        }
      };
      case "Other":{
        List<CatalogFull> res= data.where((element) => element.isVisible==false).toList();
        if(res.isEmpty){
          allOtherVisible.value = true;
          return true;
        }else{
          allOtherVisible.value = false;
          return false;
        }
     };
    }
    return false;
  }

  bool checkForProductNotVisible(List<CatalogFull> data) {
      List<CatalogFull> res= data.where((element) => element.isVisible==false).toList();
        if(res.isEmpty){
       allFashionVisible.value = true;
        return true;
        }else{
       allFashionVisible.value = false;
        return false;
        }
  }
}