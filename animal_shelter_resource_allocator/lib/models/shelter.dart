import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Shelter extends Equatable {
  final String id;
  final String? name;
  final String? email;
  final String? phone; // parsed as XXX-XXX-XXXX, only for US
  final String? address;
  final double? latitude; // Measured in degrees
  final double? longitude; // Measured in degrees
  final List<String>? needs;

  const Shelter(
      {required this.id,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.latitude,
      this.longitude,
      this.needs});

  @override
  List<Object?> get props =>
      [id, name, email, phone, address, latitude, longitude, needs];

  @override
  bool get stringify => true;

  factory Shelter.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Shelter(
      id: snapshot.id,
      name: data?['name'],
      email: data?['email'],
      phone: data?['phone'],
      address: data?['address'],
      latitude: data?['latitude'],
      longitude: data?['longitude'],
      needs: data?['needs'] is Iterable ? List.from(data?['needs']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "type": "Shelter",
      if (name != null) "name": name,
      if (email != null) "email": email,
      if (phone != null) "phone": phone,
      if (address != null) "address": address,
      if (latitude != null) "latitude": latitude,
      if (longitude != null) "longitude": longitude,
      if (needs != null) "needs": needs,
    };
  }
}
