import 'dart:typed_data';
import 'package:blurhash_dart/blurhash_dart.dart';

import 'package:bloc/bloc.dart';
import 'package:car_music_info/core/constants.dart';
import 'package:meta/meta.dart';
import 'package:image/image.dart' as img;

import '../core/method_channel.dart';

part 'music_info_event.dart';
part 'music_info_state.dart';

class MusicInfoBloc extends Bloc<MusicInfoEvent, MusicInfoState> {
  MusicInfoBloc() : super(MusicInfoState.initState) {
    on<MetaChanged>(_onMetaChanged);
    on<MusicCommand>(_onMusicCommand);

    _listenMusicInfoStream();
  }

  final MethodChannelInterface methodChannel = MethodChannelInterface.get();

  void _onMusicCommand(MusicCommand event, _) {
    switch(event.command) {
      case Command.play:
        methodChannel.play();
        break;
      case Command.pause:
        methodChannel.pause();
        break;
      case Command.rewind:
        methodChannel.rewind();
        break;
      case Command.fastForward:
        methodChannel.fastForward();
        break;
    }
  }

  void _onMetaChanged(
    MetaChanged event,
    Emitter<MusicInfoState> emit,
  ) {
    final map = event.metaData;
    String title = map['title'] ?? '';
    String artist = map['artist'] ?? '';
    bool isPlay = map['isPlay'] == 1 ? true : false;
    List<int> albumArt = map['albumArt'] ?? <int>[];
    String albumArtHash = _getBlurHash(albumArt);

    final newState = state.copyWith(
      title: title,
      artist: artist,
      isPlay: isPlay,
      albumArt: albumArt,
      albumArtHash: albumArtHash,
    );

    emit(newState);
  }

  void _listenMusicInfoStream() {
    methodChannel.musicInfoStream.listen((Map<String, dynamic> map) {
      add(MetaChanged(map));
    });
  }

  String _getBlurHash(List<int> albumArt) {
    if (albumArt.isEmpty) return Constants.defaultBlurHash;

    final decodedImg = img.decodeImage(Uint8List.fromList(albumArt));
    if (decodedImg == null) return Constants.defaultBlurHash;

    return BlurHash.encode(decodedImg, numCompX: 5, numCompY: 5).hash;
  }
}
