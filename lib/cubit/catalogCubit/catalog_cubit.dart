import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smerp_go/core/logging/app_logger.dart';
import 'package:smerp_go/core/repositories/i_catalog_repository.dart';
import 'package:smerp_go/model/response/inventoryList.dart';

part 'catalog_state.dart';

class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit({required this.catalogRepository}) : super(CatalogInitial());

  final ICatalogRepository catalogRepository;

  void updateAllCatalogPublishCubit(bool isVisible, int category) async {
    try {
      emit(ApiLoadingState());
      final response = await catalogRepository.updateCatalogAllProductCata(
        isVisible,
        category,
      );
      if (response == true) {
        emit(CatalogUpdateAllProductFetchSuccessState(response));
        AppLogger.debug('Catalog category visibility update succeeded',
            tag: 'CatalogCubit');
      } else {
        emit(CatalogErrorState(response));
        AppLogger.warning('Catalog category visibility update failed',
            tag: 'CatalogCubit');
      }
    } catch (e, stackTrace) {
      emit(CatalogErrorState(false));
      AppLogger.error(e, stackTrace,
          reason: 'updateAllCatalogPublishCubit', tag: 'CatalogCubit');
    }
  }

  void resetState() {}
}
