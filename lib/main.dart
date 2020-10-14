import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Location location;
  LocationData currentLocation;
  String lat = "";
  String lng = "";

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  userLocation() async {

    // Add 'Location' to yaml file
    // Add permission
    // Get UserLocation :))

    location = new Location();

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

    currentLocation = await location.getLocation();

    setState(() {
      lat = currentLocation.latitude.toString();
      lng = currentLocation.longitude.toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userLocation();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "latitude : "+lat,
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              "longitude : "+lng,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: userLocation,
        tooltip: 'Find User Location',
        child: Icon(Icons.location_on),
      ),
    );
  }
}
