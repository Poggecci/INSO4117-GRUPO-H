import 'package:equatable/equatable.dart';

class Shelter extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone; // parsed as XXX-XXX-XXXX, only for US
  final double latitude; // Measured in degrees
  final double longitude; // Measured in degrees
  final List<String> needs;

  const Shelter({required this.id, 
                  required this.name, 
                  required this.email, 
                  required this.phone,
                  required this.latitude,
                  required this.longitude,
                  required this.needs});

  @override
  List<Object?> get props => [id, 
                              name, 
                              email,
                              phone,
                              latitude,
                              longitude,
                              needs];

  @override
  bool get stringify => true;
}

