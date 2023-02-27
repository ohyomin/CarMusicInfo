import 'package:car_music_info/bloc/bloc_observer.dart';
import 'package:car_music_info/page/splash_page.dart';
import 'package:car_music_info/util/shred_pref.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/music_info_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  Bloc.observer = const MusicInfoBlocObserver();
  await Pref().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MusicInfoBloc(),
      child: MaterialApp(
        title: '',
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
            child: child!,
          );
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
          //fontFamily: 'Dongle',
        ),
        home: const SplashPage(),
      ),
    );
  }
}