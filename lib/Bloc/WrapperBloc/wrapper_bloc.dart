import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neostore/Bloc/WrapperBloc/wrapper_events.dart';
import 'package:flutter_neostore/Bloc/WrapperBloc/wrapper_states.dart';
import 'package:flutter_neostore/Helpers/SharedPrefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WrapperBloc extends Bloc<WrapperEvent, WrapperStates> {
  WrapperBloc() : super(WrapInitial());

  @override
  Stream<WrapperStates> mapEventToState(WrapperEvent event) async* {
    if (event is AppStarted) {
      //print("-----App Started Event------:");
      bool status = false;

      try {

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String value = prefs.getString('token') ?? '';
        if (value.isEmpty) {
          status = false;
        } else {
          status = true;
        }
       // print("Wrapper Status: "+status.toString());

        if (status == true) {
          yield AuthSuccessful();
        } else {
          yield UnAuthState();
        }
      } catch (e) {
        yield UnAuthState();
      }
    }
  }
}
