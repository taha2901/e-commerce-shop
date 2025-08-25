import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationPickerWidget extends StatefulWidget {
  final Function(LatLng, String) onLocationSelected;
  final LatLng? initialLocation;
  final String? initialAddress;

  const LocationPickerWidget({
    super.key,
    required this.onLocationSelected,
    this.initialLocation,
    this.initialAddress,
  });

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  GoogleMapController? _mapController;
  LatLng _currentLocation = const LatLng(30.0444, 31.2357);
  String _currentAddress = 'Select your location';
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  Set<Marker> _markers = {};
  List<String> _searchSuggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _currentLocation = widget.initialLocation!;
      _currentAddress = widget.initialAddress ?? 'Selected location';
      _updateMarker(_currentLocation);
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorSnackBar('Location permissions are denied');
          setState(() => _isLoading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showErrorSnackBar('Location permissions are permanently denied');
        setState(() => _isLoading = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng newLocation = LatLng(position.latitude, position.longitude);
      await _updateLocationAndAddress(newLocation);

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(newLocation, 16),
      );
    } catch (e) {
      _showErrorSnackBar('Failed to get current location: ${e.toString()}');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _updateLocationAndAddress(LatLng location) async {
    setState(() {
      _currentLocation = location;
      _updateMarker(location);
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address =
            '${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}';
        setState(() => _currentAddress =
            address.trim().replaceAll(RegExp(r'^,\s*'), ''));
      }
    } catch (_) {
      setState(() => _currentAddress =
          'Location: ${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}');
    }
  }

  void _updateMarker(LatLng location) {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: location,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: 'Selected Location', snippet: _currentAddress),
        ),
      };
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8.w),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 2,
        shadowColor: theme.shadowColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Choose Location', style: theme.textTheme.titleMedium),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: CameraPosition(target: _currentLocation, zoom: 16),
            markers: _markers,
            onTap: (location) async {
              setState(() => _isLoading = true);
              await _updateLocationAndAddress(location);
              setState(() => _isLoading = false);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // Search bar & suggestions
          Positioned(
            top: 16.h,
            left: 16.w,
            right: 16.w,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor!.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for a location...',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                      prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: theme.iconTheme.color),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchSuggestions = [];
                                  _showSuggestions = false;
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                      filled: true,
                      fillColor: theme.cardColor,
                    ),
                    onSubmitted: (value) => _searchLocation(value),
                    onChanged: (value) => setState(() => _showSuggestions = value.isNotEmpty),
                  ),
                ),
              ],
            ),
          ),

          // Confirm Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                boxShadow: [BoxShadow(color: theme.shadowColor!.withOpacity(0.1), spreadRadius: 2, blurRadius: 10, offset: const Offset(0, -2))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Selected Location', style: theme.textTheme.titleMedium),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Text(
                      _currentAddress,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onLocationSelected(_currentLocation, _currentAddress);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text('Confirm Location', style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        LatLng newLocation = LatLng(locations[0].latitude, locations[0].longitude);
        await _updateLocationAndAddress(newLocation);
        _mapController?.animateCamera(CameraUpdate.newLatLngZoom(newLocation, 16));
        _searchController.clear();
        FocusScope.of(context).unfocus();
      }
    } catch (_) {
      _showErrorSnackBar('Location not found');
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }
}
