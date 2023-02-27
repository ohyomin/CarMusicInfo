part of 'music_info_bloc.dart';

@immutable
class MusicInfoState {

  const MusicInfoState({
    this.metaData = MusicMetaData.initData,
    this.isPlay = false,
    this.isGrantedPermission = true,
    this.albumArtScaleIndex = 0,
  });

  final MusicMetaData metaData;
  final bool isPlay;
  final bool isGrantedPermission;
  final int albumArtScaleIndex;

  MusicInfoState copyWith({
    MusicMetaData? metaData,
    bool? isPlay,
    bool? isGrantedPermission,
    int? albumArtScaleIndex,
  }) {
    return MusicInfoState(
      metaData: metaData ?? this.metaData,
      isPlay: isPlay ?? this.isPlay,
      isGrantedPermission: isGrantedPermission ?? this.isGrantedPermission,
      albumArtScaleIndex: albumArtScaleIndex ?? this.albumArtScaleIndex,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MusicInfoState
      && other.metaData == metaData
      && other.isPlay == isPlay
      && other.albumArtScaleIndex == albumArtScaleIndex
      && other.isGrantedPermission == isGrantedPermission;
  }

  @override
  int get hashCode => (
      metaData.hashCode +
      isPlay.hashCode +
      isGrantedPermission.hashCode +
      albumArtScaleIndex.hashCode
  ).toInt();

  static MusicInfoState initState = MusicInfoState(
    albumArtScaleIndex: Pref().getScaleIndex(),
  );

  @override
  String toString() {
    return 'title:${metaData.title}, permission: $isGrantedPermission';
  }
}


