

import 'dart:convert';

import 'package:flutter_test_bed/domain/general_image.dart';

class ArtStationImage extends GeneralImage {


  final String options;
  
  ArtStationImage({
    id,
    urlFull,
    urlThumb,
    author,
    title,
    date,
    required this.options,
  }): super(id: id, urlFull: urlFull, urlThumb: urlThumb, author: author, title: title, date: date);
  
   
  

  @override
  ArtStationImage copyWith({
    String? id,
    String? urlFull,
    String? urlThumb,
    String? author,
    String? title,
    String? date,
    String? options,
  }) {
    return ArtStationImage(
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

  factory ArtStationImage.fromMap(Map<String, dynamic> map) {
    return ArtStationImage(
      id: map['id']?.toString() ?? '',
      urlFull: map['permalink'] ?? '',
      urlThumb: map['cover']['thumb_url'] ?? '',
      author: map['user']['username'] ?? '',
      title: map['title'] ?? '',
      date: map['created_at'] ?? '',
      options: map['adult_content']?.toString() ?? '',
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory ArtStationImage.fromJson(String source) => ArtStationImage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ArtStationImage(id: $id, urlFull: $urlFull, urlThumb: $urlThumb, author: $author, title: $title, date: $date, options: $options)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ArtStationImage &&
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
