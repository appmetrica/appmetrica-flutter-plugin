import 'package:flutter/material.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';

AppMetricaConfig get _config =>
    const AppMetricaConfig('Your api key', logs: true);

Future<void> main() async {
  AppMetrica.runZoneGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    AppMetrica.activate(_config);
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AppMetrica plugin example app'),
        ),
        body: Builder(
          builder: (BuildContext context) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: ListView(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    AppMetrica.reportEvent('Event name');
                  },
                  child: const Text('Report Event'),
                ),
                ElevatedButton(
                  onPressed: () {
                    AppMetrica.reportError(
                      message: 'Error message',
                      errorDescription:
                          AppMetricaErrorDescription.fromCurrentStackTrace(
                              message: 'Error message', type: 'Error type'),
                    ).ignore();
                  },
                  child: const Text('Report Error'),
                ),
                ElevatedButton(
                  onPressed: () {
                    AppMetrica.reportUnhandledException(
                      AppMetricaErrorDescription.fromCurrentStackTrace(
                          message: 'Error message', type: 'Error type'),
                    );
                  },
                  child: const Text('Report Unhandled Exception'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await Future.delayed(
                          Duration.zero, () => throw Exception('Error'));
                    } on Exception catch (e, stacktrace) {
                      AppMetrica.reportUnhandledException(
                        AppMetricaErrorDescription.fromObjectAndStackTrace(
                            e, stacktrace),
                      );
                    }
                  },
                  child: const Text('Catch Throwen Error'),
                ),
                ElevatedButton(
                  onPressed: () {
                    AppMetrica.reportAppOpen('https://github.com/appmetrica');
                  },
                  child: const Text('Report App Open'),
                ),
                ElevatedButton(
                  onPressed: () {
                    AppMetrica.reportReferralUrl("https://github.com/appmetrica");
                  },
                  child: const Text('Report Referral Url'),
                ),
                ElevatedButton(
                  onPressed: () {
                    AppMetrica.setLocationTracking(true);
                  },
                  child: const Text('Set Location Tracking'),
                ),
                ElevatedButton(
                  onPressed: () {
                    AppMetrica.setDataSendingEnabled(true);
                  },
                  child: const Text('Set Data Sending Enabled'),
                ),
                ElevatedButton(
                  onPressed: () {
                    AppMetrica.sendEventsBuffer();
                  },
                  child: const Text('Send Events Buffer'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final version = await AppMetrica.libraryVersion;
                    _showSnackBar(context, "Library version $version");
                  },
                  child: const Text('Get library version'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String content) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.hideCurrentSnackBar();
    scaffold.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
