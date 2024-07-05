part of 'product_cubit.dart';

abstract class CollectionState extends Equatable {
  const CollectionState();
}

class ProductInitialState extends CollectionState {
  @override
  List<Object> get props => [];
}

class ProductListErrorState extends CollectionState{
  final DefaultApiResponse errorResponse;
  ProductListErrorState(this.errorResponse);
  @override
  List<Object?> get props => [errorResponse];
}

class CollectionLoadingState extends CollectionState{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ProductListSuccessState extends CollectionState{
  final List<InventoryInfo> response;
  ProductListSuccessState(this.response);
  @override
  // TODO: implement props
  List<Object?> get props => [response];
}

class CollectionListSuccessState extends CollectionState{
  final  List<CollectionList> response;
  CollectionListSuccessState(this.response);
  @override
  // TODO: implement props
  List<Object?> get props => [response];
}

class CollectionCreatedState extends CollectionState{
  final CollectionCreatedResponse response;
  CollectionCreatedState(this.response);
  @override
  List<Object?> get props => [response];
}
class SuccessCollectionCreatedState extends CollectionState{
  SuccessCollectionCreatedState();
  @override
  List<Object?> get props => [];
}

class CollectionUpdatedState extends CollectionState {
  final DefaultApiResponse response;
  CollectionUpdatedState(this.response);
  @override
  List<Object?> get props => [response];
}

class CollectionDeletedState extends CollectionState{
  final DefaultApiResponse response;
  CollectionDeletedState(this.response);
  @override
  List<Object?> get props => [response];
}

class CollectionDetailState extends CollectionState{
  final CollectionDetail response;
  CollectionDetailState(this.response);
  @override
  List<Object?> get props => [response];
}

class CollectionFilteringState extends CollectionState{
  final  List<CollectionList> response;
  CollectionFilteringState(this.response);
  @override
  List<Object?> get props => [response];
}