
import 'package:car_music_info/core/method_channel.dart';
import 'package:flutter/material.dart';


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

  late final MethodChannelInterface toPlatform;
  late AnimationController _playPauseController;

  @override
  void initState() {
    toPlatform = MethodChannelInterface.get();
    _playPauseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    if (widget.isPlay) {
      _playPauseController.reverse();
    } else {
      _playPauseController.forward();
    }
    super.initState();
  }

  @override
  void dispose() {
    _playPauseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commandChannel = MethodChannelInterface.get();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _IconButton(
          iconData: Icons.fast_rewind_rounded,
          callback: () => commandChannel.rewind(),
        ),

        _IconButton(
          iconData: widget.isPlay ? Icons.pause_rounded : Icons.play_arrow_rounded,
          callback: () {
            if (widget.isPlay) {
              commandChannel.pause();
            } else {
              commandChannel.play();
            }
          }
        ),
        _IconButton(
          iconData: Icons.fast_forward_rounded,
          callback: () => commandChannel.fastForward(),
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

