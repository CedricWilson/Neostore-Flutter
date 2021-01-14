import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neostore/Bloc/ProductBloc/product_bloc.dart';
import 'package:flutter_neostore/Bloc/ProductBloc/product_events.dart';
import 'package:flutter_neostore/Bloc/ProductBloc/product_states.dart';
import 'package:flutter_neostore/Modal/ResponseProduct.dart';

class ProductsList extends StatefulWidget {
  final String id;
  String gel = "1";


  ProductsList({Key key, @required this.id}) : super(key: key);

  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  String gel = "1";
  Future<void> _pullRefresh() async {
    BlocProvider.of<ProductBloc>(context).add(ProductStarted(id: 1.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Products",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: _pullRefresh,
          child:
          BlocBuilder<ProductBloc, ProductStates>(
            builder: (context, state) {
              if (state is ProductInitial) {
                // print("State: Initial");
                loading();
                BlocProvider.of<ProductBloc>(context).add(ProductStarted(id: gel));
              } else if (state is ProductSuccessful) {
                // print("State: Success");
                if (state.product == null) {
                } else {
                  return renderlist(state.product.data);
                }
              } else if (state is ProductLoading) {
                //  print("State: Loading");
                return loading();
              }
              return empty();
            },
          ),
        ));
  }

  Widget renderlist(List<Data> snapshot) {
    // print(snapshot[0].name);
    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: snapshot.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/details', arguments: snapshot[index].id);
            },
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image(
                      width: 100,
                      height: 100,
                      image: NetworkImage(snapshot[index].productImages),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot[index].name),
                          Text(snapshot[index].producer),
                          Text(snapshot[index].cost.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget empty() {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            "No Internet, Pull to Refresh",
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Widget loading() {
    return Center(
      child: CupertinoActivityIndicator(),
    );
  }
}
