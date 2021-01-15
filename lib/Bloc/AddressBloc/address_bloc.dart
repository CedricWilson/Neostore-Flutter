import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neostore/Api/apiprovider.dart';
import 'package:flutter_neostore/Database/database.dart';
import 'package:flutter_neostore/Helpers/SharedPrefs.dart';
import 'package:flutter_neostore/Modal/User.dart';

import 'address_events.dart';
import 'address_states.dart';

class AddressBloc extends Bloc<AddressEvent, AddressStates> {
  AddressBloc() : super(AddressInitial());
  final database = AppDatabase.getDatabase();

  @override
  Stream<AddressStates> mapEventToState(AddressEvent event) async* {
    if (event is AddressStarted) {
      User dot = await SharedPrefs().fetchUser();
      List<Task> task = await database.getAdds(dot.email);
      if (task.length != 0 && dot.fname != null && dot.email!= null) {
        yield AddressSuccessful(task: task, fname: dot.fname, email: dot.email);
      } else {
        yield AddressEmpty(email: dot.email);
      }
    }

    if (event is AddressAdd) {
      User dot = await SharedPrefs().fetchUser();


      database.insertAdds(event.address);

      List<Task> task = await database.getAdds(dot.email);
      if (task.length != 0 && dot.fname != null) {
        yield AddressSuccessful(task: task, fname: dot.fname, email: dot.email);
      }
    }

    if (event is Order) {
      User dot = await SharedPrefs().fetchUser();

      if (dot.token != null) {
        int pop = await ApiProvider().order(event.address, dot.token);

        if (pop == 200) {
          yield OrderSuccess(msg: "Order Successful");
        }
      }

     // yield OrderSuccess(msg: "Order Successful");
    }

    if(event is AddressDelete){
      database.deleteAll();
      User dot = await SharedPrefs().fetchUser();
      List<Task> task = await database.getAdds(dot.email);
      if (task.length != 0 && dot.fname != null) {
        yield AddressSuccessful(task: task, fname: dot.fname, email: dot.email);
      } else {
        yield AddressEmpty();
      }
    }
  }
}
