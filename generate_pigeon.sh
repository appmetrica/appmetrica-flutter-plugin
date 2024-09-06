#!/bin/bash
mkdir -p ios/AppMetricaPlugin/
mkdir -p android/src/main/java/io/appmetrica/analytics/flutter/pigeon
flutter pub run pigeon --input pigeons/appmetrica_api.dart
