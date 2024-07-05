import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smerp_go/model/response/collectionResponse.dart';
import '../../Reposistory/productListRepo.dart';
import '../../model/collectionDetail.dart';
import '../../model/response/defaultApiResponse.dart';
import '../../model/response/getCollectionList.dart';
import '../../model/response/product/productList.dart';
import '../../utils/AppUtils.dart';
import '../../utils/mockdata/tempData.dart';

part 'product_state.dart';

class CollectionCubit extends Cubit<CollectionState> {
  final CollectionRepo productListRepo;
  CollectionCubit({required this.productListRepo}) : super(ProductInitialState());
  void getProductList()async{
    try{
      emit(CollectionLoadingState());
      final response= await productListRepo.getProductList();
      if(response is List<InventoryInfo>){
        print("I emitted");
       emit(ProductListSuccessState(response));
        print("response:${response.length}");
      }else{
       emit(ProductListErrorState(response as DefaultApiResponse));
        print("The type is: ${response.runtimeType}");
      }
    }catch(e, strace){
      print("faileeeed: $e and $strace");
      emit(ProductListErrorState(AppUtils.defaultErrorResponse()));
   }
  }
  void getCollectionList()async{
    try{
      emit(CollectionLoadingState());
      final response= await productListRepo.getCollectionList(userMerchantCode!);
      if(response is  List<CollectionList>){
        print("I emitted");
        emit(CollectionListSuccessState(response));
        print("response:${response.length}");
      }else{
        emit(ProductListErrorState(response as DefaultApiResponse));
        print("The type is: ${response.runtimeType}");
      }
    }catch(e, strace){
      print("faileeeed: $e and $strace");
      emit(ProductListErrorState(AppUtils.defaultErrorResponse()));
    }
  }

  void getCollectionDetail(String collectionId)async{
    try{
      emit(CollectionLoadingState());
      final response= await productListRepo.getCollectionDetail(collectionId);
      if(response is CollectionDetail){
        print("I emitted");
        emit(CollectionDetailState(response));
      }else{
        emit(ProductListErrorState(response as DefaultApiResponse));
        print("The type is: ${response.runtimeType}");
      }
    }catch(e, strace){
      print("faileeeed: $e and $strace");
      emit(ProductListErrorState(AppUtils.defaultErrorResponse()));
    }
  }

  void testCall(){
    emit(SuccessCollectionCreatedState());
  }

  void createCollection(String collectionName,
      List<int> collectionProducts,
      String merchantCode,{String collectionImage ="",
        String collectionDescription="",})async {
    try {
      emit(CollectionLoadingState());
      final response = await productListRepo.createCollection(
          collectionName, collectionProducts, merchantCode,
      collectionImage: collectionImage,
          collectionDescription: collectionDescription);
      if (response is CollectionCreatedResponse) {
        print("I emitted");
        emit(CollectionCreatedState(response));
      } else {
        emit(ProductListErrorState(response as DefaultApiResponse));
      }
    } catch (e, strace) {
      print("faileeeed: $e and $strace");
      emit(ProductListErrorState(AppUtils.defaultErrorResponse()));
    }
  }
  void filterListByName(String name) {
    // collectionList.clear();
      final filtered = collectionListTemp.where((element) =>
          element.name.toLowerCase().contains(name.toLowerCase())
      ).toList();
      emit(CollectionFilteringState(filtered));
    print(filtered.length);
  }
  void deleteCollection(String collectionId)async {
    try {
      emit(CollectionLoadingState());
      final response = await productListRepo.deleteCollection(collectionId);
      if (response is DefaultApiResponse && response.isSuccess == true) {
        print("I emitted");
        emit(CollectionDeletedState(response));
      } else {
        emit(ProductListErrorState(response as DefaultApiResponse));
        print("The type is: ${response.runtimeType}");
      }
    } catch (e, strace) {
      print("faileeeed: $e and $strace");
      emit(ProductListErrorState(AppUtils.defaultErrorResponse()));
    }
  }
  void updateCollection(String collectionName, String collectionId,
      List<int> collectionProducts,
      String merchantCode,{String collectionImage ="",
        String collectionDescription="",})async  {
    try {
      emit(CollectionLoadingState());
      final response = await productListRepo.updateCollection(
          collectionProducts,
          collectionId,
          collectionName:collectionName,
          merchantCode: merchantCode,
          collectionImage: collectionImage,
          collectionDescription: collectionDescription);
      if (response is DefaultApiResponse && response.isSuccess == true) {
        print("I emitted");
        emit(CollectionUpdatedState(response));
      } else {
        emit(ProductListErrorState(response as DefaultApiResponse));
        print("The type is: ${response.runtimeType}");
      }
    } catch (e, strace) {
      print("faileeeed: $e and $strace");
      emit(ProductListErrorState(AppUtils.defaultErrorResponse()));
    }
  }

    void resetState(){
    emit(ProductInitialState());
  }
}