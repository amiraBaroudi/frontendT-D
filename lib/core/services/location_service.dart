import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../errors/exceptions.dart';

class LocationService {
  Future<LatLng> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException(message: 'يرجى تفعيل خدمة الموقع');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationException(message: 'تم رفض الإذن للوصول للموقع');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
        message: 'يرجى السماح بالوصول للموقع من إعدادات التطبيق',
      );
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10),
    );

    return LatLng(position.latitude, position.longitude);
  }

  Stream<LatLng> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).map((pos) => LatLng(pos.latitude, pos.longitude));
  }

  Future<bool> hasPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  double distanceBetween(LatLng from, LatLng to) {
    final meters = Geolocator.distanceBetween(
      from.latitude, from.longitude,
      to.latitude, to.longitude,
    );
    return meters / 1000;
  }
}
