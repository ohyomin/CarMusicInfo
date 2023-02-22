import 'package:bloc/bloc.dart';
import 'package:car_music_info/util/log.dart';

const _tag = 'MusicInfoBlocObserver';

class MusicInfoBlocObserver extends BlocObserver {

  const MusicInfoBlocObserver();

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    Log.d(_tag, transition.toString());
  }
}