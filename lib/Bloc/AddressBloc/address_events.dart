import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neostore/Database/database.dart';

abstract class AddressEvent extends Equatable{
}
class AddressStarted extends AddressEvent{
  // final String email;
  // AddressStarted({@required this.email}): assert(email!=null);

  @override
  List<Object> get props => [];
}
class AddressAdd extends AddressEvent{
  final Task address;
  AddressAdd({@required this.address}): assert(address!=null);
  @override
  List<Object> get props => [address];
}

class Order extends AddressEvent{
  final String address;
  Order({this.address});
  @override
  List<Object> get props => [address];
}