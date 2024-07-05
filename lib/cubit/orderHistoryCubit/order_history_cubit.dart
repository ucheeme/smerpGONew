import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smerp_go/utils/AppUtils.dart';

import '../../Reposistory/orderHistoryCubitRepo/orderHistoryRepo.dart';
import '../../model/response/defaultApiResponse.dart';
import '../../model/response/order/orderHistory.dart';

part 'order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  final OrderHistoryRepo orderHistoryRepo;

  OrderHistoryCubit({required this.orderHistoryRepo})
      : super(OrderHistoryInitialState());

  void getOrderHistory() async {
    try {
      emit(OrderHistoryLoadingState());
      final response = await orderHistoryRepo.getOrderHistory();
      if (response is List<HistoryOrder>) {
        print("I emitted");
        emit(OrderHistorySuccessState(response));
        print("response:${response.length}");
      } else {
        emit(OrderHistoryErrorState(response as DefaultApiResponse));
        print("The type is: ${response.runtimeType}");
      }
    } catch (e) {
      emit(OrderHistoryErrorState(AppUtils.defaultErrorResponse()));
    }
  }

  void resetState() {
    emit(OrderHistoryInitialState());
  }
}
