import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smerp_go/core/logging/app_logger.dart';
import 'package:smerp_go/core/repositories/i_bank_details_repository.dart';

import '../../model/request/bankDetails.dart';
import '../../model/response/bankDetail.dart';
import '../../model/response/createBankDetailResponse.dart';
import '../../model/response/defaultApiResponse.dart';
import '../../utils/AppUtils.dart';

part 'bank_details_state.dart';
BankDetailReponse? storeBankDetail ;
class BankDetailsCubit extends Cubit<BankDetailsState> {
  final IBankDetailsRepository bankDetailRepo;
  BankDetailsCubit(this.bankDetailRepo) : super(BankDetailsInitial());

  void getBankDetail()async{
    try{
      emit(BankDetailLoadingState());
      final response= await bankDetailRepo.getBankDetails();
      if(response is  BankDetailReponse){
        emit(BankDetailSuccessState(response));
      }else{
        emit(BankDetailErrorState(response as DefaultApiResponse));
        AppLogger.warning('Unexpected bank detail response type=${response.runtimeType}', tag: 'BankDetailsCubit');
      }
    }catch(e, stackTrace){
      AppLogger.error(e, stackTrace, reason: 'getBankDetail', tag: 'BankDetailsCubit');
      emit(BankDetailErrorState(AppUtils.defaultErrorResponse()));
    }
  }

  void createBankDetail(StoreBankDetail request)async{
    try{
      emit(BankDetailLoadingState());
      final response= await bankDetailRepo.createBankDetails(request);
      if(response is  DefaultApiResponse){
        if(response.isSuccess){
          emit(CreateBankDetailSuccessState(response));
        }else{
          emit(BankDetailErrorState(response));
        }
      }else{
        emit(BankDetailErrorState(response as DefaultApiResponse));
        AppLogger.warning('Unexpected create bank detail response type=${response.runtimeType}', tag: 'BankDetailsCubit');
      }
    }catch(e, stackTrace){
      AppLogger.error(e, stackTrace, reason: 'createBankDetail', tag: 'BankDetailsCubit');
      emit(BankDetailErrorState(AppUtils.defaultErrorResponse()));
    }
  }

  void resetState(){
    emit(BankDetailsInitial());
  }
}
