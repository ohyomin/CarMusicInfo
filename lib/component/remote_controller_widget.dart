
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _IconButton(
          iconData: Icons.fast_rewind_rounded,
          callback: () {
            context.read<MusicInfoBloc>().add(
                const MusicCommand(Command.rewind));
          },
        ),
        Material(
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Command command;
              if (widget.isPlay) {
                command = Command.pause;
              } else {
                command = Command.play;
              }
              context.read<MusicInfoBloc>().add(MusicCommand(command));
            },
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: _playPauseController,
              size: 45,
            ),
          ),
        ),
        _IconButton(
          iconData: Icons.fast_forward_rounded,
          callback: () => context.read<MusicInfoBloc>().add(
              const MusicCommand(Command.fastForward)),
        ),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.iconData,
    required this.callback,
    Key? key,
  }) : super(key: key);

  final IconData iconData;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      color: Colors.transparent,
      child: IconButton(
        onPressed: callback,
        padding: EdgeInsets.zero,
        icon:Icon(
          iconData,
          color: Colors.black.withOpacity(0.8),
          size: 50,
        ),
      ),
    );
  }
}

