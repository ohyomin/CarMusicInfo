
import 'dart:typed_data';

class MusicInfo {
  final String title;
  final String artist;
  final Uint8List? albumArt;

  const MusicInfo({
    required this.title,
    required this.artist,
    this.albumArt,
  });

  MusicInfo.fromMap(Map<String, dynamic> map)
      : title = map['title'] ?? "",
        artist = map['artist'] ?? "",
        albumArt = map['albumArt'];

  static const MusicInfo empty = MusicInfo(
    title: '',
    artist: '',
  );

  @override
  String toString() {
    return 'title: $title, artist: $artist, album: ${albumArt?.length}';
  }
}