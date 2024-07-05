part of 'bank_details_cubit.dart';

abstract class BankDetailsState extends Equatable {
  const BankDetailsState();
}

 class BankDetailsInitial extends BankDetailsState {
  @override
  List<Object> get props => [];
}

class BankDetailLoadingState extends BankDetailsState {
  @override
  List<Object> get props => [];
}

class BankDetailErrorState extends BankDetailsState{
  final DefaultApiResponse errorResponse;
  BankDetailErrorState(this.errorResponse);
  @override
  List<Object?> get props => [errorResponse];
}

class BankDetailSuccessState extends BankDetailsState{
  final BankDetailReponse response;
  BankDetailSuccessState(this.response);
  @override
  List<Object?> get props => [response];
}
class CreateBankDetailSuccessState extends BankDetailsState{
  final DefaultApiResponse response;
  CreateBankDetailSuccessState(this.response);
  @override
  List<Object?> get props => [response];
}