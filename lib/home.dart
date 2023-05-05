import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late double lat = 21.3431049;
  late double lng = 83.6060941;

  late double currentLocationLat = 0.0;
  late double currentLocationLng = 0.0;

  final Completer<GoogleMapController> _controller = Completer();

  bool currentLocationFound = false;

  late GoogleMapController controller2;

  double screenLat = 0.0;
  double screenLng = 0.0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkGps();
  }

  Future<Position> getUserLocation() async {
    return await Geolocator.getCurrentPosition();
  }

  checkGps()async{
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings().whenComplete(() => getLocationLatLng());
    }else{
      getLocationLatLng();
    }

  }

  getLocationLatLng()async{
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              'Location Permission Turned Off!',
              style: TextStyle(
                  fontFamily: 'RobotoCondensed-Regular',
                  fontWeight: FontWeight.bold),
            ),
            content: const Text(
                'Please give location permission for accurate location',
                style: TextStyle(
                  fontFamily: 'Poppins-Regular',
                )),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  await Geolocator.openAppSettings();
                },
                child: const Text('Ok',
                    style: TextStyle(
                        fontFamily: 'RobotoCondensed-Regular',
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      }
    }

    getUserLocation().then((value) async {
      setState(() {
        currentLocationLat = value.latitude;
        currentLocationLng = value.longitude;
      });

      CameraPosition cameraPosition =
      CameraPosition(target: LatLng(value.latitude, value.longitude), zoom: 18);
      final GoogleMapController controller = await _controller.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    });

    StreamSubscription<Position> positionStream =
    Geolocator.getPositionStream().listen((position) async {
      // Do something with the new position
      setState(() {
        lat = position.latitude;
        lng = position.longitude;

        currentLocationFound = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Exit!"),
            content: const Text("Do you want to exit the app?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(14),
                  child: const Text("Yes"),
                ),
              ),
            ],
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Home Page",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                fontFamily: 'RobotoCondensed-Regular',
                color: Color(0xFF151515)),
          ),
          centerTitle: true,
        ),
        body: currentLocationFound ? Stack(
          children: [
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                //controller.setMapStyle(mapTheme);
                _controller.complete(controller);
                controller2 = controller;
              },
              padding: const EdgeInsets.only(bottom: 80),
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(lat, lng),
                zoom: 18,
              ),
              onCameraMove: (CameraPosition cp) {

              },
              onCameraIdle: () async {
                LatLngBounds visibleRegion =
                await controller2.getVisibleRegion();
                LatLng centerLatLng = LatLng(
                  (visibleRegion.northeast.latitude +
                      visibleRegion.southwest.latitude) /
                      2,
                  (visibleRegion.northeast.longitude +
                      visibleRegion.southwest.longitude) /
                      2,
                );

                setState(() {
                  screenLat = centerLatLng.latitude;
                  screenLng = centerLatLng.longitude;
                });

                AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
                  if (!isAllowed) {
                    // This is just a basic example. For real apps, you must show some
                    // friendly dialog box before call the request method.
                    // This is very important to not harm the user experience
                    AwesomeNotifications().requestPermissionToSendNotifications().whenComplete(() => sendNotification(lat, lng));
                  }else{
                    sendNotification(screenLat, screenLng);
                  }
                });
              },
            ),
            Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 110),
                  child: Icon(Icons.location_on,
                      size: 40, color: Color(0xFF3d4359)),
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      //bottomLeft: Radius.circular(10),
                      //bottomRight: Radius.circular(10),
                      topRight: Radius.circular(30)),
                ),
                child: Center(child: Text("Latitude: $screenLat, Longitude: $screenLng", textAlign: TextAlign.center,)),
              ),
            )
          ],
        ) : Container(
          child: Center(
            child: SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(color: Color(0xFF151515),),
            ),
          ),
        ),
      ),
    );
  }

  sendNotification(double lat, double lng){
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: '1',
        title: 'Location',
        body: 'Latitude: $lat, Longitude: $lng',
        //bigPicture: 'https://via.placeholder.com/150',
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

}
