import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neostore/Bloc/ProductBloc/product_bloc.dart';
import 'package:flutter_neostore/Bloc/ProductBloc/product_events.dart';
import 'package:flutter_neostore/Bloc/ProductBloc/product_states.dart';
import 'package:flutter_neostore/Modal/ResponseProduct.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'Details.dart';

class ProductsList extends StatefulWidget {
  final String id;

  ProductsList({Key key, @required this.id}) : super(key: key);

  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  String title = "id";

  Future<void> _pullRefresh() async {
    BlocProvider.of<ProductBloc>(context).add(ProductStarted(id: widget.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //Navigator.pushNamed(context, '/cart');
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            // backgroundColor: Colors.blue,
            elevation: 5,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            //centerTitle: true,
          ),
          backgroundColor: Color(0xFFf5f5f5),
          body: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: BlocBuilder<ProductBloc, ProductStates>(
              // ignore: missing_return
              builder: (context, state) {
                if (state is ProductInitial) {
                  // print("State: Initial");
                  loading();
                  BlocProvider.of<ProductBloc>(context).add(ProductStarted(id: widget.id));
                } else if (state is ProductSuccessful) {
                  // print("State: Success");
                  if (state.product == null) {
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        title = cat(state.product.data[1].productCategoryId);
                      });
                    });
                    return renderlist(state.product.data);
                  }
                } else if (state is ProductLoading) {
                  //  print("State: Loading");
                  return loading();
                }
                return empty();
              },
            ),
          )),
    );
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
              elevation: 1,
              margin: EdgeInsets.only(top: 8.0, left: 5, right: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                height: query(context, 14),
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image(
                          width: 110,
                          height: 110,
                          image: NetworkImage(snapshot[index].productImages),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0,top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                snapshot[index].name,
                                style: TextStyle(color: Colors.black,fontSize: 14),
                              ),

                              Text(snapshot[index].producer),
                              SizedBox(height: 10,),
                              Text(format(snapshot[index].cost),
                                style: TextStyle(color: Colors.red,fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: RatingBar.builder(
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          initialRating: snapshot[index].rating.toDouble(),
                          onRatingUpdate: null,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 20,
                        ),
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

  String cat(int productCategoryId) {
    switch (productCategoryId) {
      case 1:
        return "Table";
        break;
      case 2:
        return "Chairs";
        break;
      case 3:
        return "Sofas";
        break;
      case 4:
        return "Beds";
        break;
    }
    return "NULL";
  }
}
