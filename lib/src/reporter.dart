import 'models/ad_revenue.dart';
import 'models/ecommerce.dart';
import 'models/error_description.dart';
import 'models/profile.dart';
import 'models/revenue.dart';

abstract class AppMetricaReporter {
  Future<void> clearAppEnvironment();

  /// Suspends the current foreground session.
  Future<void> pauseSession();

  Future<void> putAppEnvironmentValue(String key, String? value);

  /// Sends information about ad revenue.
  Future<void> reportAdRevenue(AppMetricaAdRevenue adRevenue);

  /// Sends ecommerce-event.
  Future<void> reportECommerce(AppMetricaECommerceEvent event);

  /// Sends an error with the message [message] and the description [ErrorDescription].
  /// If there is no [errorDescription] description, the current stacktrace will be added automatically.
  Future<void> reportError({
    String? message,
    AppMetricaErrorDescription? errorDescription
  });

  /// Sends an error with its own identifier [groupId]. Errors in reports are grouped by it.
  Future<void> reportErrorWithGroup(
      String groupId, {
        AppMetricaErrorDescription? errorDescription,
        String? message
      });

  /// Sends a custom event message.
  Future<void> reportEvent(String eventName);

  /// Sends an event message in JSON format [attributesJson]
  /// as a string and a short name or description of the event [eventName].
  Future<void> reportEventWithJson(String eventName, String? attributesJson);

  /// Sends an event as a set of attributes [attributes] Map
  /// and the short name or description of the event [eventName].
  Future<void> reportEventWithMap(
      String eventName,
      Map<String, Object>? attributes,
  );

  /// Sends the purchase information to the AppMetrica server.
  Future<void> reportRevenue(AppMetricaRevenue revenue);

  /// Sends an unhandled exception [error].
  Future<void> reportUnhandledException(AppMetricaErrorDescription error);

  /// Sends information about updating the user profile.
  Future<void> reportUserProfile(AppMetricaUserProfile userProfile);

  /// Resumes the foreground session or creates a new one if the session timeout has expired.
  Future<void> resumeSession();

  /// Sends saved events from the buffer.
  Future<void> sendEventsBuffer();

  /// Enables/disables sending statistics to the AppMetrica server.
  ///
  /// Disabling sending statistics for a reporter does not affect sending data from the main API key and other reporters.
  /// But disabling sending data for the main API key stops sending statistics from all reporters.
  Future<void> setDataSendingEnabled(bool enabled);

  /// Sets the ID for the user profile.
  ///
  /// If Profile Id sending is not configured, predefined attributes are not displayed in the web interface.
  Future<void> setUserProfileID(String? userProfileID);
}
