package io.appmetrica.analytics.flutter.utils;

import android.location.Location;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.appmetrica.analytics.AdRevenue;
import io.appmetrica.analytics.AdType;
import io.appmetrica.analytics.AppMetricaConfig;
import io.appmetrica.analytics.DeferredDeeplinkListener;
import io.appmetrica.analytics.DeferredDeeplinkParametersListener;
import io.appmetrica.analytics.ModulesFacade;
import io.appmetrica.analytics.PreloadInfo;
import io.appmetrica.analytics.ReporterConfig;
import io.appmetrica.analytics.Revenue;
import io.appmetrica.analytics.StartupParamsCallback;
import io.appmetrica.analytics.StartupParamsItem;
import io.appmetrica.analytics.StartupParamsItemStatus;
import io.appmetrica.analytics.flutter.pigeon.Pigeon;
import io.appmetrica.analytics.plugins.PluginErrorDetails;
import io.appmetrica.analytics.plugins.StackTraceItem;
import io.appmetrica.analytics.profile.Attribute;
import io.appmetrica.analytics.profile.BirthDateAttribute;
import io.appmetrica.analytics.profile.BooleanAttribute;
import io.appmetrica.analytics.profile.CounterAttribute;
import io.appmetrica.analytics.profile.GenderAttribute;
import io.appmetrica.analytics.profile.NameAttribute;
import io.appmetrica.analytics.profile.NotificationsEnabledAttribute;
import io.appmetrica.analytics.profile.NumberAttribute;
import io.appmetrica.analytics.profile.StringAttribute;
import io.appmetrica.analytics.profile.UserProfile;
import io.appmetrica.analytics.profile.UserProfileUpdate;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Currency;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.json.JSONObject;

public class Converter {

    @NonNull
    public static Revenue toNative(@NonNull final Pigeon.RevenuePigeon pigeon) {
        final Revenue.Builder resultBuilder = Revenue.newBuilder(
            new BigDecimal(pigeon.getPrice()).multiply(new BigDecimal(1_000_000)).longValue(),
            Currency.getInstance(pigeon.getCurrency())
        );

        final String productId = pigeon.getProductId();
        if (productId != null) {
            resultBuilder.withProductID(productId);
        }

        final String payload = pigeon.getPayload();
        if (payload != null) {
            resultBuilder.withPayload(payload);
        }

        final Long quantity = pigeon.getQuantity();
        if (quantity != null) {
            resultBuilder.withQuantity(quantity.intValue());
        }

        final Pigeon.ReceiptPigeon receiptPigeon = pigeon.getReceipt();
        if (receiptPigeon != null) {
            final Revenue.Receipt.Builder receiptBuilder = Revenue.Receipt.newBuilder();

            final String data = receiptPigeon.getData();
            if (data != null) {
                receiptBuilder.withData(data);
            }

            final String signature = receiptPigeon.getSignature();
            if (signature != null) {
                receiptBuilder.withSignature(signature);
            }

            resultBuilder.withReceipt(receiptBuilder.build());
        }
        return resultBuilder.build();
    }

    @NonNull
    public static AppMetricaConfig toNative(@NonNull final Pigeon.AppMetricaConfigPigeon pigeon) {
        final AppMetricaConfig.Builder resultBuilder = AppMetricaConfig.newConfigBuilder(pigeon.getApiKey());

        final Boolean anrMonitoring = pigeon.getAnrMonitoring();
        if (anrMonitoring != null) {
            resultBuilder.withAnrMonitoring(anrMonitoring);
        }

        final Long anrMonitoringTimeout = pigeon.getAnrMonitoringTimeout();
        if (anrMonitoringTimeout != null) {
            resultBuilder.withAnrMonitoringTimeout(anrMonitoringTimeout.intValue());
        }

        final Long appBuildNumber = pigeon.getAppBuildNumber();
        if (appBuildNumber != null) {
            resultBuilder.withAppBuildNumber(appBuildNumber.intValue());
        }

        final Map<String, String> appEnvironment = pigeon.getAppEnvironment();
        if (appEnvironment != null) {
            for (Map.Entry<String, String> entry: appEnvironment.entrySet()) {
                String key = entry.getKey();
                String value = entry.getValue();
                if (key != null) {
                    resultBuilder.withAppEnvironmentValue(key, value);
                }
            }
        }

        final Boolean appOpenTrackingEnabled = pigeon.getAppOpenTrackingEnabled();
        if (appOpenTrackingEnabled != null) {
            resultBuilder.withAppOpenTrackingEnabled(appOpenTrackingEnabled);
        }

        final String appVersion = pigeon.getAppVersion();
        if (appVersion != null) {
            resultBuilder.withAppVersion(appVersion);
        }

        final Boolean crashReporting = pigeon.getCrashReporting();
        if (crashReporting != null) {
            resultBuilder.withCrashReporting(crashReporting);
        }

        final List<String> customHosts = pigeon.getCustomHosts();
        if (customHosts != null) {
            resultBuilder.withCustomHosts(customHosts);
        }

        final Boolean dataSendingEnabled = pigeon.getDataSendingEnabled();
        if (dataSendingEnabled != null) {
            resultBuilder.withDataSendingEnabled(dataSendingEnabled);
        }

        final String deviceType = pigeon.getDeviceType();
        if (deviceType != null) {
            resultBuilder.withDeviceType(deviceType);
        }

        final Long dispatchPeriodSeconds = pigeon.getDispatchPeriodSeconds();
        if (dispatchPeriodSeconds != null) {
            resultBuilder.withDispatchPeriodSeconds(dispatchPeriodSeconds.intValue());
        }

        final Map<String, String> errorEnvironment = pigeon.getErrorEnvironment();
        if (errorEnvironment != null) {
            for(Map.Entry<String, String> entry : errorEnvironment.entrySet()) {
                String key = entry.getKey();
                String value = entry.getValue();
                if (key != null) {
                    resultBuilder.withErrorEnvironmentValue(key, value);
                }
            }
        }

        final Boolean firstActivationAsUpdate = pigeon.getFirstActivationAsUpdate();
        if (firstActivationAsUpdate != null) {
            resultBuilder.handleFirstActivationAsUpdate(firstActivationAsUpdate);
        }

        final Pigeon.LocationPigeon location = pigeon.getLocation();
        if (location != null) {
            resultBuilder.withLocation(toNative(location));
        }

        final Boolean locationTracking = pigeon.getLocationTracking();
        if (locationTracking != null) {
            resultBuilder.withLocationTracking(locationTracking);
        }

        final Boolean logs = pigeon.getLogs();
        if (logs != null) {
            resultBuilder.withLogs();
        }

        final Long maxReportsCount = pigeon.getMaxReportsCount();
        if (maxReportsCount != null) {
            resultBuilder.withMaxReportsCount(maxReportsCount.intValue());
        }

        final Long maxReportsInDatabaseCount = pigeon.getMaxReportsInDatabaseCount();
        if (maxReportsInDatabaseCount != null) {
            resultBuilder.withMaxReportsInDatabaseCount(maxReportsInDatabaseCount.intValue());
        }

        final Boolean nativeCrashReporting = pigeon.getNativeCrashReporting();
        if (nativeCrashReporting != null) {
            resultBuilder.withNativeCrashReporting(nativeCrashReporting);
        }

        final Pigeon.PreloadInfoPigeon preloadInfo = pigeon.getPreloadInfo();
        if (preloadInfo != null) {
            resultBuilder.withPreloadInfo(toNative(preloadInfo));
        }

        final Boolean revenueAutoTrackingEnabled = pigeon.getRevenueAutoTrackingEnabled();
        if (revenueAutoTrackingEnabled != null) {
            resultBuilder.withRevenueAutoTrackingEnabled(revenueAutoTrackingEnabled);
        }

        final Long sessionTimeout = pigeon.getSessionTimeout();
        if (sessionTimeout != null) {
            resultBuilder.withSessionTimeout(sessionTimeout.intValue());
        }

        final Boolean sessionsAutoTrackingEnabled = pigeon.getSessionsAutoTrackingEnabled();
        if (sessionsAutoTrackingEnabled != null) {
            resultBuilder.withSessionsAutoTrackingEnabled(sessionsAutoTrackingEnabled);
        }

        final String userProfileID = pigeon.getUserProfileID();
        if (userProfileID != null) {
            resultBuilder.withUserProfileID(userProfileID);
        }

        return resultBuilder.build();
    }

    @NonNull
    public static ReporterConfig toNative(@NonNull final Pigeon.ReporterConfigPigeon pigeon) {
        final ReporterConfig.Builder resultBuilder = ReporterConfig.newConfigBuilder(pigeon.getApiKey());

        final Map<String, String> appEnvironment = pigeon.getAppEnvironment();
        if (appEnvironment != null) {
            for (Map.Entry<String, String> entry: appEnvironment.entrySet()) {
                String key = entry.getKey();
                String value = entry.getValue();
                if (key != null) {
                    resultBuilder.withAppEnvironmentValue(key, value);
                }
            }
        }

        final Boolean dataSendingEnabled = pigeon.getDataSendingEnabled();
        if (dataSendingEnabled != null) {
            resultBuilder.withDataSendingEnabled(dataSendingEnabled);
        }

        final Long dispatchPeriodSeconds = pigeon.getDispatchPeriodSeconds();
        if (dispatchPeriodSeconds != null) {
            resultBuilder.withDispatchPeriodSeconds(dispatchPeriodSeconds.intValue());
        }

        final Boolean logs = pigeon.getLogs();
        if (logs != null) {
            resultBuilder.withLogs();
        }

        final Long maxReportsCount = pigeon.getMaxReportsCount();
        if (maxReportsCount != null) {
            resultBuilder.withMaxReportsCount(maxReportsCount.intValue());
        }

        final Long maxReportsInDatabaseCount = pigeon.getMaxReportsInDatabaseCount();
        if (maxReportsInDatabaseCount != null) {
            resultBuilder.withMaxReportsInDatabaseCount(maxReportsInDatabaseCount.intValue());
        }

        final Long sessionTimeout = pigeon.getSessionTimeout();
        if (sessionTimeout != null) {
            resultBuilder.withSessionTimeout(sessionTimeout.intValue());
        }

        final String userProfileID = pigeon.getUserProfileID();
        if (userProfileID != null) {
            resultBuilder.withUserProfileID(userProfileID);
        }

        return resultBuilder.build();
    }

    @NonNull
    public static PreloadInfo toNative(@NonNull final Pigeon.PreloadInfoPigeon pigeon) {
        final PreloadInfo.Builder preloadInfoBuilder = PreloadInfo.newBuilder(pigeon.getTrackingId());

        final Map<String, String> additionalInfo = pigeon.getAdditionalInfo();
        if (additionalInfo != null) {
            for(Map.Entry<String, String> entry: additionalInfo.entrySet()) {
                String key = entry.getKey();
                String value = entry.getValue();
                if (key != null) {
                    preloadInfoBuilder.setAdditionalParams(key, value);
                }
            }
        }
        return preloadInfoBuilder.build();
    }

    @NonNull
    public static Location toNative(@NonNull final Pigeon.LocationPigeon pigeon) {
        final Location result = new Location(pigeon.getProvider());
        result.setLongitude(pigeon.getLongitude());
        result.setLatitude(pigeon.getLatitude());

        final Double altitude = pigeon.getAltitude();
        if (altitude != null) {
            result.setAltitude(altitude);
        }

        final Double course = pigeon.getCourse();
        if (course != null) {
            result.setBearing(course.floatValue());
        }

        final Long timestamp = pigeon.getTimestamp();
        if (timestamp != null) {
            result.setTime(timestamp);
        }

        final Double accuracy = pigeon.getAccuracy();
        if (accuracy != null) {
            result.setAccuracy(accuracy.floatValue());
        }

        final Double speed = pigeon.getSpeed();
        if (speed != null) {
            result.setSpeed(speed.floatValue());
        }

        return result;
    }

    private static final Map<Pigeon.GenderPigeon, GenderAttribute.Gender> genderToNative =
        new HashMap<Pigeon.GenderPigeon, GenderAttribute.Gender>() {{
            put(Pigeon.GenderPigeon.MALE, GenderAttribute.Gender.MALE);
            put(Pigeon.GenderPigeon.FEMALE, GenderAttribute.Gender.FEMALE);
            put(Pigeon.GenderPigeon.OTHER, GenderAttribute.Gender.OTHER);
    }};

    @NonNull
    public static UserProfile toNative(@NonNull final Pigeon.UserProfilePigeon pigeon) {
        final UserProfile.Builder resultBuilder = UserProfile.newBuilder();

        final List<Pigeon.UserProfileAttributePigeon> attributePigeons = pigeon.getAttributes();

        final List<UserProfileUpdate<?>> userProfileUpdates = new ArrayList<>();
        for (final Pigeon.UserProfileAttributePigeon attributePigeon: attributePigeons) {
            final Pigeon.UserProfileAttributeType type = attributePigeon.getType();
            if (type != null) {
                switch (type) {
                    case BIRTH_DATE: {
                        final BirthDateAttribute attribute = Attribute.birthDate();

                        if (Boolean.TRUE.equals(attributePigeon.getReset())) {
                            userProfileUpdates.add(attribute.withValueReset());
                        } else {
                            final Long year = attributePigeon.getYear();
                            final Long month = attributePigeon.getMonth();
                            final Long day = attributePigeon.getDay();
                            final Long age = attributePigeon.getAge();

                            if (year == null) {
                                if (age != null) {
                                    userProfileUpdates.add(attribute.withAge(age.intValue()));
                                }
                            } else {
                                if (month == null) {
                                    userProfileUpdates.add(attribute.withBirthDate(year.intValue()));
                                } else {
                                    if (day == null) {
                                        userProfileUpdates.add(attribute.withBirthDate(
                                            year.intValue(),
                                            month.intValue()
                                        ));
                                    } else {
                                        userProfileUpdates.add(attribute.withBirthDate(
                                            year.intValue(),
                                            month.intValue(),
                                            day.intValue()
                                        ));
                                    }
                                }
                            }
                        }
                        break;
                    }

                    case BOOLEAN: {
                        final BooleanAttribute attribute = Attribute.customBoolean(attributePigeon.getKey());
                        if (Boolean.TRUE.equals(attributePigeon.getReset())) {
                            userProfileUpdates.add(attribute.withValueReset());
                        } else {
                            final Boolean boolValue = attributePigeon.getBoolValue();
                            final boolean boolValueWithDefault = boolValue != null ? boolValue : false;
                            if (Boolean.TRUE.equals(attributePigeon.getIfUndefined())) {
                                userProfileUpdates.add(attribute.withValueIfUndefined(boolValueWithDefault));
                            } else {
                                userProfileUpdates.add(attribute.withValue(boolValueWithDefault));
                            }
                        }
                        break;
                    }

                    case COUNTER: {
                        final CounterAttribute attribute = Attribute.customCounter(attributePigeon.getKey());

                        final Double doubleValue = attributePigeon.getDoubleValue();
                        final double doubleValueWithDefault = doubleValue != null ? doubleValue : 0.0;
                        userProfileUpdates.add(attribute.withDelta(doubleValueWithDefault));
                        break;
                    }

                    case GENDER: {
                        final GenderAttribute attribute = Attribute.gender();
                        if (Boolean.TRUE.equals(attributePigeon.getReset())) {
                            userProfileUpdates.add(attribute.withValueReset());
                        } else {
                            final GenderAttribute.Gender nativeGender = genderToNative.get(attributePigeon.getGenderValue());
                            final GenderAttribute.Gender nativeGenderWithDefault = nativeGender != null ? nativeGender : GenderAttribute.Gender.OTHER;
                            userProfileUpdates.add(attribute.withValue(nativeGenderWithDefault));
                        }
                        break;
                    }

                    case NAME: {
                        final NameAttribute attribute = Attribute.name();
                        if (Boolean.TRUE.equals(attributePigeon.getReset())) {
                            userProfileUpdates.add(attribute.withValueReset());
                        } else {
                            final String stringValue = attributePigeon.getStringValue();
                            final String stringValueWithDefault = stringValue != null ? stringValue : "";
                            userProfileUpdates.add(attribute.withValue(stringValueWithDefault));
                        }
                        break;
                    }

                    case NOTIFICATION_ENABLED: {
                        final NotificationsEnabledAttribute attribute = Attribute.notificationsEnabled();
                        if (Boolean.TRUE.equals(attributePigeon.getReset())) {
                            userProfileUpdates.add(attribute.withValueReset());
                        } else {
                            final Boolean boolValue = attributePigeon.getBoolValue();
                            final boolean boolValueWithDefault = boolValue != null ? boolValue : false;
                            userProfileUpdates.add(attribute.withValue(boolValueWithDefault));
                        }
                        break;
                    }

                    case NUMBER: {
                        final NumberAttribute attribute = Attribute.customNumber(attributePigeon.getKey());
                        if (Boolean.TRUE.equals(attributePigeon.getReset())) {
                            userProfileUpdates.add(attribute.withValueReset());
                        } else {
                            final Double doubleValue = attributePigeon.getDoubleValue();
                            final double doubleValueWithDefault = doubleValue != null ? doubleValue : 0.0;
                            if (Boolean.TRUE.equals(attributePigeon.getIfUndefined())) {
                                userProfileUpdates.add(attribute.withValueIfUndefined(doubleValueWithDefault));
                            } else {
                                userProfileUpdates.add(attribute.withValue(doubleValueWithDefault));
                            }
                        }
                        break;
                    }

                    case STRING: {
                        final StringAttribute attribute = Attribute.customString(attributePigeon.getKey());
                        if (Boolean.TRUE.equals(attributePigeon.getReset())) {
                            userProfileUpdates.add(attribute.withValueReset());
                        } else {
                            final String stringValue = attributePigeon.getStringValue();
                            final String stringValueWithDefault = stringValue != null ? stringValue : "";
                            if (Boolean.TRUE.equals(attributePigeon.getIfUndefined())) {
                                userProfileUpdates.add(attribute.withValueIfUndefined(stringValueWithDefault));
                            } else {
                                userProfileUpdates.add(attribute.withValue(stringValueWithDefault));
                            }
                        }
                        break;
                    }
                }
            }
        }

        for (final UserProfileUpdate<?> userProfileUpdate: userProfileUpdates) {
            if (userProfileUpdate != null) {
                resultBuilder.apply(userProfileUpdate);
            }
        }

        return resultBuilder.build();
    }

    @NonNull
    public static StackTraceItem toNative(@NonNull final Pigeon.StackTraceElementPigeon pigeon) {
        return new StackTraceItem.Builder()
            .withFileName(pigeon.getFileName())
            .withClassName(pigeon.getClassName())
            .withMethodName(pigeon.getMethodName())
            .withLine(pigeon.getLine().intValue())
            .withColumn(pigeon.getColumn().intValue())
            .build();
    }

    @NonNull
    public static PluginErrorDetails toNative(@NonNull final Pigeon.ErrorDetailsPigeon pigeon) {
        final PluginErrorDetails.Builder resultBuilder = new PluginErrorDetails.Builder()
            .withExceptionClass(pigeon.getExceptionClass())
            .withMessage(pigeon.getMessage())
            .withPlatform(PluginErrorDetails.Platform.FLUTTER)
            .withVirtualMachineVersion(pigeon.getDartVersion());

        final List<Pigeon.StackTraceElementPigeon> stackTraceElementPigeons = pigeon.getBacktrace();
        if (stackTraceElementPigeons != null) {
            final List<StackTraceItem> stackTraceElements = new ArrayList<>();
            for (final Pigeon.StackTraceElementPigeon stackTraceElementPigeon : stackTraceElementPigeons) {
                stackTraceElements.add(toNative(stackTraceElementPigeon));
            }
            resultBuilder.withStacktrace(stackTraceElements);
        }
        return resultBuilder.build();
    }

    private static final Map<Pigeon.AdTypePigeon, AdType> adTypeToNative =
        new HashMap<Pigeon.AdTypePigeon, AdType>() {{
            put(Pigeon.AdTypePigeon.UNKNOWN, null);
            put(Pigeon.AdTypePigeon.NATIVE, AdType.NATIVE);
            put(Pigeon.AdTypePigeon.BANNER, AdType.BANNER);
            put(Pigeon.AdTypePigeon.REWARDED, AdType.REWARDED);
            put(Pigeon.AdTypePigeon.INTERSTITIAL, AdType.INTERSTITIAL);
            put(Pigeon.AdTypePigeon.MREC, AdType.MREC);
            put(Pigeon.AdTypePigeon.APP_OPEN, AdType.APP_OPEN);
            put(Pigeon.AdTypePigeon.OTHER, AdType.OTHER);
    }};

    @NonNull
    public static AdRevenue toNative(@NonNull final Pigeon.AdRevenuePigeon pigeon) {
        final AdRevenue.Builder resultBuilder = AdRevenue.newBuilder(
            new BigDecimal(pigeon.getAdRevenue()),
            Currency.getInstance(pigeon.getCurrency())
        );

        final Pigeon.AdTypePigeon adTypePigeon = pigeon.getAdType();
        if (adTypePigeon != null) {
            final AdType adType = adTypeToNative.get(adTypePigeon);
            if (adType != null) {
                resultBuilder.withAdType(adType);
            }
        }

        final String adNetwork = pigeon.getAdNetwork();
        if (adNetwork != null) {
            resultBuilder.withAdNetwork(adNetwork);
        }

        final String adUnitId = pigeon.getAdUnitId();
        if (adUnitId != null) {
            resultBuilder.withAdUnitId(adUnitId);
        }

        final String adUnitName = pigeon.getAdUnitName();
        if (adUnitName != null) {
            resultBuilder.withAdUnitName(adUnitName);
        }

        final String adPlacementId = pigeon.getAdPlacementId();
        if (adPlacementId != null) {
            resultBuilder.withAdPlacementId(adPlacementId);
        }

        final String adPlacementName = pigeon.getAdPlacementName();
        if (adPlacementName != null) {
            resultBuilder.withAdPlacementName(adPlacementName);
        }

        final String precision = pigeon.getPrecision();
        if (precision != null) {
            resultBuilder.withPrecision(precision);
        }

        final Map<String, String> payload = pigeon.getPayload();
        if (payload != null) {
            resultBuilder.withPayload(payload);
        }

        return resultBuilder.build();
    }

    @NonNull
    public static Pigeon.StartupParamsItemStatusPigeon toPigeon(@NonNull final StartupParamsItemStatus value) {
        switch (value) {
            case OK:
                return Pigeon.StartupParamsItemStatusPigeon.OK;
            case PROVIDER_UNAVAILABLE:
                return Pigeon.StartupParamsItemStatusPigeon.PROVIDER_UNAVAILABLE;
            case INVALID_VALUE_FROM_PROVIDER:
                return Pigeon.StartupParamsItemStatusPigeon.INVALID_VALUE_FROM_PROVIDER;
            case NETWORK_ERROR:
                return Pigeon.StartupParamsItemStatusPigeon.NETWORK_ERROR;
            case FEATURE_DISABLED:
                return Pigeon.StartupParamsItemStatusPigeon.FEATURE_DISABLED;
            default:
                return Pigeon.StartupParamsItemStatusPigeon.UNKNOWN_ERROR;
        }
    }

    @NonNull
    public static Pigeon.StartupParamsItemPigeon toPigeon(@NonNull final StartupParamsItem value) {
        return new Pigeon.StartupParamsItemPigeon.Builder()
            .setId(value.getId())
            .setStatus(toPigeon(value.getStatus()))
            .setErrorDetails(value.getErrorDetails())
            .build();
    }

    @NonNull
    public static Pigeon.StartupParamsResultPigeon toPigeon(@NonNull final StartupParamsCallback.Result value) {
        final Map<String, Pigeon.StartupParamsItemPigeon> parameters = new HashMap<>();
        for (Map.Entry<String, StartupParamsItem> entry: value.parameters.entrySet()) {
            parameters.put(entry.getKey(), toPigeon(entry.getValue()));
        }
        return new Pigeon.StartupParamsResultPigeon.Builder()
            .setDeviceId(value.deviceId)
            .setDeviceIdHash(value.deviceIdHash)
            .setParameters(parameters)
            .setUuid(value.uuid)
            .build();
    }

    @NonNull
    public static Pigeon.StartupParamsReasonPigeon toPigeon(@NonNull final StartupParamsCallback.Reason value) {
        return new Pigeon.StartupParamsReasonPigeon.Builder()
            .setValue(value.value)
            .build();
    }

    @NonNull
    public static Pigeon.StartupParamsPigeon toPigeon(
        @Nullable StartupParamsCallback.Result result,
        @Nullable StartupParamsCallback.Reason reason
    ) {
        if (reason == null) {
            return new Pigeon.StartupParamsPigeon.Builder()
                .setResult(result != null ? Converter.toPigeon(result) : null)
                .build();
        } else {
            return new Pigeon.StartupParamsPigeon.Builder()
                .setResult(result != null ? Converter.toPigeon(result) : null)
                .setReason(Converter.toPigeon(reason))
                .build();
        }
    }

    @NonNull
    public static Pigeon.AppMetricaDeferredDeeplinkPigeon toPigeon(
        @Nullable String deeplink,
        @Nullable DeferredDeeplinkListener.Error error,
        @Nullable String messageArg
    ) {
        if (deeplink != null) {
            return new Pigeon.AppMetricaDeferredDeeplinkPigeon.Builder()
                .setDeeplink(deeplink)
                .build();
        } else {
            final Pigeon.AppMetricaDeferredDeeplinkReasonPigeon errorPigeon;
            if (error != null) {
                switch (error) {
                    case NOT_A_FIRST_LAUNCH:
                        errorPigeon = Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.NOT_A_FIRST_LAUNCH;
                        break;
                    case PARSE_ERROR:
                        errorPigeon = Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.PARSE_ERROR;
                        break;
                    case NO_REFERRER:
                        errorPigeon = Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.NO_REFERRER;
                        break;
                    default:
                        errorPigeon = Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.UNKNOWN;
                        break;
                }
            } else {
                errorPigeon = Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.UNKNOWN;
            }
            final String errorDescriptionPigeon;
            if (error != null) {
                errorDescriptionPigeon = error.getDescription();
            } else {
                errorDescriptionPigeon = "";
            }

            return new Pigeon.AppMetricaDeferredDeeplinkPigeon.Builder()
                .setDeeplink(null)
                .setError(new Pigeon.AppMetricaDeferredDeeplinkErrorPigeon.Builder()
                    .setReason(errorPigeon)
                    .setMessage(messageArg)
                    .setDescription(errorDescriptionPigeon)
                    .build()
                )
                .build();
        }
    }

    @NonNull
    public static Pigeon.AppMetricaDeferredDeeplinkParametersPigeon toPigeon(
        @Nullable Map<String, String> params,
        @Nullable DeferredDeeplinkParametersListener.Error error,
        @Nullable String messageArg
    ) {
        if (params != null) {
            return new Pigeon.AppMetricaDeferredDeeplinkParametersPigeon.Builder()
                .setParameters(params)
                .build();
        } else {
            final Pigeon.AppMetricaDeferredDeeplinkReasonPigeon errorPigeon;
            if (error != null) {
                switch (error) {
                    case NOT_A_FIRST_LAUNCH:
                        errorPigeon = Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.NOT_A_FIRST_LAUNCH;
                        break;
                    case PARSE_ERROR:
                        errorPigeon = Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.PARSE_ERROR;
                        break;
                    case NO_REFERRER:
                        errorPigeon = Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.NO_REFERRER;
                        break;
                    default:
                        errorPigeon = Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.UNKNOWN;
                        break;
                }
            } else {
                errorPigeon = Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.UNKNOWN;
            }
            final String errorDescriptionPigeon;
            if (error != null) {
                errorDescriptionPigeon = error.getDescription();
            } else {
                errorDescriptionPigeon = "";
            }

            return new Pigeon.AppMetricaDeferredDeeplinkParametersPigeon.Builder()
                .setParameters(null)
                .setError(new Pigeon.AppMetricaDeferredDeeplinkErrorPigeon.Builder()
                    .setReason(errorPigeon)
                    .setMessage(messageArg)
                    .setDescription(errorDescriptionPigeon)
                    .build()
                )
                .build();
        }
    }

    @NonNull
    public static FlutterExternalAttribution toNative(
        @NonNull Pigeon.ExternalAttributionPigeon pigeon
    ) {
        Map<String, Integer> externalAttributionSourceMapping = new HashMap<String, Integer>() {{
            put("appsflyer", ModulesFacade.EXTERNAL_ATTRIBUTION_APPSFLYER);
            put("adjust", ModulesFacade.EXTERNAL_ATTRIBUTION_ADJUST);
            put("kochava", ModulesFacade.EXTERNAL_ATTRIBUTION_KOCHAVA);
            put("tenjin", ModulesFacade.EXTERNAL_ATTRIBUTION_TENJIN);
            put("airbridge", ModulesFacade.EXTERNAL_ATTRIBUTION_AIRBRIDGE);
            put("singular", ModulesFacade.EXTERNAL_ATTRIBUTION_SINGULAR);
        }};
        return new FlutterExternalAttribution(
            externalAttributionSourceMapping.get(pigeon.getSource()),
            new JSONObject(pigeon.getData()).toString()
        );
    }
}
