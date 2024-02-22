import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String? ownerId;
  final String? id;
  final String? title;
  final String? description;
  final String? imageURL;

  const PostModel({
    required this.ownerId,
    required this.id,
    required this.title,
    required this.description,
    required this.imageURL,
  });

  Map<String, dynamic> toJson() {
    return {
      'ownerId': ownerId,
      'id': id,
      'title': title,
      'description': description,
      'imageURL': imageURL,
    };
  }

  factory PostModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return PostModel(
      ownerId: data['ownerId'],
      id: data['id'],
      title: data['title'],
      description: data['description'],
      imageURL: data['imageURL'],
    );
  }
}
