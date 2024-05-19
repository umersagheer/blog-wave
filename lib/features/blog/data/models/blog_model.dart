import 'dart:js_interop';

import 'package:blog_wave/features/blog/domain/entitites/blog.dart';

class BlogModel extends Blog {
  BlogModel(
      {required super.id,
      required super.title,
      required super.userId,
      required super.content,
      required super.imageURL,
      required super.topics,
      required super.updatedAt,
      super.posterName});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "title": title,
      "user_id": userId,
      "content": content,
      "image_url": imageURL,
      "topics": topics,
      "updated_at": updatedAt.toIso8601String(),
    };
  }

  factory BlogModel.fromJson(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] as String,
      title: map['title'] as String,
      userId: map['user_id'] as String,
      content: map['content'] as String,
      imageURL: map['image_url'] as String,
      topics: List<String>.from(map['topics'] ?? []),
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
    );
  }

  BlogModel copyWith(
      {String? id,
      String? title,
      String? userId,
      String? content,
      String? imageURL,
      List<String>? topics,
      DateTime? updatedAt,
      String? posterName}) {
    return BlogModel(
      id: id ?? this.id,
      title: title ?? this.title,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      imageURL: imageURL ?? this.imageURL,
      topics: topics ?? this.topics,
      updatedAt: updatedAt ?? this.updatedAt,
      posterName: posterName ?? this.posterName,
    );
  }
}
