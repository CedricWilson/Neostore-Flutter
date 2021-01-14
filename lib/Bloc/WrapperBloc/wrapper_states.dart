import 'package:equatable/equatable.dart';

abstract class WrapperStates extends Equatable{

}
class WrapInitial extends WrapperStates{
  @override
  List<Object> get props => [];
}
class AuthSuccessful extends WrapperStates{

  @override
  List<Object> get props => [];
}
class UnAuthState extends WrapperStates{
  @override
  List<Object> get props => [];

}