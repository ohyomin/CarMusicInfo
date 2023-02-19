
import 'package:car_music_info/page/main_page.dart';
import 'package:flutter/material.dart';


class RemoteControllerWidget extends StatelessWidget {
  const RemoteControllerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _IconButton(iconData: Icons.fast_rewind_rounded, callback: (){ print('hmhm'); }),
        _IconButton(iconData: Icons.play_arrow_rounded, callback: (){}),
        _IconButton(iconData: Icons.fast_forward_rounded, callback: (){}),
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

