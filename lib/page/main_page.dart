import 'dart:typed_data';

import 'package:car_music_info/bloc/music_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

import '../component/music_info_box.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MusicInfoBloc(),
      child: Material(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: Stack(
            children: [
              const BackgroundBlur(),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    MusicInfoBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class BackgroundBlur extends StatelessWidget {
  const BackgroundBlur({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicInfoBloc, MusicInfoState>(
      buildWhen: (previous, current) {
        return previous.albumArtHash != current.albumArtHash;
      },
      builder: (context, state) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            child: BlurHash(
              hash: state.albumArtHash,
              key: ValueKey(state.albumArtHash),
            ),
          ),
        );
      },
    );
  }
}




