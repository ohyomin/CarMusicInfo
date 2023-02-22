part of 'music_info_bloc.dart';

@immutable
class MusicInfoState {

  const MusicInfoState({
    this.metaData = MusicMetaData.initData,
    this.isPlay = false,
    this.isGrantedPermission = false,
  });

  final MusicMetaData metaData;
  final bool isPlay;
  final bool isGrantedPermission;

  MusicInfoState copyWith({
    MusicMetaData? metaData,
    bool? isPlay,
    bool? isGrantedPermission,
  }) {
    return MusicInfoState(
      metaData: metaData ?? this.metaData,
      isPlay: isPlay ?? this.isPlay,
      isGrantedPermission: isGrantedPermission ?? this.isGrantedPermission,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MusicInfoState
      && other.metaData == metaData
      && other.isPlay == isPlay
      && other.isGrantedPermission == isGrantedPermission;
  }

  @override
  int get hashCode => (
      metaData.hashCode +
      isPlay.hashCode +
      isGrantedPermission.hashCode
  ).toInt();

  static const initState = MusicInfoState();

  @override
  String toString() {
    return 'title:${metaData.title}, permission: $isGrantedPermission';
  }
}


