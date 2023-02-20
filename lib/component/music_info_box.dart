import 'dart:typed_data';

import 'package:car_music_info/component/remote_controller_widget.dart';
import 'package:car_music_info/component/title_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

import '../bloc/music_info_bloc.dart';
import '../core/constants.dart';
import 'glass_box.dart';

class MusicInfoBox extends StatelessWidget {
  const MusicInfoBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassBox(
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<MusicInfoBloc, MusicInfoState>(
            buildWhen: (prev, cur) => prev.title != cur.title,
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                height: 120,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 1000),
                  child: TitleInfoWidget(
                    key: ValueKey(state.title),
                    title: state.title,
                    artist: state.artist,
                  ),
                ),
              );
            },
          ),
          Flexible(
            child: BlocBuilder<MusicInfoBloc, MusicInfoState>(
              buildWhen: (prev, cur) => prev.title != cur.title,
              builder: (context, state) {
                return ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxWidth: 230,
                      maxHeight: 230
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x54000000),
                          spreadRadius: 4,
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 1000),
                      child: ClipRRect(
                        key: ValueKey(state.title),
                        borderRadius: BorderRadius.circular(10),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: _getAlbumArt(state.albumArt),
                        ),
                      ),
                    ),
                  ),
                ) ;
              },
            ),
          ),
          BlocBuilder<MusicInfoBloc, MusicInfoState>(
            buildWhen: (prev, cur) => prev.isPlay != cur.isPlay,
            builder: (context, state) {
              return Container(
                height: 100,
                padding: const EdgeInsets.only(bottom: 10),
                child: RemoteControllerWidget(isPlay: state.isPlay),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _getAlbumArt(List<int> albumArt) {
    if (albumArt.isEmpty) {
      return const BlurHash(hash: Constants.defaultBlurHash);
    }

    return Image.memory(
      Uint8List.fromList(albumArt),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const SizedBox();
      },
    );
  }
}