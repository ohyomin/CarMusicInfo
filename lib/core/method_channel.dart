import 'dart:async';

import 'package:flutter/services.dart';

import '../model/music_info.dart';

class MethodChannelInterface  {

  static MethodChannelInterface _instance = MusicInfoMethodChannel();

  static set instance(MethodChannelInterface instance) {
    _instance = instance;
  }

  static MethodChannelInterface get() => _instance;

  Stream<MusicInfo> get musicInfoStream => throw UnimplementedError();
}

class MusicInfoMethodChannel extends MethodChannelInterface {

  static const String _musicInfoChannelName = "com.ohmnia.musicinfo";
  static const _musicInfoChannel = EventChannel(_musicInfoChannelName);

  static Stream<MusicInfo>? _musicInfoStream;

  @override
  Stream<MusicInfo> get musicInfoStream {
    if (_musicInfoStream != null) return _musicInfoStream!;

    _musicInfoStream = _musicInfoChannel
      .receiveBroadcastStream()
      .transform<MusicInfo>(
        StreamTransformer<dynamic, MusicInfo>.fromHandlers(
          handleData: (data, sink) {
            if (data == null)  {
              sink.add(MusicInfo.empty);
            } else {
              final map = Map<String, dynamic>.from(data);
              sink.add(MusicInfo.fromMap(map));
            }
          },
        ),
      );

    return _musicInfoStream!;
  }
}