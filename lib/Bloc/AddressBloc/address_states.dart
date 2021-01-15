import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neostore/Database/database.dart';

abstract class AddressStates extends Equatable {}

class AddressInitial extends AddressStates {
  @override
  List<Object> get props => [];
}

class AddressSuccessful extends AddressStates {
  final List<Task> task;
  final String fname;
  final String email;
  AddressSuccessful({@required this.task,this.fname,this.email}) : assert(task != null);

  @override
  List<Object> get props => [task,fname,email];
}
class AddressEmpty extends AddressStates {
  final String email;
  AddressEmpty({@required this.email}) : assert(email != null);
  @override
  List<Object> get props => [];
}

class OrderSuccess extends AddressStates {
  final String msg;

  OrderSuccess({@required this.msg}) : assert(msg != null);

  @override
  List<Object> get props => [msg];
}