
import 'package:car_music_info/bloc/music_info_bloc.dart';
import 'package:car_music_info/component/glass_box.dart';
import 'package:car_music_info/model/music_meta_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

import '../component/music_info_box.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FocusScope(
        node: context.read<MusicInfoBloc>().globalFocusNode,
        autofocus: true,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const BackgroundBlur(),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 400,
                          maxHeight: 600,
                        ),
                        child: const MusicInfoBox(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Flexible(
                      child: SubInfoWidget(),
                    ),
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

class SubInfoWidget extends StatelessWidget {
  const SubInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final curTime = DateTime.now();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400,
              maxHeight: 295,
            ),
            child: GlassBox(
              child: Text(
                '${curTime.hour}시, ${curTime.minute}분',
                style: TextStyle(
                  fontSize: 50,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400,
              maxHeight: 295,
            ),
            child: const GlassBox(child: SizedBox()),
          ),
        ),
      ],
    );
  }
}

class BackgroundBlur extends StatelessWidget {
  const BackgroundBlur({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MusicInfoBloc, MusicInfoState, MusicMetaData>(
      selector: (state) => state.metaData,
      builder: (context, metaData) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 1000),
                child: BlurHash(
                  hash: metaData.albumArtHash,
                  key: ValueKey(metaData.albumArtHash),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.2),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}




