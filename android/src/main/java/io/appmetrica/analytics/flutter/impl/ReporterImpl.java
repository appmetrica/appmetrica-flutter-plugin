package io.appmetrica.analytics.flutter.impl;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.appmetrica.analytics.AppMetrica;
import io.appmetrica.analytics.ecommerce.ECommerceEvent;
import io.appmetrica.analytics.flutter.pigeon.Pigeon;
import io.appmetrica.analytics.flutter.utils.Converter;
import io.appmetrica.analytics.flutter.utils.ECommerceConverter;
import io.appmetrica.analytics.plugins.PluginErrorDetails;

public class ReporterImpl implements Pigeon.ReporterPigeon {

    @NonNull
    final Context context;

    public ReporterImpl(@NonNull final Context context) {
        this.context = context;
    }

    @Override
    public void sendEventsBuffer(@NonNull String apiKey) {
        AppMetrica.getReporter(context, apiKey).sendEventsBuffer();
    }

    @Override
    public void setDataSendingEnabled(@NonNull String apiKey, @NonNull Boolean enabled) {
        AppMetrica.getReporter(context, apiKey).setDataSendingEnabled(enabled);
    }

    @Override
    public void reportEvent(@NonNull String apiKey, @NonNull String eventName) {
        AppMetrica.getReporter(context, apiKey).reportEvent(eventName);
    }

    @Override
    public void reportEventWithJson(@NonNull String apiKey, @NonNull String eventName, @Nullable String attributesJson) {
        AppMetrica.getReporter(context, apiKey).reportEvent(eventName, attributesJson);
    }

    @Override
    public void reportError(@NonNull String apiKey, @NonNull Pigeon.ErrorDetailsPigeon error, @Nullable String message) {
        AppMetrica.getReporter(context, apiKey).getPluginExtension()
            .reportError(Converter.toNative(error), message);
    }

    @Override
    public void reportErrorWithGroup(
        @NonNull String apiKey,
        @NonNull String groupId,
        @Nullable Pigeon.ErrorDetailsPigeon error,
        @Nullable String message
    ) {
        AppMetrica.getReporter(context, apiKey).getPluginExtension()
            .reportError(groupId, message, error != null ? Converter.toNative(error) : null);
    }

    @Override
    public void reportUnhandledException(@NonNull String apiKey, @NonNull Pigeon.ErrorDetailsPigeon error) {
        AppMetrica.getReporter(context, apiKey).getPluginExtension()
            .reportUnhandledException(Converter.toNative(error));
    }

    @Override
    public void resumeSession(@NonNull String apiKey) {
        AppMetrica.getReporter(context, apiKey).resumeSession();
    }

    @Override
    public void clearAppEnvironment(@NonNull String apiKey) {
        AppMetrica.getReporter(context, apiKey).clearAppEnvironment();
    }

    @Override
    public void pauseSession(@NonNull String apiKey) {
        AppMetrica.getReporter(context, apiKey).pauseSession();
    }

    @Override
    public void putAppEnvironmentValue(@NonNull String apiKey, @NonNull String key, @Nullable String value) {
        AppMetrica.getReporter(context, apiKey).putAppEnvironmentValue(key, value);
    }

    @Override
    public void setUserProfileID(@NonNull String apiKey, @Nullable String userProfileID) {
        AppMetrica.getReporter(context, apiKey).setUserProfileID(userProfileID);
    }

    @Override
    public void reportUserProfile(@NonNull String apiKey, @NonNull Pigeon.UserProfilePigeon userProfile) {
        AppMetrica.getReporter(context, apiKey).reportUserProfile(Converter.toNative(userProfile));
    }

    @Override
    public void reportRevenue(@NonNull String apiKey, @NonNull Pigeon.RevenuePigeon revenue) {
        AppMetrica.getReporter(context, apiKey).reportRevenue(Converter.toNative(revenue));
    }

    @Override
    public void reportECommerce(@NonNull String apiKey, @NonNull Pigeon.ECommerceEventPigeon event) {
        final ECommerceEvent eCommerceEvent = ECommerceConverter.toNative(event);
        if (eCommerceEvent != null) {
            AppMetrica.getReporter(context, apiKey).reportECommerce(eCommerceEvent);
        }
    }

    @Override
    public void reportAdRevenue(@NonNull String apiKey, @NonNull Pigeon.AdRevenuePigeon adRevenue) {
        AppMetrica.getReporter(context, apiKey).reportAdRevenue(Converter.toNative(adRevenue));
    }
}
