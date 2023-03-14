import 'package:animal_shelter_resource_allocator/models/shelter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final String shelterId;
  final String title;
  final String description;
  final List<String> needs;
  final Timestamp createdAt;
  final List<String> visibleTo;

  const Post(
      {required this.id,
      required this.shelterId,
      required this.title,
      required this.description,
      required this.needs,
      required this.createdAt,
      required this.visibleTo});

  @override
  List<Object?> get props =>
      [id, shelterId, title, description, needs, createdAt, visibleTo];

  @override
  bool get stringify => true;

  factory Post.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Post(
      id: snapshot.id,
      shelterId: data?['shelterId'],
      title: data?['title'],
      description: data?['description'],
      needs: data?['needs'] is Iterable ? List.from(data?['needs']) : [],
      createdAt: data?['createdAt'],
      visibleTo:
          data?['visibleTo'] is Iterable ? List.from(data?['visibleTo']) : [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (shelterId != null) "shelterId": shelterId,
      if (title != null) "title": title,
      if (description != null) "description": description,
      if (needs != null) "needs": needs,
      if (createdAt != null) "createdAt": createdAt,
      if (visibleTo != null) "visibleTo": visibleTo,
    };
  }
}

class ViewPost extends Post {
  final String shelterName;
  const ViewPost(
      {required String id,
      required String shelterId,
      required String title,
      required String description,
      required List<String> needs,
      required Timestamp createdAt,
      required List<String> visibleTo,
      required this.shelterName})
      : super(
            id: id,
            shelterId: shelterId,
            title: title,
            description: description,
            needs: needs,
            createdAt: createdAt,
            visibleTo: visibleTo);

  @override
  List<Object?> get props => super.props + [shelterName];

  @override
  bool get stringify => true;
}
