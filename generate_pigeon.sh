#!/bin/bash

set -e

mkdir -p android/src/main/java/io/appmetrica/analytics/flutter/pigeon
"${1:-dart}" run pigeon --input pigeons/appmetrica_api.dart
