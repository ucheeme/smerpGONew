import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smerp_go/core/logging/app_logger.dart';
import 'package:smerp_go/core/repositories/i_order_history_repository.dart';
import 'package:smerp_go/utils/AppUtils.dart';

import '../../model/response/defaultApiResponse.dart';
import '../../model/response/order/orderHistory.dart';

part 'order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  final IOrderHistoryRepository orderHistoryRepo;

  OrderHistoryCubit({required this.orderHistoryRepo})
      : super(OrderHistoryInitialState());

  void getOrderHistory() async {
    try {
      emit(OrderHistoryLoadingState());
      final response = await orderHistoryRepo.getOrderHistory();
      if (response is List<HistoryOrder>) {
        AppLogger.debug('Order history loaded count=${response.length}', tag: 'OrderHistoryCubit');
        emit(OrderHistorySuccessState(response));
      } else {
        emit(OrderHistoryErrorState(response as DefaultApiResponse));
        AppLogger.warning('Unexpected order history response type=${response.runtimeType}', tag: 'OrderHistoryCubit');
      }
    } catch (e, stackTrace) {
      AppLogger.error(e, stackTrace, reason: 'getOrderHistory', tag: 'OrderHistoryCubit');
      emit(OrderHistoryErrorState(AppUtils.defaultErrorResponse()));
    }
  }

  void resetState() {
    emit(OrderHistoryInitialState());
  }
}
