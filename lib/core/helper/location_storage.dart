
// Location storage for persistence
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocationStorage {
  static const String _locationKey = 'saved_location';
  static const String _addressKey = 'saved_address';

  static Future<void> saveLocation(LatLng location, String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_locationKey, jsonEncode({
      'latitude': location.latitude,
      'longitude': location.longitude,
    }));
    await prefs.setString(_addressKey, address);
  }

  static Future<Map<String, dynamic>?> getSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final locationJson = prefs.getString(_locationKey);
    final address = prefs.getString(_addressKey);

    if (locationJson != null && address != null) {
      final locationData = jsonDecode(locationJson);
      return {
        'location': LatLng(
          locationData['latitude'],
          locationData['longitude'],
        ),
        'address': address,
      };
    }
    return null;
  }

  static Future<void> clearSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_locationKey);
    await prefs.remove(_addressKey);
  }
}