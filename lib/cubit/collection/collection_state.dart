part of 'collection_bloc.dart';

abstract class CollectionState extends Equatable {
  const CollectionState();
}

class CollectionInitial extends CollectionState {
  @override
  List<Object> get props => [];
}
