import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kivicare_clinic_admin/utils/local_storage.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../utils/constants.dart';

Future<Position> getUserLocationPosition() async {
  final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw locale.value.enableLocation;
  }

  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.denied) {
    throw locale.value.locationPermissionDenied;
  }

  if (permission == LocationPermission.deniedForever) {
    throw '${locale.value.location} ${locale.value.permissionDeniedPermanently}';
  }

  try {
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  } catch (_) {
    final Position? fallback = await Geolocator.getLastKnownPosition();
    if (fallback != null) return fallback;

    throw locale.value.enableLocation;
  }
}

Future<String> getUserLocation() async {
  final Position position = await getUserLocationPosition();

  return buildFullAddressFromLatLong(position.latitude, position.longitude);
}

Future<String> buildFullAddressFromLatLong(
    double latitude, double longitude) async {
  final List<Placemark> placeMark;
  try {
    placeMark = await placemarkFromCoordinates(latitude, longitude);
  } catch (e) {
    log(e);
    throw errorSomethingWentWrong;
  }

  if (placeMark.isEmpty) {
    throw errorSomethingWentWrong;
  }

  setValueToLocal(LocatinKeys.LATITUDE, latitude);
  setValueToLocal(LocatinKeys.LONGITUDE, longitude);

  final Placemark place = placeMark[0];

  log(place.toJson());

  final List<String> addressParts = [];

  if (!place.name.isEmptyOrNull &&
      !place.street.isEmptyOrNull &&
      place.name != place.street) {
    addressParts.add(place.name.validate());
  }
  if (!place.street.isEmptyOrNull) {
    addressParts.add(place.street.validate());
  }
  if (!place.locality.isEmptyOrNull) {
    addressParts.add(place.locality.validate());
  }
  if (!place.administrativeArea.isEmptyOrNull) {
    addressParts.add(place.administrativeArea.validate());
  }
  if (!place.postalCode.isEmptyOrNull) {
    addressParts.add(place.postalCode.validate());
  }
  if (!place.country.isEmptyOrNull) {
    addressParts.add(place.country.validate());
  }

  final String address = addressParts.join(', ');

  setValueToLocal(LocatinKeys.CURRENT_ADDRESS, address);
  setValueToLocal(LocatinKeys.ZIP_CODE, place.postalCode.validate());

  return address;
}
