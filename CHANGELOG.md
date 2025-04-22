## 3.2.0

- Native SDK versions:
  - Android: 7.8.0
  - iOS: 5.10
- Improve statistics when using with Yandex.Ads SDK. Add meta-data with plugin description to AndroidManifest.
- Support Swift Package Manager feature
- Add `appOpen` ad type for ad revenue report.

## 3.1.0

- Native SDK versions:
  - Android: 7.2.0
  - iOS: 5.8

## 3.0.0

- Added prefix `AppMetrica` to all classes to remove possible conflicts with other plugins.
- Started using `flutter_lints` for checkstyle.
- Added parameter `AppMetricaConfig.flutterCrashReporting`. Flutter crashes will not be handled if it is set to `false`.
- Upgrade `decimal` version to `3.0.0` and align flutter version.

## 2.1.1

- Fixed handling of `null` value in the `attributes` parameter in the `AppMetrica.reportEventWithMap` method.

## 2.1.0

- Added request startup keys.
- Added methods for external attribution report.

## 2.0.0

- Native SDK versions:
  - Android: 6.3.0
  - iOS: 5.0

## 1.3.0

- The native android part of the plugin was rewritten in java due to problems with kotlin versions.

## 1.2.0

- Added automatic deeplink tracking.
- Updated dev dependencies.
- Minor fixes and improvements.

## 1.1.0

- Added the AdRevenue API for transmitting advertising monetization revenue at the impression level (Impression-Level Revenue Data).
- Native SDK versions:
  - Android: 5.2.0
  - iOS: 4.4

## 1.0.1

- Fixed `NPE` when creating `UserProfileAttribute` with null argument.

## 1.0.0

- Updated native android AppMetrica SDK version to 5.0.0.

## 0.1.0

Initial release. Supports most of the features available in AppMetrica.  
Native SDK versions:
- Android: 4.2.0
- iOS: 4.2
