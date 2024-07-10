# AppMetrica SDK for Flutter
A Flutter plugin for AppMetrica by Yandex. AppMetrica is an end-to-end app analytics and marketing tool that works across all major mobile platforms.

## Supported Features
This library helps you collect the following data:

* Device information. Rich technology reports include information on OS, phone makers and models, screen resolution, interface language and other parameters.
* Referral information. Be aware how the user got to the app.
* Your audience. All the pivotal product KPIs (such as MAU, WAU, DAU, ect.) are ready at hand and updated in real time.
* User profiles. Study characteristics and the history of actions for individual users to get a close-up view of behavior patterns.
* In-app sales revenue and related revenue metrics: ARPU, average order value, repeated purchases and more.
* Errors that occurred during app run. All crashes and errors in AppMetrica’s easy-to-read reports are grouped together with OS/app version and other technical details.
* Any custom events.
* And other features available for AppMetrica SDK users on Android or iOS.

You can learn more on [AppMetrica web site](https://appmetrica.io).

## Getting Started
In your flutter project add the following dependency:
```
dependencies:
  ...
  appmetrica_plugin: ^3.0.0
```

Activate library using `AppMetrica.activate` with your API Key
```
AppMetrica.activate(AppMetricaConfig("insert_your_api_key_here"));
```

And report event via `AppMetrica.reportEvent`
```
AppMetrica.reportEvent('My first AppMetrica event!');
```

## Suggesting improvements
To file bugs, make feature requests, or to suggest other improvements, please use the [feedback form](https://appmetrica.io/docs/en/troubleshooting/index).

## Notes
This plugin uses [Pigeon](https://pub.dev/packages/pigeon) to generate interfaces for communication between Flutter and host platform.

