import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smerp_go/core/logging/app_logger.dart';
import 'package:smerp_go/core/repositories/i_collection_repository.dart';
import 'package:smerp_go/model/response/collectionResponse.dart';
import '../../model/collectionDetail.dart';
import '../../model/response/defaultApiResponse.dart';
import '../../model/response/getCollectionList.dart';
import '../../model/response/product/productList.dart';
import '../../utils/AppUtils.dart';
import '../../utils/mockdata/tempData.dart';

part 'product_state.dart';

class CollectionCubit extends Cubit<CollectionState> {
  final ICollectionRepository productListRepo;
  CollectionCubit({required this.productListRepo}) : super(ProductInitialState());
  void getProductList()async{
    try{
      emit(CollectionLoadingState());
      final response= await productListRepo.getProductList();
      if(response is List<InventoryInfo>){
        AppLogger.debug('Product list loaded count=${response.length}', tag: 'CollectionCubit');
       emit(ProductListSuccessState(response));
      }else{
       emit(ProductListErrorState(response as DefaultApiResponse));
        AppLogger.warning('Unexpected product list response type=${response.runtimeType}', tag: 'CollectionCubit');
      }
    }catch(e, stackTrace){
      AppLogger.error(e, stackTrace, reason: 'getProductList', tag: 'CollectionCubit');
      emit(ProductListErrorState(AppUtils.defaultErrorResponse()));
   }
  }
  void getCollectionList()async{
    try{
      emit(CollectionLoadingState());
      final response= await productListRepo.getCollectionList(userMerchantCode!);
      if(response is  List<CollectionList>){
        AppLogger.debug('Collection list loaded count=${response.length}', tag: 'CollectionCubit');
        emit(CollectionListSuccessState(response));
      }else{
        emit(ProductListErrorState(response as DefaultApiResponse));
        AppLogger.warning('Unexpected collection list response type=${response.runtimeType}', tag: 'CollectionCubit');
      }
    }catch(e, stackTrace){
      AppLogger.error(e, stackTrace, reason: 'getCollectionList', tag: 'CollectionCubit');
      emit(ProductListErrorState(AppUtils.defaultErrorResponse()));
    }
  }

  void getCollectionDetail(String collectionId)async{
    try{
      emit(CollectionLoadingState());
      final response= await productListRepo.getCollectionDetail(collectionId);
      if(response is CollectionDetail){
        emit(CollectionDetailState(response));
      }else{
        emit(ProductListErrorState(response as DefaultApiResponse));
        AppLogger.warning('Unexpected collection detail response type=${response.runtimeType}', tag: 'CollectionCubit');
      }
    }catch(e, stackTrace){
      AppLogger.error(e, stackTrace, reason: 'getCollectionDetail', tag: 'CollectionCubit');
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
        emit(CollectionCreatedState(response));
      } else {
        emit(ProductListErrorState(response as DefaultApiResponse));
      }
    } catch (e, stackTrace) {
      AppLogger.error(e, stackTrace, reason: 'createCollection', tag: 'CollectionCubit');
      emit(ProductListErrorState(AppUtils.defaultErrorResponse()));
    }
  }
  void filterListByName(String name) {
    // collectionList.clear();
      final filtered = collectionListTemp.where((element) =>
          element.name.toLowerCase().contains(name.toLowerCase())
      ).toList();
      emit(CollectionFilteringState(filtered));
    AppLogger.debug('Filtered collections count=${filtered.length}', tag: 'CollectionCubit');
  }
  void deleteCollection(String collectionId)async {
    try {
      emit(CollectionLoadingState());
      final response = await productListRepo.deleteCollection(collectionId);
      if (response is DefaultApiResponse && response.isSuccess == true) {
        emit(CollectionDeletedState(response));
      } else {
        emit(ProductListErrorState(response as DefaultApiResponse));
        AppLogger.warning('Delete collection unexpected response type=${response.runtimeType}', tag: 'CollectionCubit');
      }
    } catch (e, stackTrace) {
      AppLogger.error(e, stackTrace, reason: 'deleteCollection', tag: 'CollectionCubit');
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
        emit(CollectionUpdatedState(response));
      } else {
        emit(ProductListErrorState(response as DefaultApiResponse));
        AppLogger.warning('Update collection unexpected response type=${response.runtimeType}', tag: 'CollectionCubit');
      }
    } catch (e, stackTrace) {
      AppLogger.error(e, stackTrace, reason: 'updateCollection', tag: 'CollectionCubit');
      emit(ProductListErrorState(AppUtils.defaultErrorResponse()));
    }
  }

    void resetState(){
    emit(ProductInitialState());
  }
}
