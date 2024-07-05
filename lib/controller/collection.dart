import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:smerp_go/utils/AppUtils.dart';
import 'package:smerp_go/utils/downloadAsImage.dart';

import '../apiServiceLayer/apiService.dart';
import '../apiServiceLayer/api_status.dart';
import '../cubit/products/product_cubit.dart';
import '../model/response/getCollectionList.dart';
import '../model/response/product/productList.dart';
import '../screens/bottomNav/screens/inventory/collections/addProductsToCollection.dart';
import '../utils/appUrl.dart';
import '../utils/mockdata/tempData.dart';

class CollectionController extends GetxController{
  RxInt collectionCount =250.obs;
  RxInt totalProducts = 2500.obs;
  late CollectionCubit cubit;
  var isLoading = false.obs;
  TextEditingController collectionName =TextEditingController();
  File collectionImageFile =File("");
  var collectionIImage = RxString("");
  RxList<InventoryInfo> inventory=RxList();
  List<CollectionList> collectionList=[];
  List<CollectionNewProductStructure> products=[];
  RxList<RxBool> selectedProductOptions =RxList();
  RxList<int> selectedProductIds =RxList();
RxInt selectedProductListNumber =0.obs;

void checkIfCollectionHasName(){
    if(collectionName.text.isEmpty){
      showToast("Please enter collection name");
    }else{

      Get.to(
        AddProductToCollection(isUpdateProductCollection: false),
        duration: Duration(seconds: 1),
        //transition: Transition.cupertino
      );
    }
  }

  void addRemoveCollectionProducts(int productId,bool addProduct){
    if(addProduct){
      selectedProductIds.value.add(productId);
      selectedProductListNumber.value++;
    }
    else{
      for(int i=0; i<selectedProductIds.value.length;i++){
        if(selectedProductIds.value[i]==productId){
          selectedProductIds.value.remove(selectedProductIds.value[i]);
          selectedProductListNumber.value=selectedProductListNumber.value-1;
        }
      }
    }
  }

  void getCollectionListInitial(BuildContext context,){
    cubit = context.read<CollectionCubit>();
    if(collectionListTemp.isEmpty){
      cubit.getCollectionList();
    }else {
      collectionList = collectionListTemp;
    }
  }

  void getCollectionInventory(
      BuildContext context,
      bool isUpdateProductCollection,
  {   List<int>? collectionProductIds}){
    cubit = context.read<CollectionCubit>();
    if(collectionInventoryListTemp.isEmpty){
      cubit.getProductList();
    }else {
      inventory.value = collectionInventoryListTemp;

    }
   assignedCollection(isUpdateProductCollection, collectionProductIds);
    print("this is length for inventory:${inventory.length}");
    print("this is length for selectionBool:${selectedProductOptions}");
    print("this is the id for product in here:$collectionProductIds");
  }

  void assignedCollection(bool isUpdateProductCollection, List<int>? collectionProductIds) {
  selectedProductOptions.clear();
  selectedProductListNumber.value=0;
  selectedProductIds.clear();
       for (int i = 0; i < inventory.length; i++) {
      products.add(
          CollectionNewProductStructure(
              collectionProductAssign: inventory[i],
              productPosition: i)
      );
     //collectionProducts(isUpdateProductCollection, collectionProductIds, i);
      if (isUpdateProductCollection == false) {
        selectedProductOptions.add(false.obs);
      }else{
        if(collectionProductIds!=null){
          if(collectionProductIds.contains(inventory[i].id))
          {
            selectedProductOptions.add(true.obs);
            selectedProductIds.add(inventory[i].id);
            selectedProductListNumber++;
           // break;
          }else{
            selectedProductOptions.add(false.obs);
            // if(selectedProductOptions.length==inventory.length){
            // break;
            // }
          }
        }
      }
    }
  }
  void collectionProducts(bool isUpdateProductCollection, List<int>? collectionProductIds, int i) {

  }

  void getCollectionDetail(int index)async{
    cubit.getCollectionDetail(collectionList[index].collectionId.toString());
  }

  void filterByName(String enteredValue){
    inventory.value =
        collectionInventoryListTemp.where((element) =>
        element.productName.toLowerCase().
        contains(enteredValue.toLowerCase())
        ).toList();
  }
  List<CollectionList> filterListByName(String name){
  return collectionListTemp.where((element) =>
      element.name.toLowerCase().contains(name.toLowerCase())
    ).toList();
  }


  @override
  void onClose() {
  // collectionList.value.clear();
    super.onClose();
  }

}