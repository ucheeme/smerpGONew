part of 'catalog_cubit.dart';

// @immutable
abstract class CatalogState extends Equatable{}

class CatalogInitial extends CatalogState {
  @override
  List<Object> get props => [];
}
class ApiLoadingState extends CatalogState {
  @override
  List<Object?> get props => [];
}

class CatalogUpdateAllProductFetchSuccessState extends CatalogState {
  final bool  response;
  CatalogUpdateAllProductFetchSuccessState(this.response);
  @override
  List<Object> get props => [response];
}
class CatalogSuccessState extends CatalogState{
  final InventoryInfo response;
  CatalogSuccessState(this.response);
  @override
  List<Object> get props=> [response];
}
class CatalogErrorState extends CatalogState {
  final bool defaultApiResponse;
  CatalogErrorState(this.defaultApiResponse);
  @override
  List<Object> get props => [defaultApiResponse];
}