import 'models/shelter.dart';
import 'models/volunteer.dart';
import 'dart:math';

double haversineDistanceInKm(
    double lat1, double lon1, double lat2, double lon2) {
  const earthRadiusKm = 6371;
  final radLatitudeDiff = _degreesToRadians(lat2 - lat1);
  final radLongitudeDiff = _degreesToRadians(lon2 - lon1);
  final radLatitude1 = _degreesToRadians(lat1);
  final radLatitude2 = _degreesToRadians(lat2);
  final a = pow(sin(radLatitudeDiff / 2), 2) +
      pow(sin(radLongitudeDiff / 2), 2) * cos(radLatitude1) * cos(radLatitude2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadiusKm * c;
}

double _degreesToRadians(double degrees) {
  return degrees * pi / 180;
}

List<Volunteer> getVolunteersInRange(
    Shelter shelter, List<Volunteer> volunteers) {
  List<Volunteer> inRange = List.empty(growable: true);
  for (Volunteer volunteer in volunteers) {
    double radius = volunteer.radius ?? 0.0;
    double distance = haversineDistanceInKm(
        volunteer.latitude ?? 0.0,
        volunteer.longitude ?? 0.0,
        shelter.latitude ?? 0.0,
        shelter.longitude ?? 0.0);
    if (distance <= radius) {
      inRange.add(volunteer);
    }
  }
  return inRange;
}
