// ignore_for_file: file_names

import 'package:bloc/bloc.dart';
import 'package:child_milestone/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit(Locale initialState) : super(initialState);

  void changeLang(String data) async {
    emit(Locale(data, ''));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPrefKeys.langCode, data);
  }
}
