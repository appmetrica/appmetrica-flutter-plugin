library appmetrica;

export 'src/internal/activation_config_holder.dart' // internal API
    show
        AppMetricaActivationConfigHolder,
        AppMetricaActivationCompleter;
export 'src/internal/appmetrica_library_adapter.dart' // internal API
    show
        AppMetricaLibraryAdapter;
export 'src/models/ad_revenue.dart'
    show
        AppMetricaAdRevenue,
        AppMetricaAdType;
export 'src/appmetrica.dart'
    show
        AppMetrica,
        setUpErrorHandlingWithAppMetrica, // internal API
        setUpAppMetricaLogger; // internal API
export 'src/models/appmetrica_config.dart'
    show
        AppMetricaConfig;
export 'src/models/deferred_deeplink_result.dart'
    show
        AppMetricaDeferredDeeplinkRequestException,
        AppMetricaDeferredDeeplinkErrorReason;
export 'src/models/device_id_result.dart'
    show
        AppMetricaDeviceIdRequestException,
        AppMetricaDeviceIdErrorReason;
export 'src/models/ecommerce.dart'
    show
        AppMetricaECommerceAmount,
        AppMetricaECommerceProduct,
        AppMetricaECommercePrice,
        AppMetricaECommerceReferrer,
        AppMetricaECommerceScreen,
        AppMetricaECommerceCartItem,
        AppMetricaECommerceOrder,
        AppMetricaECommerce,
        AppMetricaECommerceEvent;
export 'src/models/error_description.dart'
    show
        AppMetricaErrorDescription;
export 'src/models/location.dart'
    show
        AppMetricaLocation;
export 'src/models/preload_info.dart'
    show
        AppMetricaPreloadInfo;
export 'src/models/reporter_config.dart'
    show
        AppMetricaReporterConfig;
export 'src/models/revenue.dart'
    show
        AppMetricaRevenue,
        AppMetricaReceipt;
export 'src/reporter.dart'
    show
        AppMetricaReporter;
export 'src/models/startup_params.dart'
    show
        AppMetricaStartupParamsItemStatus,
        AppMetricaStartupParamsItem,
        AppMetricaStartupParamsResult,
        AppMetricaStartupParamsReason,
        AppMetricaStartupParams;
export 'src/models/profile.dart'
    show
        AppMetricaBirthDateAttribute,
        AppMetricaBooleanAttribute,
        AppMetricaCounterAttribute,
        AppMetricaGenderAttribute,
        AppMetricaGender,
        AppMetricaNameAttribute,
        AppMetricaNotificationEnabledAttribute,
        AppMetricaNumberAttribute,
        AppMetricaStringAttribute,
        AppMetricaUserProfile;
export 'src/models/external_attribution.dart'
    show
        AppMetricaExternalAttribution;
