
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class HangulWatch extends StatefulWidget {
  const HangulWatch({Key? key}) : super(key: key);

  @override
  State<HangulWatch> createState() => _HangulWatchState();
}

class _HangulWatchState extends State<HangulWatch> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();

    Timer.periodic(
      const Duration(seconds: 1),
      (_) { if (mounted) setState(() {}); }
    );
  }

  @override
  Widget build(BuildContext context) {
    final curTime = DateTime.now();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _getHour(curTime.hour),
          style: const TextStyle(
            fontSize: 50,
            color: Colors.white,
            height: 0.8,
            fontFamily: 'Dongle'
          ),
        ),
        Text(
          _getMin(curTime.minute),
          style: const TextStyle(
            height: 0.8,
            fontSize: 40,
            color: Colors.white,
              fontFamily: 'Dongle'
          ),
        ),
        Text(
          DateFormat('M월 d일 EEEE','ko_KR').format(curTime),
          //'${formatter.format(curTime)}',
          style: const TextStyle(
            fontSize: 25,
            color: Colors.white,
              fontFamily: 'Dongle'
          ),
        ),
      ],
    );
  }

  static const hourName = [
    '열두시',
    '한시',
    '두시',
    '세시',
    '네시',
    '다섯시',
    '여섯시',
    '일곱시',
    '여덟시',
    '아홉시',
    '열시',
    '열한시',
  ];

  static const minName = [
    '정각',
    '일',
    '이',
    '삼',
    '사',
    '오',
    '육',
    '칠',
    '팔',
    '구',
  ];

  static const minNameTen = [
    '',
    '십',
    '이십',
    '삼십',
    '사십',
    '오십',
    '육십',
  ];

  String _getHour(int hour) {
    String prefix;
    if (hour >= 0 && hour <= 11) {
      prefix = '오전';
    } else {
      prefix = '오후';
    }
    return '$prefix${hourName[hour % 12]}';
  }

  String _getMin(int minute) {
    if (minute == 0) return minName[0];
    if (minute < 10) return '${minName[minute]}분';

    int tens = minute ~/ 10;
    int units = minute % 10;

    if (units == 0) return '${minNameTen[tens]}분';
    return '${minNameTen[tens]}${minName[units]}분';
  }
}
