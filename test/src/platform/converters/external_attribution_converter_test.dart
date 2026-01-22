import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/platform/converters/external_attribution_converter.dart';
import 'package:appmetrica_plugin/src/platform/pigeon/appmetrica_api_pigeon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExternalAttributionConverter', () {
    group('Adjust attribution', () {
      test('converts with all fields', () {
        final AppMetricaExternalAttribution attribution = AppMetricaExternalAttribution.adjust(
          trackerToken: 'token123',
          trackerName: 'TrackerName',
          network: 'facebook',
          campaign: 'summer_promo',
          adgroup: 'group1',
          creative: 'creative1',
          clickLabel: 'click_label',
          adid: 'adid123',
          costType: 'cpi',
          costAmount: 1.5,
          costCurrency: 'USD',
          fbInstallReferrer: 'fb_referrer',
        );

        final ExternalAttributionPigeon pigeon = attribution.toPigeon();

        expect(pigeon.source, 'adjust');
        expect(pigeon.data['trackerToken'], 'token123');
        expect(pigeon.data['trackerName'], 'TrackerName');
        expect(pigeon.data['network'], 'facebook');
        expect(pigeon.data['campaign'], 'summer_promo');
        expect(pigeon.data['adgroup'], 'group1');
        expect(pigeon.data['creative'], 'creative1');
        expect(pigeon.data['clickLabel'], 'click_label');
        expect(pigeon.data['adid'], 'adid123');
        expect(pigeon.data['costType'], 'cpi');
        expect(pigeon.data['costAmount'], 1.5);
        expect(pigeon.data['costCurrency'], 'USD');
        expect(pigeon.data['fbInstallReferrer'], 'fb_referrer');
      });

      test('converts with minimal fields', () {
        final AppMetricaExternalAttribution attribution = AppMetricaExternalAttribution.adjust();

        final ExternalAttributionPigeon pigeon = attribution.toPigeon();

        expect(pigeon.source, 'adjust');
        expect(pigeon.data['trackerToken'], null);
        expect(pigeon.data['network'], null);
      });

      test('converts with numeric cost amount', () {
        final AppMetricaExternalAttribution attribution = AppMetricaExternalAttribution.adjust(
          costAmount: 99.99,
        );

        final ExternalAttributionPigeon pigeon = attribution.toPigeon();

        expect(pigeon.data['costAmount'], 99.99);
      });
    });

    group('AppsFlyer attribution', () {
      test('converts appsflyer attribution', () {
        final Map<String, dynamic> attributionData = <String, dynamic>{
          'payload': <String, String>{
            'campaign': 'test_campaign',
            'media_source': 'facebook',
            'af_status': 'Non-organic',
          }
        };

        final AppMetricaExternalAttribution attribution =
            AppMetricaExternalAttribution.appsflyer(attributionData);

        final ExternalAttributionPigeon pigeon = attribution.toPigeon();

        expect(pigeon.source, 'appsflyer');
        expect(pigeon.data['campaign'], 'test_campaign');
        expect(pigeon.data['media_source'], 'facebook');
        expect(pigeon.data['af_status'], 'Non-organic');
      });
    });

    group('Kochava attribution', () {
      test('converts kochava attribution', () {
        final Map<String, dynamic> attributionData = <String, dynamic>{
          'campaign': 'kochava_campaign',
          'tracker': 'kochava_tracker',
          'network': 'google',
        };

        final AppMetricaExternalAttribution attribution =
            AppMetricaExternalAttribution.kochava(attributionData);

        final ExternalAttributionPigeon pigeon = attribution.toPigeon();

        expect(pigeon.source, 'kochava');
        expect(pigeon.data['campaign'], 'kochava_campaign');
        expect(pigeon.data['tracker'], 'kochava_tracker');
        expect(pigeon.data['network'], 'google');
      });

      test('converts empty kochava attribution', () {
        final AppMetricaExternalAttribution attribution =
            AppMetricaExternalAttribution.kochava(<String, dynamic>{});

        final ExternalAttributionPigeon pigeon = attribution.toPigeon();

        expect(pigeon.source, 'kochava');
        expect(pigeon.data, isEmpty);
      });
    });

    group('Tenjin attribution', () {
      test('converts tenjin attribution', () {
        final Map<String, dynamic> attributionData = <String, dynamic>{
          'campaign_id': 'tenjin_campaign',
          'ad_network': 'unity',
        };

        final AppMetricaExternalAttribution attribution =
            AppMetricaExternalAttribution.tenjin(attributionData);

        final ExternalAttributionPigeon pigeon = attribution.toPigeon();

        expect(pigeon.source, 'tenjin');
        expect(pigeon.data['campaign_id'], 'tenjin_campaign');
        expect(pigeon.data['ad_network'], 'unity');
      });
    });

    group('AirBridge attribution', () {
      test('converts airbridge attribution', () {
        final Map<String, dynamic> attributionData = <String, dynamic>{
          'campaign': 'airbridge_campaign',
          'channel': 'organic',
        };

        final AppMetricaExternalAttribution attribution =
            AppMetricaExternalAttribution.airbridge(attributionData);

        final ExternalAttributionPigeon pigeon = attribution.toPigeon();

        expect(pigeon.source, 'airbridge');
        expect(pigeon.data['campaign'], 'airbridge_campaign');
        expect(pigeon.data['channel'], 'organic');
      });

      test('converts airbridge with dynamic keys', () {
        final Map<dynamic, dynamic> attributionData = <dynamic, dynamic>{
          123: 'numeric_key_value',
          'string_key': 'string_value',
        };

        final AppMetricaExternalAttribution attribution =
            AppMetricaExternalAttribution.airbridge(attributionData);

        final ExternalAttributionPigeon pigeon = attribution.toPigeon();

        expect(pigeon.source, 'airbridge');
        expect(pigeon.data['123'], 'numeric_key_value');
        expect(pigeon.data['string_key'], 'string_value');
      });
    });

    group('Singular attribution', () {
      test('converts singular attribution', () {
        final Map<String, dynamic> attributionData = <String, dynamic>{
          'campaign': 'singular_campaign',
          'source': 'facebook',
          'is_organic': false,
        };

        final AppMetricaExternalAttribution attribution =
            AppMetricaExternalAttribution.singular(attributionData);

        final ExternalAttributionPigeon pigeon = attribution.toPigeon();

        expect(pigeon.source, 'singular');
        expect(pigeon.data['campaign'], 'singular_campaign');
        expect(pigeon.data['source'], 'facebook');
        expect(pigeon.data['is_organic'], false);
      });

      test('converts singular with nested data', () {
        final Map<String, dynamic> attributionData = <String, dynamic>{
          'campaign': 'singular_campaign',
          'extra': <String, String>{
            'nested_key': 'nested_value',
          },
        };

        final AppMetricaExternalAttribution attribution =
            AppMetricaExternalAttribution.singular(attributionData);

        final ExternalAttributionPigeon pigeon = attribution.toPigeon();

        expect(pigeon.source, 'singular');
        expect(pigeon.data['extra'], <String, String>{'nested_key': 'nested_value'});
      });
    });
  });
}
