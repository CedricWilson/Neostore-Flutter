import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neostore/Modal/ResponseCart.dart';
import 'package:flutter_neostore/Modal/ResponseProduct.dart';

abstract class CartStates extends Equatable {}

class CartInitial extends CartStates {
  @override
  List<Object> get props => [];
}

class CartSuccessful extends CartStates {
  final ResponseCart cart;

  CartSuccessful({@required this.cart}) : assert(cart != null);

  @override
  List<Object> get props => [cart];
}
class CartEdited extends CartStates {
  final ResponseCart cart;

  CartEdited({@required this.cart}) : assert(cart != null);

  @override
  List<Object> get props => [cart];
}

class CartFailed extends CartStates {
  @override
  List<Object> get props => [];
}

class CartLoading extends CartStates {
  @override
  List<Object> get props => [];
}

class CartEmpty extends CartStates {
  @override
  List<Object> get props => [];
}