class Album {
  Album({
    this.albumId,
    this.id,
    this.title,
    this.url,
    this.thumbnailUrl,
  });

  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['albumId'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
    );
  }
}
