import 'package:flutter/material.dart';

class AppUtils {
  static Widget loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
