
import 'package:equatable/equatable.dart';

abstract class WrapperEvent extends Equatable{
}
class AppStarted extends WrapperEvent{
  @override
  List<Object> get props => [];
}