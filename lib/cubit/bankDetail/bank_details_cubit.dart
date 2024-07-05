import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smerp_go/Reposistory/catalogRepo.dart';

import '../../model/request/bankDetails.dart';
import '../../model/response/bankDetail.dart';
import '../../model/response/createBankDetailResponse.dart';
import '../../model/response/defaultApiResponse.dart';
import '../../utils/AppUtils.dart';

part 'bank_details_state.dart';
BankDetailReponse? storeBankDetail ;
class BankDetailsCubit extends Cubit<BankDetailsState> {
  final CataloRepo bankDetailRepo;
  BankDetailsCubit(this.bankDetailRepo) : super(BankDetailsInitial());

  void getBankDetail()async{
    try{
      emit(BankDetailLoadingState());
      final response= await bankDetailRepo.getBankDetails();
      if(response is  BankDetailReponse){
        print("I emitted");
        emit(BankDetailSuccessState(response));
      }else{
        emit(BankDetailErrorState(response as DefaultApiResponse));
        print("The type is: ${response.runtimeType}");
      }
    }catch(e, strace){
      print("faileeeed: $e and $strace");
      emit(BankDetailErrorState(AppUtils.defaultErrorResponse()));
    }
  }

  void createBankDetail(StoreBankDetail request)async{
    try{
      emit(BankDetailLoadingState());
      final response= await bankDetailRepo.createBankDetails(request);
      if(response is  DefaultApiResponse){
        if(response.isSuccess){
          print("I emitted");
          emit(CreateBankDetailSuccessState(response));
        }else{
          emit(BankDetailErrorState(response));
          print("The type is: ${response.runtimeType}");
        }
      }else{
        emit(BankDetailErrorState(response as DefaultApiResponse));
        print("The type is: ${response.runtimeType}");
      }
    }catch(e, strace){
      print("faileeeed: $e and $strace");
      emit(BankDetailErrorState(AppUtils.defaultErrorResponse()));
    }
  }

  void resetState(){
    emit(BankDetailsInitial());
  }
}
