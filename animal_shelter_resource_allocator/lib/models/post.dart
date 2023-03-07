import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final String shelterName;
  final String title;
  final String description;
  final List<String> needs;

  const Post(
      {required this.id,
      required this.shelterName,
      required this.title,
      required this.description,
      required this.needs});

  @override
  List<Object?> get props => [id, shelterName, title, description, needs];

  @override
  bool get stringify => true;
}
