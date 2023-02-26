import 'package:car_music_info/bloc/music_info_bloc.dart';
import 'package:car_music_info/page/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';


class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  static bool isInit = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MusicInfoBloc, MusicInfoState>(
      listener: (context, state) {
        if (!state.isGrantedPermission) {
          checkPermission(context);
        } else {
          if (isInit) return;
          goToMainPage(context);
          isInit = true;
        }
      },
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Lottie.asset(
            'assets/loading.json',
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }

  void checkPermission(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _MyAlertDialog(),
    );
  }

  void goToMainPage(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 2000), () {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MainPage(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, opacity, __, child) {
            return FadeTransition(
              opacity: opacity,
              child: child,
            );
          }
        ),
        (_) => false,
      );
    });
  }
}

class _MyAlertDialog extends StatelessWidget {
  const _MyAlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      alignment: Alignment.bottomCenter,
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      content: const Text("다른 음악 앱의 곡 정보를 가져오기 위해서는 "
          "기기 알림 권한이 필요합니다.\n"
          "확인 버튼을 누르고 나오는 화면에서 "
          "CarMusicInfo 앱을 활성화 해주세요."),
      actions: [
        ButtonBar(
          children: [
            TextButton(
              onPressed: () {
                final bloc = context.read<MusicInfoBloc>();
                bloc.add(const RequestPermission());
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        )
      ],
    );
  }
}
