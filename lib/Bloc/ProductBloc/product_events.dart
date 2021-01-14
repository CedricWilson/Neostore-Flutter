
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ProductEvent extends Equatable{
}
class ProductStarted extends ProductEvent{
  final String id;
  ProductStarted({@required this.id}): assert(id!=null);
  @override
  List<Object> get props => [id];
}