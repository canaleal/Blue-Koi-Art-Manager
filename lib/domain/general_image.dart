import 'dart:convert';



class GeneralImage {

  final String id;
  final String urlFull;
  final String urlThumb;
  final String author;
  final String title;
  final String date;
  GeneralImage({
    required this.id,
    required this.urlFull,
    required this.urlThumb,
    required this.author,
    required this.title,
    required this.date,
  });



  GeneralImage copyWith({
    String? id,
    String? urlFull,
    String? urlThumb,
    String? author,
    String? title,
    String? date,
  }) {
    return GeneralImage(
      id: id ?? this.id,
      urlFull: urlFull ?? this.urlFull,
      urlThumb: urlThumb ?? this.urlThumb,
      author: author ?? this.author,
      title: title ?? this.title,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'urlFull': urlFull,
      'urlThumb': urlThumb,
      'author': author,
      'title': title,
      'date': date,
    };
  }

  factory GeneralImage.fromMap(Map<String, dynamic> map) {
    return GeneralImage(
      id: map['id'] ?? '',
      urlFull: map['urlFull'] ?? '',
      urlThumb: map['urlThumb'] ?? '',
      author: map['author'] ?? '',
      title: map['title'] ?? '',
      date: map['date'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GeneralImage.fromJson(String source) => GeneralImage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GeneralImage(id: $id, urlFull: $urlFull, urlThumb: $urlThumb, author: $author, title: $title, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is GeneralImage &&
      other.id == id &&
      other.urlFull == urlFull &&
      other.urlThumb == urlThumb &&
      other.author == author &&
      other.title == title &&
      other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      urlFull.hashCode ^
      urlThumb.hashCode ^
      author.hashCode ^
      title.hashCode ^
      date.hashCode;
  }
}
