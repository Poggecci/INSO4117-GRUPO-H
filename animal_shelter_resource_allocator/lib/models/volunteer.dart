import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Volunteer extends Equatable {
  final String id;
  final String? name;
  final String? email;
  final String? phone; // parsed as XXX-XXX-XXXX, only for US
  final String? address;
  final double? latitude; // Measured in degrees
  final double? longitude; // Measured in degrees
  final double? radius; // Measured in km
  final List<String>? resources;

  const Volunteer(
      {required this.id,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.latitude,
      this.longitude,
      this.radius,
      this.resources});

  @override
  List<Object?> get props =>
      [id, name, email, phone, address, latitude, longitude, radius, resources];

  @override
  bool get stringify => true;

  factory Volunteer.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Volunteer(
      id: snapshot.id,
      name: data?['name'],
      email: data?['email'],
      phone: data?['phone'],
      address: data?['address'],
      latitude: data?['latitude'],
      longitude: data?['longitude'],
      radius: data?['radius'],
      resources:
          data?['resources'] is Iterable ? List.from(data?['resources']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "type": "Volunteer",
      if (name != null) "name": name,
      if (email != null) "email": email,
      if (phone != null) "phone": phone,
      if (address != null) "address": address,
      if (latitude != null) "latitude": latitude,
      if (longitude != null) "longitude": longitude,
      if (radius != null) "longitude": radius,
      if (resources != null) "needs": resources,
    };
  }
}
