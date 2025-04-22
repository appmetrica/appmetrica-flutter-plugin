import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/appmetrica_api_pigeon.dart',
  objcHeaderOut: 'ios/appmetrica_plugin/Sources/appmetrica_plugin/AMAFPigeon.h',
  objcSourceOut: 'ios/appmetrica_plugin/Sources/appmetrica_plugin/AMAFPigeon.m',
  objcOptions: ObjcOptions(prefix: 'AMAF'),
  javaOut: 'android/src/main/java/io/appmetrica/analytics/flutter/pigeon/Pigeon.java',
  javaOptions: JavaOptions(package: 'io.appmetrica.analytics.flutter.pigeon'),
))

class AppMetricaConfigPigeon {
  String apiKey;

  bool? anrMonitoring;
  int? anrMonitoringTimeout;
  int? appBuildNumber;
  Map<String?, String?>? appEnvironment;
  bool? appOpenTrackingEnabled;
  String? appVersion;
  bool? crashReporting;
  List<String?>? customHosts;
  bool? dataSendingEnabled;
  String? deviceType;
  int? dispatchPeriodSeconds;
  Map<String?, String?>? errorEnvironment;
  bool? firstActivationAsUpdate;
  LocationPigeon? location;
  bool? locationTracking;
  bool? logs;
  int? maxReportsCount;
  int? maxReportsInDatabaseCount;
  bool? nativeCrashReporting;
  PreloadInfoPigeon? preloadInfo;
  bool? revenueAutoTrackingEnabled;
  int? sessionTimeout;
  bool? sessionsAutoTrackingEnabled;
  String? userProfileID;
}

class LocationPigeon {
  double latitude;
  double longitude;
  String? provider;
  double? altitude;
  double? accuracy;
  double? course;
  double? speed;
  int? timestamp;
}

class PreloadInfoPigeon {
  String trackingId;
  Map<String?, String?>? additionalInfo;
}

class AppMetricaDeferredDeeplinkErrorPigeon {
  AppMetricaDeferredDeeplinkReasonPigeon reason;
  String description;
  String? message;
}

class AppMetricaDeferredDeeplinkPigeon {
  String? deeplink;
  AppMetricaDeferredDeeplinkErrorPigeon? error;
}

class AppMetricaDeferredDeeplinkParametersPigeon {
  Map<String?, String?>? parameters;
  AppMetricaDeferredDeeplinkErrorPigeon? error;
}

enum AppMetricaDeferredDeeplinkReasonPigeon {
  NOT_A_FIRST_LAUNCH,
  PARSE_ERROR,
  UNKNOWN,
  NO_REFERRER,
  NO_ERROR,
}

class RevenuePigeon {
  final String price;
  final String currency;
  final int? quantity;
  final String? productId;
  final String? payload;
  final ReceiptPigeon? receipt;
  final String? transactionId;
}

class ReceiptPigeon {
  final String? data;
  final String? signature;
}

class ECommerceAmountPigeon {
  final String amount;
  final String currency;
}

class ECommerceProductPigeon {
  final String sku;
  final String? name;
  final List<String?>? categoriesPath;
  final Map<String?, String?>? payload;
  final ECommercePricePigeon? actualPrice;
  final ECommercePricePigeon? originalPrice;
  final List<String?>? promocodes;
}

class ECommercePricePigeon {
  final ECommerceAmountPigeon fiat;
  final List<ECommerceAmountPigeon?>? internalComponents;
}

class ECommerceReferrerPigeon {
  final String? type;
  final String? identifier;
  final ECommerceScreenPigeon? screen;
}

class ECommerceScreenPigeon {
  final String? name;
  final List<String?>? categoriesPath;
  final String? searchQuery;
  final Map<String?, String?>? payload;
}

class ECommerceCartItemPigeon {
  final ECommerceProductPigeon product;
  final String quantity;
  final ECommercePricePigeon revenue;
  final ECommerceReferrerPigeon? referrer;
}

class ECommerceOrderPigeon {
  final String identifier;
  final List<ECommerceCartItemPigeon?> items;
  final Map<String?, String?>? payload;
}

class ECommerceEventPigeon {
  final String eventType;
  final ECommerceCartItemPigeon? cartItem;
  final ECommerceOrderPigeon? order;
  final ECommerceProductPigeon? product;
  final ECommerceReferrerPigeon? referrer;
  final ECommerceScreenPigeon? screen;
}

class StackTraceElementPigeon {
  final String className;
  final String? fileName;
  final int line;
  final int column;
  final String methodName;
}

class ErrorDetailsPigeon {
  final String exceptionClass;
  final String? message;
  final String dartVersion;
  final List<StackTraceElementPigeon?>? backtrace;
}

enum UserProfileAttributeType {
  BIRTH_DATE,
  BOOLEAN,
  COUNTER,
  GENDER,
  NAME,
  NOTIFICATION_ENABLED,
  NUMBER,
  STRING,
}

enum GenderPigeon {
  MALE,
  FEMALE,
  OTHER,
  UNDEFINED,
}

class UserProfileAttributePigeon {
  final String key;
  final double? doubleValue;
  final String? stringValue;
  final bool? boolValue;
  final int? year;
  final int? month;
  final int? day;
  final int? age;
  final GenderPigeon? genderValue;
  final bool? ifUndefined;
  final bool? reset;
  final UserProfileAttributeType? type;
}

class UserProfilePigeon {
  final List<UserProfileAttributePigeon?> attributes;
}

enum AdTypePigeon {
  UNKNOWN,
  NATIVE,
  BANNER,
  REWARDED,
  INTERSTITIAL,
  MREC,
  APP_OPEN,
  OTHER,
}

class AdRevenuePigeon {
  final String adRevenue;
  final String currency;
  final AdTypePigeon? adType;
  final String? adNetwork;
  final String? adUnitId;
  final String? adUnitName;
  final String? adPlacementId;
  final String? adPlacementName;
  final String? precision;
  final Map<String?, String?>? payload;
}

enum StartupParamsItemStatusPigeon {
  FEATURE_DISABLED,
  INVALID_VALUE_FROM_PROVIDER,
  NETWORK_ERROR,
  OK,
  PROVIDER_UNAVAILABLE,
  UNKNOWN_ERROR,
}

class StartupParamsItemPigeon {
  String? id;
  StartupParamsItemStatusPigeon status;
  String? errorDetails;
}

class StartupParamsResultPigeon {
  String? deviceId;
  String? deviceIdHash;
  Map<String?, StartupParamsItemPigeon?>? parameters;
  String? uuid;
}

class StartupParamsReasonPigeon {
  String value;
}

class StartupParamsPigeon {
  StartupParamsResultPigeon? result;
  StartupParamsReasonPigeon? reason;
}

class ExternalAttributionPigeon {
  String source;
  Map<String?, Object?> data;
}

@HostApi()
abstract class AppMetricaConfigConverterPigeon {
  String toJson(AppMetricaConfigPigeon config);
}

@HostApi()
abstract class AppMetricaPigeon {
  void activate(AppMetricaConfigPigeon config);

  void activateReporter(ReporterConfigPigeon config);

  void clearAppEnvironment();

  void enableActivityAutoTracking();

  String? getDeviceId();

  int getLibraryApiLevel();

  String getLibraryVersion();

  String? getUuid();

  void pauseSession();

  void putAppEnvironmentValue(String key, String? value);

  void putErrorEnvironmentValue(String key, String? value);

  void reportAdRevenue(AdRevenuePigeon adRevenue);

  void reportAppOpen(String deeplink);

  void reportECommerce(ECommerceEventPigeon event);

  void reportError(ErrorDetailsPigeon error, String? message);

  void reportErrorWithGroup(String groupId, ErrorDetailsPigeon? error, String? message);

  void reportEvent(String eventName);

  void reportEventWithJson(String eventName, String? attributesJson);

  void reportExternalAttribution(ExternalAttributionPigeon externalAttributionPigeon);

  void reportReferralUrl(String referralUrl);

  void reportRevenue(RevenuePigeon revenue);

  void reportUnhandledException(ErrorDetailsPigeon error);

  void reportUserProfile(UserProfilePigeon userProfile);

  @async
  AppMetricaDeferredDeeplinkPigeon requestDeferredDeeplink();

  @async
  AppMetricaDeferredDeeplinkParametersPigeon requestDeferredDeeplinkParameters();

  @async
  StartupParamsPigeon requestStartupParams(List<String> params);

  void resumeSession();

  void sendEventsBuffer();

  void setDataSendingEnabled(bool enabled);

  void setLocation(LocationPigeon? location);

  void setLocationTracking(bool enabled);

  void setUserProfileID(String? userProfileID);

  // not native api

  void handlePluginInitFinished();

  void touchReporter(String apiKey);
}

class ReporterConfigPigeon {
  String apiKey;

  Map<String?, String?>? appEnvironment;
  bool? dataSendingEnabled;
  int? dispatchPeriodSeconds;
  bool? logs;
  int? maxReportsCount;
  int? maxReportsInDatabaseCount;
  int? sessionTimeout;
  String? userProfileID;
}

@HostApi
abstract class ReporterPigeon {
  void clearAppEnvironment(String apiKey);

  void pauseSession(String apiKey);

  void putAppEnvironmentValue(String apiKey, String key, String? value);

  void reportAdRevenue(String apiKey, AdRevenuePigeon adRevenue);

  void reportECommerce(String apiKey, ECommerceEventPigeon event);

  void reportError(String apiKey, ErrorDetailsPigeon error, String? message);

  void reportErrorWithGroup(String apiKey, String groupId, ErrorDetailsPigeon? error, String? message);

  void reportEvent(String apiKey, String eventName);

  void reportEventWithJson(String apiKey, String eventName, String? attributesJson);

  void reportRevenue(String apiKey, RevenuePigeon revenue);

  void reportUnhandledException(String apiKey, ErrorDetailsPigeon error);

  void reportUserProfile(String apiKey, UserProfilePigeon userProfile);

  void resumeSession(String apiKey);

  void sendEventsBuffer(String apiKey);

  void setDataSendingEnabled(String apiKey, bool enabled);

  void setUserProfileID(String apiKey, String? userProfileID);
}

@HostApi()
abstract class InitialDeepLinkHolderPigeon {
  String? getInitialDeeplink();
}
