import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neostore/Modal/ResponseProduct.dart';

abstract class ProductStates extends Equatable {}

class ProductInitial extends ProductStates {
  @override
  List<Object> get props => [];
}

class ProductSuccessful extends ProductStates {
  final ResponseProduct product;

  ProductSuccessful({@required this.product}) : assert(product != null);

  @override
  List<Object> get props => [product];
}

class ProductFailed extends ProductStates {
  @override
  List<Object> get props => [];
}

class ProductLoading extends ProductStates {
  @override
  List<Object> get props => [];
}
