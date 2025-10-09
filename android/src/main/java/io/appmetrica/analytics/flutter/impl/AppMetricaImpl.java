package io.appmetrica.analytics.flutter.impl;

import android.app.Activity;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.appmetrica.analytics.AppMetrica;
import io.appmetrica.analytics.DeferredDeeplinkListener;
import io.appmetrica.analytics.DeferredDeeplinkParametersListener;
import io.appmetrica.analytics.ModulesFacade;
import io.appmetrica.analytics.StartupParamsCallback;
import io.appmetrica.analytics.ecommerce.ECommerceEvent;
import io.appmetrica.analytics.flutter.pigeon.Pigeon;
import io.appmetrica.analytics.flutter.utils.Converter;
import io.appmetrica.analytics.flutter.utils.ECommerceConverter;
import io.appmetrica.analytics.flutter.utils.FlutterExternalAttribution;
import java.util.List;
import java.util.Map;

public class AppMetricaImpl implements Pigeon.AppMetricaPigeon {

    @NonNull
    private final Context context;
    @NonNull
    private final Handler mainHandler = new Handler(Looper.getMainLooper());

    @Nullable
    public Activity activity = null;

    public AppMetricaImpl(
        @NonNull final Context context
    ) {
        this.context = context;
    }

    @Override
    public void activate(@NonNull Pigeon.AppMetricaConfigPigeon config) {
        AppMetrica.activate(context, Converter.toNative(config));
    }

    @Override
    public void activateReporter(@NonNull Pigeon.ReporterConfigPigeon config) {
        AppMetrica.activateReporter(context, Converter.toNative(config));
    }

    @Override
    public void clearAppEnvironment() {
        AppMetrica.clearAppEnvironment();
    }

    @Override
    public void enableActivityAutoTracking() {
        if (activity != null) {
            AppMetrica.enableActivityAutoTracking(activity.getApplication());
        }
    }

    @Nullable
    @Override
    public String getDeviceId() {
        return AppMetrica.getDeviceId(context);
    }

    @Override
    public void touchReporter(@NonNull String apiKey) {
        AppMetrica.getReporter(context, apiKey);
    }

    @NonNull
    @Override
    public Long getLibraryApiLevel() {
        return (long) AppMetrica.getLibraryApiLevel();
    }

    @NonNull
    @Override
    public String getLibraryVersion() {
        return AppMetrica.getLibraryVersion();
    }

    @Nullable
    @Override
    public String getUuid() {
        return AppMetrica.getUuid(context);
    }

    @Override
    public void resumeSession() {
        AppMetrica.resumeSession(activity);
    }

    @Override
    public void pauseSession() {
        AppMetrica.pauseSession(activity);
    }

    @Override
    public void putAppEnvironmentValue(@NonNull String key, @Nullable String value) {
        AppMetrica.putAppEnvironmentValue(key, value);
    }

    @Override
    public void reportAppOpen(@NonNull String deeplink) {
        AppMetrica.reportAppOpen(deeplink);
    }

    @Override
    public void reportError(@NonNull Pigeon.ErrorDetailsPigeon error, @Nullable String message) {
        AppMetrica.getPluginExtension().reportError(Converter.toNative(error), message);
    }

    @Override
    public void reportErrorWithGroup(
        @NonNull String groupId,
        @Nullable Pigeon.ErrorDetailsPigeon error,
        @Nullable String message
    ) {
        AppMetrica.getPluginExtension().reportError(
            groupId,
            message,
            error != null ? Converter.toNative(error) : null
        );
    }

    @Override
    public void reportUnhandledException(@NonNull Pigeon.ErrorDetailsPigeon error) {
        AppMetrica.getPluginExtension().reportUnhandledException(Converter.toNative(error));
    }

    @Override
    public void reportEventWithJson(@NonNull String eventName, @Nullable String attributesJson) {
        AppMetrica.reportEvent(eventName, attributesJson);
    }

    @Override
    public void reportExternalAttribution(@NonNull Pigeon.ExternalAttributionPigeon externalAttributionPigeon) {
        FlutterExternalAttribution attribution = Converter.toNative(externalAttributionPigeon);
        ModulesFacade.reportExternalAttribution(attribution.source, attribution.data);
    }

    @Override
    public void reportEvent(@NonNull String eventName) {
        AppMetrica.reportEvent(eventName);
    }

    @Override
    @SuppressWarnings("deprecation")
    public void reportReferralUrl(@NonNull String referralUrl) {
        AppMetrica.reportReferralUrl(referralUrl);
    }

    @Override
    public void requestDeferredDeeplink(@NonNull Pigeon.Result<Pigeon.AppMetricaDeferredDeeplinkPigeon> result) {
        AppMetrica.requestDeferredDeeplink(new DeferredDeeplinkListener() {
            @Override
            public void onDeeplinkLoaded(@NonNull String deeplink) {
                mainHandler.post(() -> result.success(
                    Converter.toPigeon(deeplink, null, null)
                ));
            }

            @Override
            public void onError(@NonNull DeferredDeeplinkListener.Error error, @Nullable String messageArg) {
                mainHandler.post(() -> result.success(
                    Converter.toPigeon(null, error, messageArg)
                ));
            }
        });
    }

    @Override
    public void requestDeferredDeeplinkParameters(@NonNull Pigeon.Result<Pigeon.AppMetricaDeferredDeeplinkParametersPigeon> result) {
        AppMetrica.requestDeferredDeeplinkParameters(new DeferredDeeplinkParametersListener() {
            @Override
            public void onParametersLoaded(@NonNull Map<String, String> params) {
                mainHandler.post(() -> result.success(
                    Converter.toPigeon(params, null, null)
                ));
            }

            @Override
            public void onError(@NonNull DeferredDeeplinkParametersListener.Error error, @NonNull String messageArg) {
                mainHandler.post(() -> result.success(
                    Converter.toPigeon(null, error, messageArg)
                ));
            }
        });
    }

    @Override
    public void requestStartupParams(
        @NonNull List<String> params,
        @NonNull Pigeon.Result<Pigeon.StartupParamsPigeon> pigeonResult
    ) {
        AppMetrica.requestStartupParams(context, new StartupParamsCallback() {
            @Override
            public void onReceive(@Nullable Result result) {
                mainHandler.post(() -> pigeonResult.success(
                    Converter.toPigeon(result, null)
                ));
            }

            @Override
            public void onRequestError(@NonNull Reason reason, @Nullable Result result) {
                mainHandler.post(() -> pigeonResult.success(
                    Converter.toPigeon(result, reason)
                ));
            }
        }, params);
    }

    @Override
    public void sendEventsBuffer() {
        AppMetrica.sendEventsBuffer();
    }

    @Override
    public void setAdvIdentifiersTracking(@NonNull Boolean enabled) {
        AppMetrica.setAdvIdentifiersTracking(enabled);
    }

    @Override
    public void setDataSendingEnabled(@NonNull Boolean enabled) {
        AppMetrica.setDataSendingEnabled(enabled);
    }

    @Override
    public void setLocation(@Nullable Pigeon.LocationPigeon location) {
        AppMetrica.setLocation(location != null ? Converter.toNative(location) : null);
    }

    @Override
    public void setLocationTracking(@NonNull Boolean enabled) {
        AppMetrica.setLocationTracking(enabled);
    }

    @Override
    public void setUserProfileID(@Nullable String userProfileID) {
        AppMetrica.setUserProfileID(userProfileID);
    }

    @Override
    public void reportUserProfile(@NonNull Pigeon.UserProfilePigeon userProfile) {
        AppMetrica.reportUserProfile(Converter.toNative(userProfile));
    }

    @Override
    public void putErrorEnvironmentValue(@NonNull String key, @Nullable String value) {
        AppMetrica.putErrorEnvironmentValue(key, value);
    }

    @Override
    public void reportRevenue(@NonNull Pigeon.RevenuePigeon revenue) {
        AppMetrica.reportRevenue(Converter.toNative(revenue));
    }

    @Override
    public void reportECommerce(@NonNull Pigeon.ECommerceEventPigeon event) {
        final ECommerceEvent eCommerceEvent = ECommerceConverter.toNative(event);
        if (eCommerceEvent != null) {
            AppMetrica.reportECommerce(eCommerceEvent);
        }
    }

    @Override
    public void handlePluginInitFinished() {
        AppMetrica.resumeSession(activity);
    }

    @Override
    public void reportAdRevenue(@NonNull Pigeon.AdRevenuePigeon adRevenue) {
        AppMetrica.reportAdRevenue(Converter.toNative(adRevenue));
    }
}
