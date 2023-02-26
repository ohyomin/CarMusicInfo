import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:car_music_info/model/music_meta_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../core/method_channel.dart';

part 'music_info_event.dart';
part 'music_info_state.dart';
part 'car_key_handler.dart';

class MusicInfoBloc extends Bloc<MusicInfoEvent, MusicInfoState> {
  MusicInfoBloc() : super(MusicInfoState.initState) {
    on<MetaChanged>(
      _onMetaChanged,
      transformer: restartable(),
    );
    on<MusicCommand>(_onMusicCommand);
    on<CheckPermission>((event, emit) async {
      final granted = await methodChannel.isPermissionGranted();
      if (granted) methodChannel.registerListener();
      emit(state.copyWith(isGrantedPermission: granted));
    });
    on<RequestPermission>((event, emit) async {
      final result = await methodChannel.requestPermission();
      if (result) methodChannel.registerListener();
      emit(state.copyWith(isGrantedPermission: result));
    });

    add(const CheckPermission());
    _listenMusicInfoStream();
  }

  late final _keyEventManager = CarKeyHandler(this);

  FocusScopeNode get globalFocusNode => _keyEventManager.globalFocusNode;
  FocusNode get rewindButtonFocusNode => _keyEventManager.rewindButtonFocusNode;
  FocusNode get playButtonFocusNode => _keyEventManager.playButtonFocusNode;
  FocusNode get fastForwardButtonFocusNode => _keyEventManager.fastForwardFocusNode;
  FocusNode get albumArtFocusNode => _keyEventManager.albumArtFocusNode;

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
  ) async {
    final map = event.data;
    final metaData = await MusicMetaData.fromMap(map);
    bool isPlay = map['isPlay'] == 1 ? true : false;

    final newState = state.copyWith(
      metaData: metaData,
      isPlay: isPlay,
    );

    emit(newState);
  }

  void _listenMusicInfoStream() {
    methodChannel.musicInfoStream.listen((Map<String, dynamic> map) {
      add(MetaChanged(map));
    });
  }
}
