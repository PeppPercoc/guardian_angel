import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  // singleton
  LocationService._internal();
  static final LocationService instance = LocationService._internal();
  factory LocationService() => instance;

  Future<bool> _handlePermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
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

  Future<Position?> getCurrentPosition() async {
    bool hasPermission = await _handlePermission();
    if (!hasPermission) return null;

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  Future<String?> getCurrentPositionString() async {
    Position? pos = await getCurrentPosition();
    if (pos == null) {
      return "Permesso negato o nessuna posizione trovata.";
    } else {
      List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.street}, ${place.locality}, ${place.country}';
      } else {
        return 'Posizione non trovata';
      }
    }
  }
}
