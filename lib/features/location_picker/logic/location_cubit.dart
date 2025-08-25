import 'package:ecommerce_app/features/location_picker/logic/location_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  LatLng? _selectedLocation;
  String? _selectedAddress;

  LatLng? get selectedLocation => _selectedLocation;
  String? get selectedAddress => _selectedAddress;

  void selectLocation(LatLng location, String address) {
    _selectedLocation = location;
    _selectedAddress = address;
    emit(LocationSelected(location: location, address: address));
  }

  void clearLocation() {
    _selectedLocation = null;
    _selectedAddress = null;
    emit(LocationInitial());
  }

  bool get hasLocation => _selectedLocation != null;
}

// Location Model
class UserLocation {
  final LatLng coordinates;
  final String address;
  final String? city;
  final String? country;
  final String? name; // Optional field for a user-friendly
  //name


  const UserLocation({
    required this.coordinates,
    required this.address,
    this.city,
    this.name,
    this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
      'address': address,
      'city': city,
      'name': name,
      'country': country,
    };
  }

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      coordinates: LatLng(json['latitude'], json['longitude']),
      address: json['address'],
      city: json['city'],
      name: json['name'],
      country: json['country'],
    );
  }
}