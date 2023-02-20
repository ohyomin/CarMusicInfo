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
}
