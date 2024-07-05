
import 'dart:convert';

import 'package:smerp_go/model/request/createAndUpdateCollection.dart';
import 'package:smerp_go/utils/AppUtils.dart';

import '../apiServiceLayer/apiService.dart';
import '../model/collectionDetail.dart';
import '../model/response/collectionResponse.dart';
import '../model/response/defaultApiResponse.dart';
import '../model/response/getCollectionList.dart';
import '../model/response/product/productList.dart';
import '../utils/UserUtils.dart';
import '../utils/appUrl.dart';
import 'apiRepo.dart';

class CollectionRepo extends ApiRepository{
  Future<Object> getProductList()async{
    var response = await ApiService.makeApiCall(null,AppUrls().getProductInventory,
        method: HTTP_METHODS.get);
    var r =  handleSuccessResponse(response);
    if(r is DefaultApiResponse){
      if(r.isSuccess){
       List<InventoryInfo> res = productListFromJson(json.encode(r.data));
        print("response here:${res.length}");
        print("response here:${res.runtimeType}");
        return res;
      }else{
        print("failed response here:${r}");
        return r;
      }
    }
    else{
      print("failed2 response here:${r}");
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> getCollectionDetail(String collectionId)async {
    var response = await ApiService.makeApiCall(
        null, AppUrls().getCollectionDetails(userMerchantCode!, collectionId),
        method: HTTP_METHODS.get);
    var r = handleSuccessResponse(response);
    if (r is DefaultApiResponse) {
      if (r.isSuccess) {
        CollectionDetail res = collectionDetailFromJson(json.encode(r.data));
        return res;
      } else {
        print("failed response here:${r}");
        return r;
      }
    }
    else {
      print("failed2 response here:${r}");
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

    Future<Object> getCollectionList(String merchantCode)async{
    var response = await ApiService.makeApiCall(null,AppUrls().getUserCollections(merchantCode),
        method: HTTP_METHODS.get);
    var r =  handleSuccessResponse(response);
    print(r.runtimeType);
    if(r is DefaultApiResponse){
      if(r.isSuccess){
        List<CollectionList> res = collectionListFromJson(json.encode(r.data));
        print("response here:${res?.length}");
        print("response here:${res.runtimeType}");
        return res??[];
      }else if(!r.isSuccess){
        List<CollectionList> res=[];
        return res;
      }else{
        print("failed response here:${r}");
        return [];
      }
    } else{
      print("failed2 response here:${r}");
      handleErrorResponse(response);
      return errorResponse!;
    }
  }


  Future<Object?> createCollection(String collectionName,
      List<int> collectionProducts,
      String merchantCode,{String collectionImage ="",
    String collectionDescription="",})async{
    CreateCollection? createCollection;
    createCollection =CreateCollection(actionBy: actionBy,
        actionOn: DateTime.now(), name: collectionName,
        description: collectionDescription,
        avatar: collectionImage, merchantCode: merchantCode,
        productIds: collectionProducts);
    var response = await ApiService.makeApiCall(createCollection,
        AppUrls.createCollectionUrl,
        method: HTTP_METHODS.post);
    var r =  handleSuccessResponse(response);
    if(r is DefaultApiResponse){
      CollectionCreatedResponse res = collectionResponseFromJson(json.encode(r.data));
      return res;
    }else{
      print("failed response here:${r}");
      return r;
    }
    }

  Future<Object> updateCollection(List<int> collectionProducts,
      String collectionId,
      {String collectionName="",
      String merchantCode="",String collectionImage ="",
        String collectionDescription="",})async{
    CreateCollection? createCollection;
    createCollection =CreateCollection(actionBy: actionBy,
        actionOn: DateTime.now(), name: collectionName,
        description: collectionDescription,
        avatar: collectionImage, merchantCode: merchantCode,
        productIds: collectionProducts);
    var response = await ApiService.makeApiCall(createCollection,
        AppUrls().updateCollectionDetail(collectionId),
        method: HTTP_METHODS.put);
    var r =  handleSuccessResponse(response);
    if(r is DefaultApiResponse){
      if(r.isSuccess){
        return r;
      }else{
        print("failed response here:${r}");
        return r;
      }
    }
    else{
      print("failed2 response here:${r}");
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> deleteCollection(
      String collectionId,
      )async{
    var response = await ApiService.makeApiCall(null,
        AppUrls().deleteCollection(collectionId),
        method: HTTP_METHODS.delete);
    var r =  handleSuccessResponse(response);
    if(r is DefaultApiResponse){
      if(r.data==null&& r.isSuccess){
        return r;
      }else{
        print("failed response here:${r}");
        return r;
      }
    }
    else{
      print("failed2 response here:${r}");
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

}