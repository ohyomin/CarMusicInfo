part of 'music_info_bloc.dart';

@immutable
class MusicInfoState {

  const MusicInfoState({
    required this.title,
    required this.artist,
    required this.albumArt,
    required this.isPlay,
    required this.albumArtHash,
    this.extra = '',
    this.isGrantPermission = false,
  });

  final String title;
  final String artist;
  final List<int> albumArt;
  final bool isPlay;
  final String albumArtHash;
  final String extra;
  final bool isGrantPermission;

  MusicInfoState copyWith({
    String? title,
    String? artist,
    List<int>? albumArt,
    bool? isPlay,
    String? albumArtHash,
    String? extra,
    bool? isPermissionGranted,
  }) {
    return MusicInfoState(
      title: title ?? this.title,
      artist: artist ?? this.artist,
      albumArt: albumArt ?? this.albumArt,
      isPlay: isPlay ?? this.isPlay,
      albumArtHash: albumArtHash ?? this.albumArtHash,
      extra: extra ?? this.extra,
      isGrantPermission: isPermissionGranted ?? this.isGrantPermission,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MusicInfoState
      && other.title == title
      && other.artist == artist
      && other.albumArtHash == albumArtHash
      && other.isPlay == isPlay
      && other.extra == extra
      && other.isGrantPermission == isGrantPermission;
  }

  @override
  int get hashCode => (
      title.hashCode +
      artist.hashCode +
      isPlay.hashCode +
      albumArtHash.hashCode +
      isGrantPermission.hashCode +
      extra.hashCode
  ).toInt();

  static const initState = MusicInfoState(
      title: '',
      artist: '',
      albumArt: <int>[],
      isPlay: false,
      albumArtHash: Constants.defaultBlurHash,
  );

  @override
  String toString() {
    return 'title:$title, permission: $isGrantPermission';
  }
}


