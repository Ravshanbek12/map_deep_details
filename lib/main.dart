import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

void main() {
  runApp(const MyDetailDeepApp());
}

class MyDetailDeepApp extends StatelessWidget {
  const MyDetailDeepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyYandexMap();
  }
}

class MyYandexMap extends StatefulWidget {
  const MyYandexMap({super.key});

  @override
  State<MyYandexMap> createState() => _MyYandexMapState();
}

class _MyYandexMapState extends State<MyYandexMap> {
  YandexMapController? yandexMapController;
  Point? myLocation;

  Future<void> getLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen((event) {
      myLocation =
          Point(latitude: event.latitude!, longitude: event.longitude!);
      if (yandexMapController != null) {
        yandexMapController!.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: myLocation!, zoom: 16),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: YandexMap(
          mapObjects: [
            CircleMapObject(
                mapId: MapObjectId("my_location"),
                circle: Circle(
                    center:
                        myLocation ?? const Point(latitude: 0, longitude: 0),
                    radius: 20)),
            const PolygonMapObject(
              mapId: MapObjectId("polygon"),
              polygon: Polygon(
                  outerRing: LinearRing(points: [
                    Point(latitude: 56.34295, longitude: 74.62829),
                    Point(latitude: 70.12669, longitude: 98.97399),
                    Point(latitude: 56.04956, longitude: 125.07751),
                  ]),
                  innerRings: [
                    LinearRing(points: [
                      Point(latitude: 57.34295, longitude: 78.62829),
                      Point(latitude: 69.12669, longitude: 98.97399),
                      Point(latitude: 57.04956, longitude: 121.07751),
                    ])
                  ]),
            ),
          ],
          onMapCreated: (controller) async {
            yandexMapController = controller;

            final location = Location();
            final data = await location.getLocation();
            myLocation = Point(
                latitude: data.latitude ?? 0, longitude: data.longitude ?? 0);
            setState(() {});
          },
        ),
      ),
    );
  }
}
