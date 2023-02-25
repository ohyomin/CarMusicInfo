
import 'package:car_music_info/bloc/music_info_bloc.dart';
import 'package:car_music_info/component/glass_box.dart';
import 'package:car_music_info/component/hangul_watch.dart';
import 'package:car_music_info/model/music_meta_data.dart';
import 'package:car_music_info/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

import '../component/music_info_box.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).isWide;
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
                padding: isWide ? const EdgeInsets.all(15) : EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isWide ? 400 : double.infinity,
                          maxHeight: isWide ? 600 : double.infinity,
                        ),
                        child: const MusicInfoBox(),
                      ),
                    ),
                    ..._renderSubWidget(isWide),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _renderSubWidget(bool isWide) {
    if (!isWide) {
      return [];
    }
    return [
      const SizedBox(width: 10),
      const Flexible(
        child: SubInfoWidget(),
      ),
    ];
  }
}

class SubInfoWidget extends StatelessWidget {
  const SubInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400,
              maxHeight: 295,
            ),
            child: const GlassBox(
              child: HangulWatch(),
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
            child: GlassBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.ac_unit_outlined, size: 40, color: Colors.white),
                      Icon(Icons.ac_unit_outlined, size: 40, color: Colors.white),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.ac_unit_outlined, size: 40, color: Colors.white),
                      Icon(Icons.ac_unit_outlined, size: 40, color: Colors.white),
                    ],
                  ),
                ],
              ) ,
            ),
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
    final isWide = MediaQuery.of(context).isWide;
    return BlocBuilder<MusicInfoBloc, MusicInfoState>(
      buildWhen: (prev, current) {
        return current.metaData.albumArt.isNotEmpty
            && prev.metaData != current.metaData;
      },
      builder: (context, state) {
        return ClipRRect(
          borderRadius: isWide ? BorderRadius.circular(20) : BorderRadius.zero,
          child: Stack(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 1000),
                child: BlurHash(
                  hash: state.metaData.albumArtHash,
                  key: ValueKey(state.metaData.albumArtHash),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(1.0),
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




