import 'dart:async';

import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'map_marker.dart';
import 'map_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'geo_json.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _mapController = Completer();

  /// Set of displayed markers and cluster markers on the map
  final Set<Marker> _markers = Set();

  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;

  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker> _clusterManager;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 15;

  /// Map loading flag
  bool _isMapLoading = true;

  /// Markers loading flag
  bool _areMarkersLoading = true;

  /// Url image used on normal markers
  final String _markerImageUrl =
      'https://img.icons8.com/office/80/000000/marker.png';

  /// Color of the cluster circle
  final Color _clusterColor = Colors.red;

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;

  static LatLng _initialPosition;
  static LatLng _lastMapPosition = _initialPosition;

//  var point;

  Set<Polygon> polygon = {};

  List<LatLng> point1 = [];
  List<LatLng> point2 = [];
  List<LatLng> point3 = [];

  void _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      print('${placemark[0].name}');
    });
  }

  @override
  void initState() {
    _getUserLocation();

    addPoints();
    List<Polygon> addPolygon1 = [
      Polygon(
        polygonId: PolygonId('Red Zone'),
        points: point1,
        consumeTapEvents: true,
        strokeColor: Colors.grey,
        strokeWidth: 1,
        fillColor: Colors.red.withOpacity(0.5),
      ),
    ];

    List<Polygon> addPolygon2 = [
      Polygon(
        polygonId: PolygonId('Red Zone'),
        points: point2,
        consumeTapEvents: true,
        strokeColor: Colors.grey,
        strokeWidth: 1,
        fillColor: Colors.yellowAccent.withOpacity(0.5),
      ),
    ];

    List<Polygon> addPolygon3 = [
      Polygon(
        polygonId: PolygonId('Green Zone'),
        points: point3,
        consumeTapEvents: true,
        strokeColor: Colors.grey,
        strokeWidth: 1,
        fillColor: Colors.green.withOpacity(0.5),
      ),
    ];

    polygon.addAll(addPolygon1);
    polygon.addAll(addPolygon2);
    polygon.addAll(addPolygon3);

    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      showMyDialog(context);
    });
  }

  void addPoints() {
    for (var i = 0; i < GeoJson.red.length; i++) {
      var ltlng = LatLng(GeoJson.red[i][1], GeoJson.red[i][0]);
      point1.add(ltlng);
    }

    for (var i = 0; i < GeoJson.yellow.length; i++) {
      var ltlng = LatLng(GeoJson.yellow[i][1], GeoJson.yellow[i][0]);
      point2.add(ltlng);
    }

    for (var i = 0; i < GeoJson.green.length; i++) {
      var ltlng = LatLng(GeoJson.green[i][1], GeoJson.green[i][0]);
      point3.add(ltlng);
    }
  }

  /// Example marker coordinates
  final List<LatLng> _markerLocations = [
    LatLng(27.695429, 85.306959),
    LatLng(27.695439, 85.306959),
    LatLng(27.695441, 85.306959),
    LatLng(27.695452, 85.306959),
    LatLng(27.695463, 85.306959),
    LatLng(27.695474, 85.306959),
    LatLng(27.695485, 85.306959),
    LatLng(27.695496, 85.306959),
    LatLng(27.695107, 85.306959),
    LatLng(27.695118, 85.306959),

    LatLng(27.695429, 85.306959),
    LatLng(27.695439, 85.306959),
    LatLng(27.695441, 85.306959),
    LatLng(27.695452, 85.306959),
    LatLng(27.695463, 85.306959),
    LatLng(27.695474, 85.306959),
    LatLng(27.695485, 85.306959),
    LatLng(27.695496, 85.306959),
    LatLng(27.695107, 85.306959),
    LatLng(27.695118, 85.306959),

    LatLng(27.695429, 85.306959),
    LatLng(27.695439, 85.306959),
    LatLng(27.695441, 85.306959),
    LatLng(27.695452, 85.306959),
    LatLng(27.695463, 85.306959),
    LatLng(27.695474, 85.306959),
    LatLng(27.695485, 85.306959),
    LatLng(27.695496, 85.306959),
    LatLng(27.695107, 85.306959),
    LatLng(27.695118, 85.306959),

    LatLng(27.695429, 85.306959),
    LatLng(27.695439, 85.306959),
    LatLng(27.695441, 85.306959),
    LatLng(27.695452, 85.306959),
    LatLng(27.695463, 85.306959),
    LatLng(27.695474, 85.306959),
    LatLng(27.695485, 85.306959),
    LatLng(27.695496, 85.306959),
    LatLng(27.695107, 85.306959),
    LatLng(27.695118, 85.306959),

    //Kalimati
    LatLng(27.698501, 85.300128),
    LatLng(27.698501, 85.300128),
    LatLng(27.698501, 85.300128),
    LatLng(27.698501, 85.300128),
    LatLng(27.698501, 85.300128),
    LatLng(27.698501, 85.300128),
    LatLng(27.698501, 85.300128),
    LatLng(27.698501, 85.300128),
    LatLng(27.698501, 85.300128),
    LatLng(27.698501, 85.300128),
    LatLng(27.698501, 85.300128),
    LatLng(27.698501, 85.300128),
    LatLng(27.698501, 85.300128),
  ];

  /// Called when the Google Map widget is created. Updates the map loading state
  /// and inits the markers.
  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);

    setState(() {
      _isMapLoading = false;
    });

    _initMarkers();
  }

  /// Inits [Fluster] and all the markers with network images and updates the loading state.
  void _initMarkers() async {
    final List<MapMarker> markers = [];

    for (LatLng markerLocation in _markerLocations) {
      final BitmapDescriptor markerImage =
          await MapHelper.getMarkerImageFromUrl(_markerImageUrl);

      markers.add(
        MapMarker(
          id: _markerLocations.indexOf(markerLocation).toString(),
          position: markerLocation,
          icon: markerImage,
        ),
      );
    }

    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    );

    await _updateMarkers();
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  Future<void> _updateMarkers([double updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    setState(() {
      _areMarkersLoading = true;
    });

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      80,
    );

    _markers
      ..clear()
      ..addAll(updatedMarkers);

//    _lastMapPosition = position.target;

    setState(() {
      _areMarkersLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
//    _showDialog();

    return Scaffold(
      appBar: AppBar(
        title: Text('Help for Covid19'),
      ),
      body: Stack(
        children: <Widget>[
          // Google Map widget

          GoogleMap(
            zoomGesturesEnabled: true,
            myLocationEnabled: true,
            compassEnabled: true,
            myLocationButtonEnabled: false,
            polygons: polygon,
            mapToolbarEnabled: false,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: _currentZoom,
            ),
            markers: _markers,
            onMapCreated: (controller) => _onMapCreated(controller),
            onCameraMove: (position) => _updateMarkers(position.zoom),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
                margin: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          showMyDialog(context);
                        },
                        child: Icon(
                          Icons.info,
                          size: 45,
                        ),
                      ),
                    ),
                  ],
                )),
          ),

          // Map loading indicator
          Opacity(
            opacity: _isMapLoading ? 1 : 0,
            child: Center(child: CircularProgressIndicator()),
          ),

          // Map markers loading indicator
          if (_areMarkersLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Card(
                  elevation: 2,
                  color: Colors.grey.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'Loading',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

// user defined function
  void showMyDialog(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            'Don\'t worry you are on Green zone. Still maintain social distance for your safety.',
          ),
          title: Text('You are on Green Zone'),
          actions: <Widget>[
            FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
