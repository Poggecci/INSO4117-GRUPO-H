import 'package:test/test.dart';
import 'dart:math';
import 'utility.dart';
import 'models/volunteer.dart';
import 'models/shelter.dart';

class DummyMaker {
  Random random = Random();
  Shelter getRandomShelter(
      {id, name, email, phone, latitude, longitude, needs}) {
    return Shelter(
        id: id ?? random.nextInt(100),
        name: name ?? "Animal Shelter",
        email: email ?? "animalshelter@domain.com",
        phone: phone ?? "1112223333",
        latitude: latitude ?? random.nextDouble() * 360,
        longitude: longitude ?? random.nextDouble() * 360,
        needs: needs ?? List.empty());
  }

  Volunteer getRandomVolunteer(
      {id, name, email, phone, latitude, longitude, radius, resources}) {
    return Volunteer(
        id: id ?? random.nextInt(100),
        name: name ?? "Adam Smith",
        email: email ?? "adamn@domain.com",
        phone: phone ?? "1112223333",
        latitude: latitude ?? random.nextDouble() * 360,
        longitude: longitude ?? random.nextDouble() * 360,
        radius: radius ?? random.nextDouble() * 100,
        resources: resources ?? List.empty());
  }
}

void main() {
  DummyMaker testInstanceMaker = DummyMaker();
  Random random = Random();
  test(
      'getVolunteersInRange returns volunteers when volunteers is a single one and is at the shelter',
      () {
    double latitude = random.nextDouble() * 360;
    double longitude = random.nextDouble() * 360;
    Volunteer volunteer = testInstanceMaker.getRandomVolunteer(
        latitude: latitude, longitude: longitude, radius: 0.0);
    List<Volunteer> volunteers = [volunteer];
    Shelter shelter = testInstanceMaker.getRandomShelter(
        latitude: latitude, longitude: longitude);

    expect(getVolunteersInRange(shelter, volunteers), equals(volunteers));
  });

  test(
      'getVolunteersInRange returns any volunteers at the location of the shelter',
      () {
    double latitude = random.nextDouble() * 360;
    double longitude = random.nextDouble() * 360;
    Volunteer volunteerA = testInstanceMaker.getRandomVolunteer(
        latitude: latitude, longitude: longitude, radius: 0.0);
    Volunteer volunteerB = testInstanceMaker.getRandomVolunteer(
        latitude: latitude + 1, longitude: longitude + 1, radius: 0.0);
    List<Volunteer> volunteers = [volunteerA, volunteerB];
    Shelter shelter = testInstanceMaker.getRandomShelter(
        latitude: latitude, longitude: longitude);

    expect(getVolunteersInRange(shelter, volunteers), equals([volunteerA]));
  });

  test(
      'getVolunteersInRange returns any volunteers that are in range of the shelter',
      () {
    double shelterLat = random.nextDouble() * 360;
    double shelterLong = random.nextDouble() * 360;
    double volunteerLat = shelterLat + 1;
    double volunteerLong = shelterLong + 1;
    double distance = haversineDistanceInKm(
        shelterLat, shelterLong, volunteerLat, volunteerLong);
    Volunteer volunteerInRange = testInstanceMaker.getRandomVolunteer(
        latitude: volunteerLat, longitude: volunteerLong, radius: distance + 1);
    Volunteer volunteerOutofRange = testInstanceMaker.getRandomVolunteer(
        latitude: volunteerLat, longitude: volunteerLong, radius: 0.0);
    List<Volunteer> volunteers = [volunteerInRange, volunteerOutofRange];
    Shelter shelter = testInstanceMaker.getRandomShelter(
        latitude: shelterLat, longitude: shelterLong);
    expect(
        getVolunteersInRange(shelter, volunteers), equals([volunteerInRange]));
  });
}
