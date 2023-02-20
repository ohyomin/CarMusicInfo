part of 'music_info_bloc.dart';

@immutable
class MusicInfoState {

  const MusicInfoState({
    required this.title,
    required this.artist,
    required this.albumArt,
    required this.isPlay,
    required this.albumArtHash,
  });

  final String title;
  final String artist;
  final List<int> albumArt;
  final bool isPlay;
  final String albumArtHash;

  MusicInfoState copyWith({
    String? title,
    String? artist,
    List<int>? albumArt,
    bool? isPlay,
    String? albumArtHash,
  }) {
    return MusicInfoState(
      title: title ?? this.title,
      artist: artist ?? this.artist,
      albumArt: albumArt ?? this.albumArt,
      isPlay: isPlay ?? this.isPlay,
      albumArtHash: albumArtHash ?? this.albumArtHash,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MusicInfoState
      && other.title == title
      && other.artist == artist
      && other.albumArtHash == albumArtHash
      && other.isPlay == isPlay;
  }

  @override
  int get hashCode => (
      title.hashCode + artist.hashCode
          + isPlay.hashCode + albumArtHash.hashCode).toInt();

  static const MusicInfoState initState = MusicInfoState(
      title: '',
      artist: '',
      albumArt: <int>[],
      isPlay: false,
      albumArtHash: Constants.defaultBlurHash,
  );
}


