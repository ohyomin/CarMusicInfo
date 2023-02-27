
import 'package:car_music_info/component/remote_controller_widget.dart';
import 'package:car_music_info/component/music_info_widget.dart';
import 'package:car_music_info/model/music_meta_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/music_info_bloc.dart';
import 'glass_box.dart';

class MusicInfoBox extends StatelessWidget {
  const MusicInfoBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 10),
          BlocBuilder<MusicInfoBloc, MusicInfoState>(
            buildWhen: (prev, cur) {
              return prev.metaData != cur.metaData
                  || prev.albumArtScaleIndex != cur.albumArtScaleIndex;
            },
            builder: (context, state) {
              final metaData = state.metaData;
              return Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 1000),
                    child: MetaInfoWidget(
                      key: ValueKey(metaData.title),
                      title: metaData.title,
                      artist: metaData.artist,
                      albumArt: metaData.albumArt,
                      albumArtScaleIndex: state.albumArtScaleIndex,
                    ),
                  ),
                ),
              );
            },
          ),
          BlocSelector<MusicInfoBloc, MusicInfoState, bool>(
            selector: (state) => state.isPlay,
            builder: (context, isPlay) {
              return Container(
                constraints: const BoxConstraints(
                  maxWidth: 400,
                ),
                height: 100,
                padding: const EdgeInsets.only(bottom: 10),
                child: RemoteControllerWidget(isPlay: isPlay),
              );
            },
          ),
        ],
      ),
    );
  }
}