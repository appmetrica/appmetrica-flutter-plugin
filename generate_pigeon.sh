#!/bin/bash
mkdir -p ios/AppMetricaPlugin/
mkdir -p android/src/main/java/io/appmetrica/analytics/flutter/pigeon
flutter pub run pigeon \
  --input pigeons/appmetrica_api.dart \
  --dart_out lib/src/appmetrica_api_pigeon.dart \
  --objc_prefix AMAF \
  --objc_header_out ios/AppMetricaPlugin/AMAFPigeon.h \
  --objc_source_out ios/AppMetricaPlugin/AMAFPigeon.m \
  --java_out android/src/main/java/io/appmetrica/analytics/flutter/pigeon/Pigeon.java \
  --java_package "io.appmetrica.analytics.flutter.pigeon"
