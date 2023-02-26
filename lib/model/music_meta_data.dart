import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import '../core/constants.dart';

@immutable
class MusicMetaData {

  const MusicMetaData({
    required this.title,
    required this.artist,
    required this.albumArt,
    required this.albumArtHash,
  });

  final String title;
  final String artist;
  final List<int> albumArt;
  final String albumArtHash;

  static Future<MusicMetaData> fromMap(Map<String, dynamic> map) async {
    String title = map['title'] ?? '';
    String artist = map['artist'] ?? '';
    List<int> albumArt = map['albumArt'] ?? <int>[];

    String albumArtHash = await compute<List<int>, String>(_getBlurHash, albumArt);

    return MusicMetaData(
      title: title,
      artist: artist,
      albumArt: albumArt,
      albumArtHash: albumArtHash,
    );
  }

  static const MusicMetaData initData = MusicMetaData(
    title: '',
    artist: '',
    albumArt: <int>[],
    albumArtHash: Constants.defaultBlurHash,
  );

  static String _getBlurHash(List<int> albumArt) {
    if (albumArt.isEmpty) return Constants.defaultBlurHash;

    final decodedImg = img.decodeImage(Uint8List.fromList(albumArt));
    if (decodedImg == null) return Constants.defaultBlurHash;

    return BlurHash.encode(decodedImg, numCompX: 5, numCompY: 5).hash;
  }

  @override
  bool operator ==(Object other) {
    return other is MusicMetaData
        && title == other.title
        && artist == other.artist
        && albumArtHash == other.albumArtHash;
  }

  @override
  int get hashCode =>
      title.hashCode + artist.hashCode + albumArtHash.hashCode;
}