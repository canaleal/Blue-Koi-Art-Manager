class UnImage {
  final int id;
  final String username;
  final String url;

  UnImage({
    required this.id,
    required this.username,
    required this.url,
  });

  // Convert a Image into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'url': url,
    };
  }

  // Implement toString to make it easier to see information about
  // each image when using the print statement.
  @override
  String toString() {
    return 'UnImage{id: $id, username: $username, url: $url}';
  }
}