
import 'package:car_music_info/component/remote_controller_widget.dart';
import 'package:car_music_info/component/music_info_widget.dart';
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
            //selector: (state) => state.metaData,
            buildWhen: (prev, current) {
              return current.metaData.albumArt.isNotEmpty
                  && current.metaData != prev.metaData;
            },
            builder: (context, state) {
              return Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 1000),
                    child: MetaInfoWidget(
                      key: ValueKey(state.metaData.title),
                      title: state.metaData.title,
                      artist: state.metaData.artist,
                      albumArt: state.metaData.albumArt,
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