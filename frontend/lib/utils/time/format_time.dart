import 'package:flutter/material.dart';

String formatTime(TimeOfDay time) {
  int hour = time.hourOfPeriod; 
  String period = time.period == DayPeriod.am ? 'AM' : 'PM';
  String minute = time.minute.toString().padLeft(2, '0');

  return '$hour:$minute$period';
}