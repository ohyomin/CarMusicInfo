part of 'music_info_bloc.dart';

class CarKeyHandler {
  CarKeyHandler(this.bloc);

  final MusicInfoBloc bloc;

  KeyEventResult _keyHandler(
      FocusNode node,
      RawKeyEvent event,
      VoidCallback block,
      ) {
    if (event.isKeyPressed(LogicalKeyboardKey.enter)
        || event.isKeyPressed(LogicalKeyboardKey.select)
        || event.isKeyPressed(LogicalKeyboardKey.gameButton1)
        || event.isKeyPressed(LogicalKeyboardKey.gameButtonSelect)) {
      block.call();
      return KeyEventResult.handled;
    }

    if (event.isKeyPressed(LogicalKeyboardKey.mediaTrackNext) ||
        event.isKeyPressed(LogicalKeyboardKey.mediaFastForward)) {
      bloc.add(MusicCommand.fastForward);
      return KeyEventResult.handled;
    }

    if (event.isKeyPressed(LogicalKeyboardKey.mediaTrackPrevious) ||
        event.isKeyPressed(LogicalKeyboardKey.mediaRewind)) {
      bloc.add(MusicCommand.rewind);
      return KeyEventResult.handled;
    }

    if (event.isKeyPressed(LogicalKeyboardKey.mediaPlay) ||
        event.isKeyPressed(LogicalKeyboardKey.play)) {
      bloc.add(MusicCommand.play);
      return KeyEventResult.handled;
    }

    if (event.isKeyPressed(LogicalKeyboardKey.mediaPause) ||
        event.isKeyPressed(LogicalKeyboardKey.pause)) {
      bloc.add(MusicCommand.pause);
      return KeyEventResult.handled;
    }

    if (event.isKeyPressed(LogicalKeyboardKey.mediaPlayPause)) {
      bloc.add(bloc.state.isPlay ? MusicCommand.pause : MusicCommand.play);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  late final FocusScopeNode globalFocusNode = FocusScopeNode(
    onKey: (node, event) {
      return _keyHandler(node, event, () {});
    },
  );

  late final FocusNode rewindButtonFocusNode = FocusNode(
    onKey: (node, event) {
      return _keyHandler(node, event, () => bloc.add(MusicCommand.rewind));
    },
  );

  late final FocusNode playButtonFocusNode = FocusNode(
    onKey: (node, event) {
      return _keyHandler(node, event,
            () => bloc.add(bloc.state.isPlay ? MusicCommand.pause : MusicCommand.play),
      );
    },
  );

  late final FocusNode fastForwardFocusNode = FocusNode(
    onKey: (node, event) {
      return _keyHandler(node, event, () => bloc.add(MusicCommand.fastForward));
    },
  );

  late final FocusNode albumArtFocusNode = FocusNode(
    onKey: (node, event) {
      return _keyHandler(node, event, () {
        MethodChannelInterface.get().startApp();
      });
    },
  );
}