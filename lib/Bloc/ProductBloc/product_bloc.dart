import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neostore/Api/apiprovider.dart';
import 'package:flutter_neostore/Bloc/ProductBloc/product_events.dart';
import 'package:flutter_neostore/Bloc/ProductBloc/product_states.dart';
import 'package:flutter_neostore/Modal/ResponseProduct.dart';

class ProductBloc extends Bloc<ProductEvent, ProductStates> {
  ProductBloc() : super(ProductInitial());

  @override
  Stream<ProductStates> mapEventToState(ProductEvent event) async* {
    if (event is ProductStarted) {
      yield ProductLoading();

     // print("------ProductStarted-------");
      try {
        ResponseProduct product = await ApiProvider().product(event.id);
        if (product.status == 200) {
          //print("Bloc Successful");
         // print("Bloc: "+product.status.toString());
          yield ProductSuccessful(product: product);
        }else{
          yield ProductFailed();
         // print("ProductBloc Failed");
        }
      } catch (e) {
        print("ProductBloc Failed");
        print(e);
        yield ProductFailed();
      }
    }
  }
}
