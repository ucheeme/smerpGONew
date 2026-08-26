import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smerp_go/core/logging/app_logger.dart';
import 'package:smerp_go/core/repositories/i_notification_repository.dart';
import 'package:smerp_go/model/response/notificationList.dart';

import '../../model/response/defaultApiResponse.dart';
import '../../utils/AppUtils.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
 final INotificationRepository notificationRepo;
  NotificationCubit(this.notificationRepo) : super(NotificationInitial());

  void getNotificationList()async{
    try{
      emit(NotificationLoadingState());
      final response= await notificationRepo.getNotificationList();
      if(response is  List<NotificationList>){
        AppLogger.debug('Notifications loaded count=${response.length}', tag: 'NotificationCubit');
        emit(NotificationSuccessState(response));
      }else{
        emit(NotificationErrorState(response as DefaultApiResponse));
        AppLogger.warning('Unexpected notification response type=${response.runtimeType}', tag: 'NotificationCubit');
      }
    }catch(e, stackTrace){
      AppLogger.error(e, stackTrace, reason: 'getNotificationList', tag: 'NotificationCubit');
      emit(NotificationErrorState(AppUtils.defaultErrorResponse()));
    }
  }
}
