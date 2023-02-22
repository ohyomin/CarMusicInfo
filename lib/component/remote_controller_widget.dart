
import 'package:car_music_info/bloc/music_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RemoteControllerWidget extends StatefulWidget {
  const RemoteControllerWidget({
    this.isPlay = false,
    Key? key,
  }) : super(key: key);

  final bool isPlay;

  @override
  State<RemoteControllerWidget> createState() => _RemoteControllerWidgetState();
}

class _RemoteControllerWidgetState extends State<RemoteControllerWidget>
    with TickerProviderStateMixin {

  late AnimationController _playPauseController;

  @override
  void initState() {
    _playPauseController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    _playPauseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (widget.isPlay) {
      _playPauseController.forward();
    } else {
      _playPauseController.reverse();
    }

    final musicInfoBloc = context.read<MusicInfoBloc>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _IconButton(
          iconData: Icons.fast_rewind_rounded,
          callback: () => musicInfoBloc.add(MusicCommand.rewind),
          focusNode: musicInfoBloc.rewindButtonFocusNode,
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            focusNode: musicInfoBloc.playButtonFocusNode,
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              MusicCommand command;
              if (widget.isPlay) {
                command = MusicCommand.pause;
              } else {
                command = MusicCommand.play;
              }
              Future.delayed(
                const Duration(milliseconds: 100),
                () => musicInfoBloc.add(command),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: AnimatedIcon(
                icon: AnimatedIcons.play_pause,
                progress: _playPauseController,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ),
        _IconButton(
          iconData: Icons.fast_forward_rounded,
          callback: () => musicInfoBloc.add(MusicCommand.fastForward),
          focusNode: musicInfoBloc.fastForwardButtonFocusNode,
        ),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.iconData,
    required this.callback,
    required this.focusNode,
    Key? key,
  }) : super(key: key);

  final IconData iconData;
  final VoidCallback callback;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: callback,
        focusNode: focusNode,
        child: Icon(
          iconData,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}

