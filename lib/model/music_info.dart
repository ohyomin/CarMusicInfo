
import 'dart:typed_data';

class MusicInfo {
  final String title;
  final String artist;
  final Uint8List? albumArt;
  final bool isPlay;

  const MusicInfo({
    required this.title,
    required this.artist,
    this.albumArt,
    this.isPlay = false,
  });

  MusicInfo.fromMap(Map<String, dynamic> map)
      : title = map['title'] ?? "",
        artist = map['artist'] ?? "",
        isPlay = map['isPlay'] == 1 ? true : false,
        albumArt = map['albumArt'];

  static const MusicInfo empty = MusicInfo(
    title: '',
    artist: '',
    isPlay: false,
  );

  @override
  String toString() {
    return 'title: $title, artist: $artist, album: ${albumArt?.length}, isPlay: $isPlay';
  }
}