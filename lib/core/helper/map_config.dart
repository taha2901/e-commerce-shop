// maps_config.dart
class MapsConfig {
  static const String googleMapsApiKey = 'AIzaSyDhDTdS1TbmYZKTAts3xY1YPOEWmvrR4ls';
  
  // Default locations (Egypt focus)
  static const double defaultLatitude = 30.0444; // Cairo
  static const double defaultLongitude = 31.2357;
  
  // Map settings
  static const double defaultZoom = 16.0;
  static const double searchZoom = 18.0;
  
  // Common Egyptian cities for suggestions
  static const List<String> popularCities = [
    'Cairo, Egypt',
    'Alexandria, Egypt',
    'Giza, Egypt',
    'Sharm El Sheikh, Egypt',
    'Hurghada, Egypt',
    'Luxor, Egypt',
    'Aswan, Egypt',
    'Port Said, Egypt',
    'Suez, Egypt',
    'Mansoura, Egypt',
  ];
}
