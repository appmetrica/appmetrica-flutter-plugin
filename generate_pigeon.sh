#!/bin/bash
mkdir -p ios/AppMetricaPlugin/
mkdir -p android/src/main/java/io/appmetrica/analytics/flutter/pigeon
dart run pigeon --input pigeons/appmetrica_api.dart
