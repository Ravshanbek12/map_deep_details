import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'get_current_event.dart';

part 'get_current_state.dart';

class GetCurrentBloc extends Bloc<GetCurrentEvent, GetCurrentState> {
  GetCurrentBloc() : super(GetCurrentInitial()) {
    on<GetCurrentEvent>((event, emit) async{
      try {

      } catch (e) {}
    });
  }

  Future<GetCurrentState> _getLocation() async {
    try {
      final Location location = Location();
      LocationData locationData = await location.getLocation();
      Point myLocation = Point(
          latitude: locationData.latitude ?? 0,
          longitude: locationData.longitude ?? 0);

      return GetCurrentLocationState(myLocation: myLocation);
    } catch (e) {
      return MapErrorState(errorMessage: "ERROR--------------$e");
    }
  }
}
