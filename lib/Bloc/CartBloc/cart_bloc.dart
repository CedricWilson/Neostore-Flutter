import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neostore/Api/apiprovider.dart';
import 'package:flutter_neostore/Bloc/CartBloc/cart_events.dart';
import 'package:flutter_neostore/Bloc/CartBloc/cart_states.dart';
import 'package:flutter_neostore/Modal/ResponseCart.dart';

class CartBloc extends Bloc<CartEvent, CartStates> {
  CartBloc() : super(CartInitial());
  ResponseCart cart;

  @override
  Stream<CartStates> mapEventToState(CartEvent event) async* {
    if (event is CartStarted) {
      yield CartLoading();
      try {
        ResponseCart cart = await ApiProvider().cart();
        if (cart.data != null) {
          yield CartSuccessful(cart: cart);
        } else
          yield CartEmpty();
      } catch (e) {
        yield CartFailed();
      }
    }

    if (event is CartDelete) {
      String pop = await ApiProvider().delete(event.id.toString());
      if (event.index == 1) {
        yield CartEmpty();
      }
    }

    if (event is CartUpdate) {
      int pop = await ApiProvider().cartupdate(event.id,event.quantity);
      if(pop ==200){
        ResponseCart cart = await ApiProvider().cart();
        yield CartSuccessful(cart: cart);
        //CartEdited(cart: cart);
      }
    }
  }
}
