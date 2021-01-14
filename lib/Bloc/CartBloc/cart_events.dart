
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class CartEvent extends Equatable{
}
class CartStarted extends CartEvent{

  @override
  List<Object> get props => [];
}
class CartDelete extends CartEvent{
   final int id;
   final int index;
   CartDelete({@required this.id,@required this.index}): assert(id!=null);
  @override
  List<Object> get props => [id,index];
}

class CartUpdate extends CartEvent{
  final int id;
  final int quantity;
  CartUpdate({@required this.id,@required this.quantity}): assert(id!=null);
  @override
  List<Object> get props => [id,quantity];
}