import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  // Singleton
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

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 0,
          timeLimit: Duration(seconds: 30),
        ),
      );
      return position;
    } catch (e) {
      // Se getCurrentPosition fallisce, prova con last known position
      try {
        final lastPosition = await Geolocator.getLastKnownPosition();
        return lastPosition;
      } catch (e) {
        return null;
      }
    }
  }

  Future<String?> getCurrentPositionString() async {
    Position? pos = await getCurrentPosition();
    if (pos == null) {
      return "Permesso negato o nessuna posizione trovata.";
    }

    try {
      final placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => [],
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        return '${place.street}, ${place.locality}, ${place.country}';
      } else {
        return 'Posizione non trovata';
      }
    } catch (e) {
      // Fallback: ritorna solo lat/long se geocoding fallisce
      return 'Lat: ${pos.latitude.toStringAsFixed(6)}, Long: ${pos.longitude.toStringAsFixed(6)}';
    }
  }

  Future<String?> getCurrentPositionStringLatLong() async {
    Position? pos = await getCurrentPosition();
    if (pos == null) {
      return "Permesso negato o nessuna posizione trovata.";
    }
    return 'Lat: ${pos.latitude.toStringAsFixed(6)}, Long: ${pos.longitude.toStringAsFixed(6)}';
  }
}
