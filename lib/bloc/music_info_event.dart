part of 'music_info_bloc.dart';

@immutable
abstract class MusicInfoEvent {
  const MusicInfoEvent();
}

class MetaChanged extends MusicInfoEvent {

  const MetaChanged(this.metaData);

  final Map<String, dynamic> metaData;
}

enum Command {
  play, pause, rewind, fastForward
}

class MusicCommand extends MusicInfoEvent {

  const MusicCommand(this.command);

  final Command command;

  static const play = MusicCommand(Command.play);
  static const pause = MusicCommand(Command.pause);
  static const rewind = MusicCommand(Command.rewind);
  static const fastForward = MusicCommand(Command.fastForward);
}

class RequestPermission extends MusicInfoEvent {
  const RequestPermission();
}

class CheckPermission extends MusicInfoEvent {
  const CheckPermission();
}

class RegisterListener extends MusicInfoEvent {
  const RegisterListener();
}
