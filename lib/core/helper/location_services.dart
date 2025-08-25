
// Location service helper
import 'package:ecommerce_app/core/helper/map_config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  static Future<bool> checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  static Future<Position?> getCurrentPosition() async {
    try {
      bool hasPermission = await checkLocationPermission();
      if (!hasPermission) return null;

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      return null;
    }
  }

  static Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        
        List<String> addressParts = [];
        
        if (place.street != null && place.street!.isNotEmpty) {
          addressParts.add(place.street!);
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          addressParts.add(place.locality!);
        }
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
          addressParts.add(place.administrativeArea!);
        }
        if (place.country != null && place.country!.isNotEmpty) {
          addressParts.add(place.country!);
        }

        return addressParts.join(', ');
      }
    } catch (e) {
      // Fallback to coordinates if geocoding fails
      return 'Location: ${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
    }
    
    return 'Unknown location';
  }

  static Future<List<Location>?> searchLocation(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      return locations;
    } catch (e) {
      return null;
    }
  }

  static double calculateDistance(
    double lat1, double lon1,
    double lat2, double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }
}

// Delivery zones configuration
class DeliveryZones {
  static const double maxDeliveryRadius = 30000; // 30km in meters
  
  static bool isWithinDeliveryZone(double latitude, double longitude) {
    // Check if location is within delivery range from main hub (Cairo)
    double distance = LocationService.calculateDistance(
      MapsConfig.defaultLatitude,
      MapsConfig.defaultLongitude,
      latitude,
      longitude,
    );
    
    return distance <= maxDeliveryRadius;
  }
  
  static double calculateDeliveryFee(double latitude, double longitude) {
    double distance = LocationService.calculateDistance(
      MapsConfig.defaultLatitude,
      MapsConfig.defaultLongitude,
      latitude,
      longitude,
    );
    
    // Base delivery fee + distance-based fee
    double baseFee = 10.0;
    double distanceFee = (distance / 1000) * 0.5; // $0.5 per km
    
    return baseFee + distanceFee;
  }
}

// Location validation helper
class LocationValidator {
  static String? validateLocation(LatLng? location) {
    if (location == null) {
      return 'Please select a delivery location';
    }
    
    if (!DeliveryZones.isWithinDeliveryZone(
      location.latitude,
      location.longitude,
    )) {
      return 'Sorry, we don\'t deliver to this location yet';
    }
    
    return null; // Valid location
  }
}
