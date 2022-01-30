

import 'dart:convert';

import 'package:flutter_test_bed/domain/general_image.dart';

class UnsplashImage extends GeneralImage {

  final String options;
  UnsplashImage({
    id,
    urlFull,
    urlThumb,
    author,
    title,
    date,
    required this.options,
  }): super(id: id, urlFull: urlFull, urlThumb: urlThumb, author: author, title: title, date: date);


  @override
  UnsplashImage copyWith({
    String? id,
    String? urlFull,
    String? urlThumb,
    String? author,
    String? title,
    String? date,
    String? options,
  }) {
    return UnsplashImage(
      id: id ?? this.id,
      urlFull: urlFull ?? this.urlFull,
      urlThumb: urlThumb ?? this.urlThumb,
      author: author ?? this.author,
      title: title ?? this.title,
      date: date ?? this.date,
      options: options ?? this.options,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'urlFull': urlFull,
      'urlThumb': urlThumb,
      'author': author,
      'title': title,
      'date': date,
      'options': options,
    };
  }

  factory UnsplashImage.fromMap(Map<String, dynamic> map) {
    return UnsplashImage(
      id: map['id'] ?? '',
      urlFull: map['urls']['raw'] ?? '',
      urlThumb: map['urls']['thumb'] ?? '',
      author: map['user']['username'] ?? '',
      title: map['description'] ?? '',
      date: map['created_at'] ?? '',
      options: map['liked_by_user']?.toString() ?? '',
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory UnsplashImage.fromJson(String source) => UnsplashImage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UnsplashImage(id: $id, urlFull: $urlFull, urlThumb: $urlThumb, author: $author, title: $title, date: $date, options: $options)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UnsplashImage &&
      other.id == id &&
      other.urlFull == urlFull &&
      other.urlThumb == urlThumb &&
      other.author == author &&
      other.title == title &&
      other.date == date &&
      other.options == options;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      urlFull.hashCode ^
      urlThumb.hashCode ^
      author.hashCode ^
      title.hashCode ^
      date.hashCode ^
      options.hashCode;
  }
}
