part of 'order_history_cubit.dart';

abstract class OrderHistoryState extends Equatable {
  const OrderHistoryState();
}

class OrderHistoryInitialState extends OrderHistoryState {
  @override
  List<Object> get props => [];
}

class OrderHistoryErrorState extends OrderHistoryState{
 final DefaultApiResponse errorResponse;
 OrderHistoryErrorState(this.errorResponse);
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class OrderHistoryLoadingState extends OrderHistoryState{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}


class OrderHistorySuccessState extends OrderHistoryState{
  final List<HistoryOrder> response;
  OrderHistorySuccessState(this.response);
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}


