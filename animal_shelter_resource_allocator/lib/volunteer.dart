import 'package:equatable/equatable.dart';

class Volunteer extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone; // parsed as XXX-XXX-XXXX, only for US
  final double latitude; // Measured in degrees
  final double longitude; // Measured in degrees
  final double radius; // Measured in km
  final List<String> resources;

  const Volunteer({required this.id, 
                  required this.name, 
                  required this.email, 
                  required this.phone,
                  required this.latitude,
                  required this.longitude,
                  required this.radius,
                  required this.resources});

  @override
  List<Object?> get props => [id, 
                              name, 
                              email,
                              phone,
                              latitude,
                              longitude,
                              radius,
                              resources];

  @override
  bool get stringify => true;
}