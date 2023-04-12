import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/components/favorites.dart';
import 'package:frontend/components/settings.dart';
import 'package:frontend/components/show_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Settings;
import '../main.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:permission_handler/permission_handler.dart';

class MyMap extends StatefulWidget {
  const MyMap({super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  @override
  void initState() {
    super.initState();
  }

  bool _showPageVisible = false;

  bool _menu = false;
  bool _searching = false;
  final TextEditingController _searchController = TextEditingController();
  MapboxMap? mapboxMap;
  var isLight = true;

  void _toggleShowPage() {
    setState(() {
      _showPageVisible = !_showPageVisible;
    });
    print('_toggleShowPage - _showPageVisible: $_showPageVisible');
  }

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    mapboxMap.subscribe(_eventObserver, [
      MapEvents.STYLE_LOADED,
      MapEvents.MAP_LOADED,
      MapEvents.MAP_IDLE,
    ]);

    var response = (await http.get(Uri.parse("http://10.0.2.2:5000/heat-map")));
    var jsonData = jsonDecode(response.body);

    mapboxMap.style.addSource(GeoJsonSource(
      id: "source",
      data: jsonEncode(jsonData),
    ));

    mapboxMap.style.addLayer(HeatmapLayer(
      id: 'layer',
      sourceId: 'source',
      minZoom: 1.0,
      maxZoom: 20.0,
    ));
    mapboxMap.location.updateSettings(LocationComponentSettings(enabled: true));
  }

  late StreamSubscription<geolocator.Position> _positionStreamSubscription;
  void startListeningToLocationUpdates() {
    _positionStreamSubscription =
        geolocator.Geolocator.getPositionStream().listen((position) {
      mapboxMap?.setCamera(CameraOptions(
        center: Point(
            coordinates: Position(
          position.longitude,
          position.latitude,
        )).toJson(),
        zoom: 16,
      ));

      print(position == null
          ? 'Unknown'
          : position.latitude.toString() +
              ', ' +
              position.longitude.toString());
    });
  }

  void checkPermissions() {
    geolocator.Geolocator.checkPermission()
        .then((geolocator.LocationPermission permission) {
      if (permission == geolocator.LocationPermission.denied) {
        requestPermissions();
      } else {
        // startListeningToLocationUpdates();
        geolocator.Geolocator.getCurrentPosition().then((position) {
          mapboxMap?.easeTo(
              CameraOptions(
                center: Point(
                    coordinates: Position(
                  position.longitude,
                  position.latitude,
                )).toJson(),
                zoom: 13,
              ),
              MapAnimationOptions(duration: 2000));
        });
      }
    });
  }

  void requestPermissions() async {
    var status = await Permission.locationWhenInUse.request();
    print("Location granted : $status");
  }

  void handleLocationUpdates() {
    checkPermissions();
  }

  Future<double> getCurrentZoom() async {
    final value = await mapboxMap?.getCameraState();
    if (value != null) {
      return value.zoom;
    }
    return 0;
  }

  // _handleTap(OnMapTapListener data) async {
  //   geolocator.Position currentPosition =
  //       await geolocator.Geolocator.getCurrentPosition();
  //   String latitude = currentPosition.latitude.toString();
  //   String longitude = currentPosition.longitude.toString();
  //   final response = await http.get(
  //     Uri.parse(
  //         'http://10.0.2.2:5000/closest-venue?lat=$latitude&long=$longitude%27'),
  //   );
  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> data = jsonDecode(response.body);
  //     List<dynamic> results = data['results'];
  //     print('Venues: ${jsonEncode(results)}');
  //     // format show page
  //     setState(() {
  //       _showPageVisible = true;
  //     });
  //     // Process the results as necessary
  //   } else {
  //     // Handle any errors
  //     print("No venues found nearby");
  //   }
  // }

  void handleZoomOut() async {
    final value = await getCurrentZoom();
    zoomChange(value - 1);
  }

  void handleZoomIn() async {
    final value = await getCurrentZoom();
    zoomChange(value + 1);
  }

  void zoomChange(double zoom) {
    mapboxMap?.setCamera(CameraOptions(zoom: zoom));
  }

  _eventObserver(Event event) {
    print("Receive event, type: ${event.type}, data: ${event.data}");
  }

  _onStyleLoadedCallback(StyleLoadedEventData data) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Style loaded :), begin: ${data.begin}"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 1),
    ));
  }

  _onCameraChangeListener(CameraChangedEventData data) {
    // print("CameraChangedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onMapIdleListener(MapIdleEventData data) {
    // print("MapIdleEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onMapLoadedListener(MapLoadedEventData data) {
    // print("MapLoadedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onMapLoadingErrorListener(MapLoadingErrorEventData data) {
    // print("MapLoadingErrorEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onRenderFrameStartedListener(RenderFrameStartedEventData data) {
    // print("RenderFrameStartedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onRenderFrameFinishedListener(RenderFrameFinishedEventData data) {
    // print("RenderFrameFinishedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onSourceAddedListener(SourceAddedEventData data) {
    // print("SourceAddedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onSourceDataLoadedListener(SourceDataLoadedEventData data) {
    // print("SourceDataLoadedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onSourceRemovedListener(SourceRemovedEventData data) {
    // print("SourceRemovedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onStyleDataLoadedListener(StyleDataLoadedEventData data) {
    // print("StyleDataLoadedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onStyleImageMissingListener(StyleImageMissingEventData data) {
    // print("StyleImageMissingEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onStyleImageUnusedListener(StyleImageUnusedEventData data) {
    // print("StyleImageUnusedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(

        children: [
          MapWidget(
            key: ValueKey("mapWidget"),
            resourceOptions: ResourceOptions(accessToken: MyApp.ACCESS_TOKEN),
            cameraOptions: CameraOptions(
                center: Point(
                    coordinates: Position(
                  6.0033416748046875,
                  43.70908256335716,
                )).toJson(),
                zoom: 3.0),
            styleUri: MapboxStyles.MAPBOX_STREETS,
            textureView: true,
            onMapCreated: _onMapCreated,
            onStyleLoadedListener: _onStyleLoadedCallback,
            onCameraChangeListener: _onCameraChangeListener,
            onMapIdleListener: _onMapIdleListener,
            onMapLoadedListener: _onMapLoadedListener,
            onMapLoadErrorListener: _onMapLoadingErrorListener,
            onRenderFrameStartedListener: _onRenderFrameStartedListener,
            onRenderFrameFinishedListener: _onRenderFrameFinishedListener,
            onSourceAddedListener: _onSourceAddedListener,
            onSourceDataLoadedListener: _onSourceDataLoadedListener,
            onSourceRemovedListener: _onSourceRemovedListener,
            onStyleDataLoadedListener: _onStyleDataLoadedListener,
            onStyleImageMissingListener: _onStyleImageMissingListener,
            onStyleImageUnusedListener: _onStyleImageUnusedListener,
            // onTapListener: _handleTap,
          ),
          Positioned(
            top: 32,
            right: 8,
            child: _searching
                ? Container(
                    width: MediaQuery.of(context).size.width - 120,
                    height: 40,
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        filled: true,
                        // fillColor: Colors.white,
                        hintText: 'Enter search',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searching = false;
                            });
                          },
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 8), // adjust vertical padding
                      ),
                      style: GoogleFonts.montserrat(
                        // color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _searching = true;
                      });
                    },
                    child: const Icon(Icons.search),
                  ),
          ),
          Positioned(
            top: 32,
            left: 8,
            child: _menu
                ? SizedBox(
                    width: 64,
                    height: MediaQuery.of(context).size.height - 40,
                    child: ListView(
                      // Important: Remove any padding from the ListView.
                      padding: EdgeInsets.zero,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle button press
                            setState(() {
                              _menu = false;
                            });
                          },
                          child: const Icon(Icons.menu, size: 30),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.home,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Update the state of the app
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Favorites()));
                            // Then close the drawer
                            // Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.star,
                            size: 30,
                            color: Colors.yellow,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Update the state of the app
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Settings()));
                            // Then close the drawer
                            // Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.settings,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ElevatedButton(
                    onPressed: () {
                      // Handle button press
                      setState(() {
                        _menu = true;
                      });
                    },
                    child: const Icon(Icons.menu, size: 30),
                  ),
          ),
          Positioned(
            bottom: 32,
            right: 8,
            child: ElevatedButton(
              onPressed: () {
                // Handle button press
                // startListeningToLocationUpdates();
                handleLocationUpdates();
              },
              child: const Icon(Icons.location_searching, size: 30),
            ),
          ),
          Positioned(
            bottom: 110,
            right: 8,
            child: ElevatedButton(
              onPressed: () {
                // Handle button press
                // zoom in
                handleZoomIn();
              },
              child: const Icon(Icons.zoom_in, size: 30),
            ),
          ),
          Positioned(
            bottom: 70,
            right: 8,
            child: ElevatedButton(
              onPressed: () {
                // Handle button press
                // zoom out
                handleZoomOut();
              },
              child: const Icon(Icons.zoom_out, size: 30),
            ),
          ),
          if (_showPageVisible)
            ShowPage(
              onClose: _toggleShowPage,
              onAddToFavorites: () {
                // Implement add to favorites functionality
              },
            ),
        ],
      ),
    );
  }
}
