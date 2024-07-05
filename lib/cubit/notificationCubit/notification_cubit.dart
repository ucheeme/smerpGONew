import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smerp_go/model/response/notificationList.dart';

import '../../Reposistory/notificationRepo.dart';
import '../../model/response/defaultApiResponse.dart';
import '../../utils/AppUtils.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
 final NotificationRepo notificationRepo;
  NotificationCubit(this.notificationRepo) : super(NotificationInitial());

  void getNotificationList()async{
    try{
      emit(NotificationLoadingState());
      final response= await notificationRepo.getNotificationList();
      if(response is  List<NotificationList>){
        print("I emitted");
        emit(NotificationSuccessState(response));
        print("response:${response.length}");
      }else{
        emit(NotificationErrorState(response as DefaultApiResponse));
        print("The type is: ${response.runtimeType}");
      }
    }catch(e, strace){
      print("faileeeed: $e and $strace");
      emit(NotificationErrorState(AppUtils.defaultErrorResponse()));
    }
  }
}
