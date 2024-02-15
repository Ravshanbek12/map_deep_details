part of 'get_current_bloc.dart';

@immutable
abstract class GetCurrentState {}

class GetCurrentInitial extends GetCurrentState {}


class GetCurrentLocationState extends GetCurrentState{
  final Point myLocation;

  GetCurrentLocationState({required this.myLocation});
}

class MapErrorState extends GetCurrentState{

  final String errorMessage;

  MapErrorState({required this.errorMessage});

}



