import 'dart:async';

import 'package:flutter/services.dart';

import '../model/music_info.dart';

abstract class MethodChannelInterface {

  static MethodChannelInterface _instance = MusicInfoMethodChannel();

  static set instance(MethodChannelInterface instance) {
    _instance = instance;
  }

  static MethodChannelInterface get() => _instance;

  Stream<Map<String, dynamic>> get musicInfoStream;

  void play();
  void pause();
  void rewind();
  void fastForward();
}

class MusicInfoMethodChannel extends MethodChannelInterface {

  static const String _musicInfoChannelName = "com.ohmnia.musicinfo";
  static const String _commandChannelName = "com.ohmnia.command";

  static const _musicInfoChannel = EventChannel(_musicInfoChannelName);
  static const _commandChannel = MethodChannel(_commandChannelName);

  static Stream<Map<String, dynamic>>? _musicInfoStream;

  @override
  Stream<Map<String, dynamic>> get musicInfoStream {
    if (_musicInfoStream != null) return _musicInfoStream!;

    _musicInfoStream = _musicInfoChannel
      .receiveBroadcastStream()
      .transform(
        StreamTransformer<dynamic, Map<String, dynamic>>.fromHandlers(
          handleData: (data, sink) {
            final map = Map<String, dynamic>.from(data);
            sink.add(map);
          },
        ),
      );

    return _musicInfoStream!;
  }

  @override
  void fastForward() {
    _commandChannel.invokeMethod("fastForward");
  }

  @override
  void pause() {
    _commandChannel.invokeMethod("pause");
  }

  @override
  void play() {
    _commandChannel.invokeMethod("play");
  }

  @override
  void rewind() {
    _commandChannel.invokeMethod("rewind");
  }
}