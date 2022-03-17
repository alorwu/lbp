import 'dart:async';

import 'package:carp_background_location/carp_background_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lbp/features/pushnotification/domain/entity/one_signal_push_notification.dart';
import 'package:mobility_features/mobility_features.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uni_links/uni_links.dart';

import '../../env/.env.dart';
import '../auctions/auction_screen.dart';
import '../history.dart';
import '../more.dart';
import '../sleep_home.dart';
import '../trends.dart';

class NewHomeScreen extends StatefulWidget {
  @override
  NewHomeState createState() => NewHomeState();
}

class NewHomeState extends State<NewHomeScreen> {
  int _selectedIndex = 0;
  // Location streaming
  Stream<LocationDto> locationStream;
  StreamSubscription<LocationDto> locationSubscription;

  // Mobility features stream
  StreamSubscription<MobilityContext> mobilitySubscription;
  MobilityContext _mobilityContext;

  // Step count stream
  Stream<StepCount> _stepCountStream;
  Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';

  StreamSubscription deepLinkSubscription;

  @override
  void initState() {
    super.initState();
    start();
    initializeDeepLinks(context);

    // Set up Mobility Features
    MobilityFeatures().stopDuration = Duration(minutes: 1);
    MobilityFeatures().placeRadius = 0.01;
    MobilityFeatures().stopRadius = 0.005;

    // Set up Location Manager
    LocationManager().distanceFilter = 0;
    LocationManager().interval = 1;
    LocationManager().notificationTitle = "Location tracking";
    LocationManager().notificationMsg = "Your location is being tracked";
  }


  Future<void> initStepCountStream() async {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
      .listen(onPedestrianStatusChanged)
      .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  void onStepCount(StepCount event) {
    print('onStepCountEvent: $event');
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print('onPedestrianStatusChangedEvent: $event');
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  /// Is "location always" permission granted?
  Future<bool> isLocationGranted() async =>
      await Permission.location.isGranted;

  /// Tries to ask for "location always" permissions from the user.
  /// Returns `true` if successful, `false` othervise.
  Future<void> askForLocationPermission() async {
    requestPermission(Permission.location);
  }

  Future<void> askForActivityRecognitionPermission() async {
    requestPermission(Permission.activityRecognition);
  }

  Future<bool> isRecognitionGranted() async =>
      await Permission.activityRecognition.isGranted;

  Future<void> requestPermission(Permission permission) async {
    var status = await permission.status;
    if (!status.isGranted) {
      if (status.isDenied || status.isRestricted) {
        await permission.request();
      } else {
        openAppSettings();
      }
    }

    if (await permission.status.isDenied) {
      requestPermission(permission);
    }
  }

  void start() async {
    if (!await isLocationGranted()) {
      await askForLocationPermission();
    } else {
      await streamInit();
    }

    if (!await isRecognitionGranted()) {
      await askForActivityRecognitionPermission();
    } else {
      await initStepCountStream();
    }
  }

  Future<void> streamInit() async {
    locationStream = LocationManager().locationStream;

    // subscribe to location stream - in case this is needed in the app
    if (locationSubscription != null) locationSubscription.cancel();
    locationSubscription = locationStream.listen(onLocationUpdate);

    // start the location service (specific to carp_background_location)
    await LocationManager().start();

    // map from [LocationDto] to [LocationSample]
    Stream<LocationSample> locationSampleStream = locationStream.map(
        (location) => LocationSample(
            GeoLocation(location.latitude, location.longitude),
            DateTime.now()));

    // provide the [MobilityFeatures] instance with the LocationSample stream
    MobilityFeatures().startListening(locationSampleStream);

    // start listening to incoming MobilityContext objects
    mobilitySubscription =
    MobilityFeatures().contextStream.listen(onMobilityContext);
  }

  String dtoToString(LocationDto dto) =>
      '${dto.latitude}, ${dto.longitude} @ ${DateTime.fromMillisecondsSinceEpoch(dto.time ~/ 1)}';

  void onLocationUpdate(LocationDto dto) {
    // print(dtoToString(dto));
  }

  // Called whenever mobility context changes.
  void onMobilityContext(MobilityContext context) {
    print('Context received: ${context.toJson()}');
    setState(() {
      _mobilityContext = context;
    });
  }

  Future<void> initializeDeepLinks(BuildContext context) async {
    try {
      final uri = await getInitialUri();
      if (uri == null) {
        print('no initial uri');
      } else {
        print('got initial uri: $uri');
        List<String> links = uri
            .toString()
            .replaceFirst("lbp://deep_link/", "")
            .split("/");
        if (links[0].toString() == "auction") {
          _goToAuctionScreen(context, links[0]);
        }
      }
      // if (!mounted) return;
      // setState(() => _initialUri = uri);
    } on PlatformException {
      // Platform messages may fail but we ignore the exception
      print('falied to get initial uri');
    } on FormatException catch (err) {
      if (!mounted) return;
      print('malformed initial uri');
    }
  }

  _goToAuctionScreen(BuildContext context, String content) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return AuctionScreen(content: content);
      })
    );
  }

  @override
  void dispose() {
    mobilitySubscription?.cancel();
    deepLinkSubscription?.cancel();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    MobilityContext features;

    if (_mobilityContext != null) {
      features = _mobilityContext;
    }

    List<Widget> pages = <Widget> [
      SleepHome(),
      SurveyHistoryScreen(features, _steps, _status),
      TrendScreen(),
      MoreScreen()
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.black,
            bottomNavigationBar: new Theme(
              data: Theme.of(context).copyWith(canvasColor: Color(0xff000000) ), //Color.fromRGBO(58, 66, 86, 1.0)),
              child: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(icon: Icon(Icons.event_note_outlined), label: 'History'),
                  BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Trends'),
                  BottomNavigationBarItem(icon: Icon(Icons.add), label: 'More',),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white38,
                onTap: _onItemTapped,
                showSelectedLabels: true,
                showUnselectedLabels: true,
              ),
            ),
            body: pages[_selectedIndex], //pages.elementAt(_selectedIndex),
          ),
        ],
      ),
    );
  }
}
