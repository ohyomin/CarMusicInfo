import 'package:blurhash_dart/blurhash_dart.dart';

import 'package:bloc/bloc.dart';
import 'package:car_music_info/core/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

import '../core/method_channel.dart';

part 'music_info_event.dart';
part 'music_info_state.dart';

class MusicInfoBloc extends Bloc<MusicInfoEvent, MusicInfoState> {
  MusicInfoBloc() : super(MusicInfoState.initState) {
    on<MetaChanged>(_onMetaChanged);
    on<MusicCommand>(_onMusicCommand);
    on<CheckPermission>((event, emit) async {
      final granted = await methodChannel.isPermissionGranted();
      if (granted) methodChannel.registerListener();
      emit(state.copyWith(isPermissionGranted: granted));
    });
    on<RequestPermission>((event, emit) async {
      final result = await methodChannel.requestPermission();
      if (result) methodChannel.registerListener();
      emit(state.copyWith(isPermissionGranted: result));
    });

    add(const CheckPermission());
    _listenMusicInfoStream();
  }

  KeyEventResult _keyHandler(
    FocusNode node,
    RawKeyEvent event,
    VoidCallback block,
  ) {
    emit(state.copyWith(extra: event.logicalKey.keyLabel));
    if (event.isKeyPressed(LogicalKeyboardKey.enter)
        || event.isKeyPressed(LogicalKeyboardKey.select)
        || event.isKeyPressed(LogicalKeyboardKey.gameButtonSelect)) {
      block.call();
      return KeyEventResult.handled;
    }

    if (event.isKeyPressed(LogicalKeyboardKey.mediaTrackNext) ||
        event.isKeyPressed(LogicalKeyboardKey.mediaFastForward)) {
      add(MusicCommand.fastForward);
      return KeyEventResult.handled;
    }

    if (event.isKeyPressed(LogicalKeyboardKey.mediaTrackPrevious) ||
        event.isKeyPressed(LogicalKeyboardKey.mediaRewind)) {
      add(MusicCommand.rewind);
      return KeyEventResult.handled;
    }

    if (event.isKeyPressed(LogicalKeyboardKey.mediaPlay) ||
        event.isKeyPressed(LogicalKeyboardKey.play)) {
      add(MusicCommand.play);
      return KeyEventResult.handled;
    }

    if (event.isKeyPressed(LogicalKeyboardKey.mediaPause) ||
      event.isKeyPressed(LogicalKeyboardKey.pause)) {
      add(MusicCommand.pause);
      return KeyEventResult.handled;
    }

    if (event.isKeyPressed(LogicalKeyboardKey.mediaPlayPause)) {
      add(state.isPlay ? MusicCommand.pause : MusicCommand.play);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  late final FocusScopeNode globalFocusNode = FocusScopeNode(
    onKey: (node, event) {
      return _keyHandler(node, event, () {
      });
    },
  );

  late final FocusNode rewindButtonFocusNode = FocusNode(
    onKey: (node, event) {
      return _keyHandler(node, event, () {
        add(MusicCommand.rewind);
      });
    },
  );

  late final FocusNode playButtonFocusNode = FocusNode(
    onKey: (node, event) {
      return _keyHandler(node, event, () {
        add(state.isPlay ? MusicCommand.pause : MusicCommand.play);
      });
    },
  );

  late final FocusNode fastForwardFocusNode = FocusNode(
    onKey: (node, event) {
      return _keyHandler(node, event, () {
        add(MusicCommand.fastForward);
      });
    },
  );

  late final FocusNode albumArtFocusNode = FocusNode(
    onKey: (node, event) {
      return _keyHandler(node, event, () {
        // TODO app launch
      });
    },
  );

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
