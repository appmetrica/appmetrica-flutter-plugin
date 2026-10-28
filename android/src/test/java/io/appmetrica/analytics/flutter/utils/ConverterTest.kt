package io.appmetrica.analytics.flutter.utils

import android.location.Location
import org.assertj.core.api.Assertions.assertThat
import io.appmetrica.analytics.AdType
import io.appmetrica.analytics.DeferredDeeplinkListener
import io.appmetrica.analytics.DeferredDeeplinkParametersListener
import io.appmetrica.analytics.ModulesFacade
import io.appmetrica.analytics.PreloadInfo
import io.appmetrica.analytics.Revenue
import io.appmetrica.analytics.StartupParamsCallback
import io.appmetrica.analytics.StartupParamsItem
import io.appmetrica.analytics.StartupParamsItemStatus
import io.appmetrica.analytics.flutter.pigeon.Pigeon
import io.appmetrica.analytics.plugins.PluginErrorDetails
import io.appmetrica.analytics.plugins.StackTraceItem
import io.appmetrica.gradle.testutils.assertions.Assertions.ObjectPropertyAssertions
import org.json.JSONObject
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import java.math.BigDecimal
import java.util.Currency

@RunWith(RobolectricTestRunner::class)
class ConverterTest {

    @Test
    fun `toNative revenue converts full optional and minimal fields`() {
        val full = Converter.toNative(
            Pigeon.RevenuePigeon.Builder()
                .setPrice("9.99")
                .setCurrency("USD")
                .setProductId("product_123")
                .setQuantity(2L)
                .setPayload("""{"promotion": "summer_sale"}""")
                .setReceipt(
                    Pigeon.ReceiptPigeon.Builder()
                        .setData("receipt_data_string")
                        .setSignature("receipt_signature")
                        .build()
                )
                .build()
        )
        ObjectPropertyAssertions(full)
            .checkField("priceMicros", 9_990_000L)
            .checkField("currency", Currency.getInstance("USD"))
            .checkField("productID", "product_123")
            .checkField("quantity", 2)
            .checkField("payload", """{"promotion": "summer_sale"}""")
            .checkFieldRecursively<Revenue.Receipt>("receipt") {
                it.checkField("data", "receipt_data_string")
                    .checkField("signature", "receipt_signature")
                    .checkAll()
            }
            .checkAll()

        val minimal = Converter.toNative(
            Pigeon.RevenuePigeon.Builder()
                .setPrice("4.99")
                .setCurrency("EUR")
                .build()
        )
        ObjectPropertyAssertions(minimal)
            .checkField("priceMicros", 4_990_000L)
            .checkField("currency", Currency.getInstance("EUR"))
            .checkFieldIsNull("productID")
            .checkFieldIsNull("quantity")
            .checkFieldIsNull("payload")
            .checkFieldIsNull("receipt")
            .checkAll()

        val refund = Converter.toNative(
            Pigeon.RevenuePigeon.Builder()
                .setPrice("-19.99")
                .setCurrency("USD")
                .setProductId("refunded_product")
                .build()
        )
        ObjectPropertyAssertions(refund)
            .checkField("priceMicros", -19_990_000L)
            .checkField("currency", Currency.getInstance("USD"))
            .checkField("productID", "refunded_product")
            .checkFieldsAreNull("quantity", "payload", "receipt")
            .checkAll()

        val receiptPartial = Converter.toNative(
            Pigeon.RevenuePigeon.Builder()
                .setPrice("1")
                .setCurrency("USD")
                .setReceipt(Pigeon.ReceiptPigeon.Builder().setData("purchase_data").build())
                .build()
        )
        ObjectPropertyAssertions(receiptPartial)
            .checkField("priceMicros", 1_000_000L)
            .checkField("currency", Currency.getInstance("USD"))
            .checkFieldsAreNull("productID", "quantity", "payload")
            .checkFieldRecursively<Revenue.Receipt>("receipt") {
                it.checkField("data", "purchase_data")
                    .checkFieldIsNull("signature")
                    .checkAll()
            }
            .checkAll()
    }

    @Test
    fun `toNative appMetricaConfig converts full and minimal fields`() {
        val apiKey = "12345678-1234-1234-1234-123456789012"
        val minimal = Converter.toNative(
            Pigeon.AppMetricaConfigPigeon.Builder()
                .setApiKey(apiKey)
                .build()
        )
        ObjectPropertyAssertions(minimal)
            .checkField("apiKey", apiKey)
            .checkField("errorEnvironment", emptyMap<String, String>())
            .checkField("appEnvironment", emptyMap<String, String>())
            .checkField("additionalConfig", emptyMap<String, Any>())
            .checkFieldsAreNull(
                "appVersion",
                "sessionTimeout",
                "crashReporting",
                "nativeCrashReporting",
                "location",
                "locationTracking",
                "advIdentifiersTracking",
                "logs",
                "preloadInfo",
                "firstActivationAsUpdate",
                "dataSendingEnabled",
                "maxReportsInDatabaseCount",
                "userProfileID",
                "revenueAutoTrackingEnabled",
                "sessionsAutoTrackingEnabled",
                "appOpenTrackingEnabled",
                "deviceType",
                "appBuildNumber",
                "dispatchPeriodSeconds",
                "maxReportsCount",
                "crashTransformer",
                "anrMonitoring",
                "anrMonitoringTimeout",
                "customHosts",
            )
            .checkAll()

        val full = Converter.toNative(
            Pigeon.AppMetricaConfigPigeon.Builder()
                .setApiKey("87654321-4321-4321-4321-210987654321")
                .setAdvIdentifiersTracking(true)
                .setAnrMonitoring(true)
                .setAnrMonitoringTimeout(5L)
                .setAppBuildNumber(123L)
                .setAppEnvironment(mapOf("env_key" to "env_value"))
                .setAppOpenTrackingEnabled(true)
                .setAppVersion("2.0.0")
                .setCrashReporting(true)
                .setCustomHosts(listOf("host1.example.com", "host2.example.com"))
                .setDataSendingEnabled(true)
                .setDeviceType("phone")
                .setDispatchPeriodSeconds(60L)
                .setErrorEnvironment(mapOf("error_key" to "error_value"))
                .setFirstActivationAsUpdate(true)
                .setLocation(
                    Pigeon.LocationPigeon.Builder()
                        .setLatitude(55.751244)
                        .setLongitude(37.618423)
                        .setProvider("gps")
                        .setAltitude(150.5)
                        .setAccuracy(10.0)
                        .setCourse(45.0)
                        .setSpeed(5.0)
                        .setTimestamp(1_234_567_890L)
                        .build()
                )
                .setLocationTracking(true)
                .setLogs(true)
                .setMaxReportsCount(100L)
                .setMaxReportsInDatabaseCount(5000L)
                .setNativeCrashReporting(true)
                .setPreloadInfo(
                    Pigeon.PreloadInfoPigeon.Builder()
                        .setTrackingId("tracking_id_123")
                        .setAdditionalInfo(mapOf("source" to "partner", "campaign" to "promo"))
                        .build()
                )
                .setRevenueAutoTrackingEnabled(true)
                .setSessionTimeout(30L)
                .setSessionsAutoTrackingEnabled(true)
                .setUserProfileID("user_123")
                .build()
        )
        ObjectPropertyAssertions(full)
            .checkField("apiKey", "87654321-4321-4321-4321-210987654321")
            .checkField("advIdentifiersTracking", true)
            .checkField("anrMonitoring", true)
            .checkField("anrMonitoringTimeout", 5)
            .checkField("appBuildNumber", 123)
            .checkField("appEnvironment", mapOf("env_key" to "env_value"))
            .checkField("appOpenTrackingEnabled", true)
            .checkField("appVersion", "2.0.0")
            .checkField("crashReporting", true)
            .checkField("customHosts", listOf("host1.example.com", "host2.example.com"), true)
            .checkField("dataSendingEnabled", true)
            .checkField("deviceType", "phone")
            .checkField("dispatchPeriodSeconds", 60)
            .checkField("errorEnvironment", mapOf("error_key" to "error_value"))
            .checkField("firstActivationAsUpdate", true)
            .checkFieldMatchPredicate<Location>("location") { location ->
                location.provider == "gps" &&
                    location.latitude == 55.751244 &&
                    location.longitude == 37.618423 &&
                    location.altitude == 150.5 &&
                    location.accuracy == 10f &&
                    location.bearing == 45f &&
                    location.speed == 5f &&
                    location.time == 1_234_567_890L
            }
            .checkField("locationTracking", true)
            .checkField("logs", true)
            .checkField("maxReportsCount", 100)
            .checkField("maxReportsInDatabaseCount", 5000)
            .checkField("nativeCrashReporting", true)
            .checkFieldRecursively<PreloadInfo>("preloadInfo") {
                it.withPrivateFields(true)
                    .checkField("a", "getTrackingId", "tracking_id_123")
                    .checkField(
                        "b",
                        "getAdditionalParams",
                        mapOf("source" to "partner", "campaign" to "promo")
                    )
                    .checkAll()
            }
            .checkField("revenueAutoTrackingEnabled", true)
            .checkField("sessionTimeout", 30)
            .checkField("sessionsAutoTrackingEnabled", true)
            .checkField("userProfileID", "user_123")
            .checkField("additionalConfig", emptyMap<String, Any>())
            .checkFieldIsNull("crashTransformer")
            .checkAll()

        val disabled = Converter.toNative(
            Pigeon.AppMetricaConfigPigeon.Builder()
                .setApiKey(apiKey)
                .setAdvIdentifiersTracking(false)
                .setAnrMonitoring(false)
                .setCrashReporting(false)
                .setDataSendingEnabled(false)
                .setFirstActivationAsUpdate(false)
                .setLocationTracking(false)
                .setNativeCrashReporting(false)
                .setRevenueAutoTrackingEnabled(false)
                .setSessionsAutoTrackingEnabled(false)
                .setAppOpenTrackingEnabled(false)
                .build()
        )
        ObjectPropertyAssertions(disabled)
            .withIgnoredFields(
                "appVersion",
                "sessionTimeout",
                "location",
                "logs",
                "preloadInfo",
                "maxReportsInDatabaseCount",
                "errorEnvironment",
                "userProfileID",
                "deviceType",
                "appBuildNumber",
                "dispatchPeriodSeconds",
                "maxReportsCount",
                "appEnvironment",
                "crashTransformer",
                "anrMonitoringTimeout",
                "customHosts",
                "additionalConfig",
            )
            .checkField("apiKey", apiKey)
            .checkField("advIdentifiersTracking", false)
            .checkField("anrMonitoring", false)
            .checkField("crashReporting", false)
            .checkField("dataSendingEnabled", false)
            .checkField("firstActivationAsUpdate", false)
            .checkField("locationTracking", false)
            .checkField("nativeCrashReporting", false)
            .checkField("revenueAutoTrackingEnabled", false)
            .checkField("sessionsAutoTrackingEnabled", false)
            .checkField("appOpenTrackingEnabled", false)
            .checkAll()
    }

    @Test
    fun `toNative libraryAdapter reporter preloadInfo and location`() {
        val libraryDefault = Converter.toNative(
            Pigeon.AppMetricaLibraryAdapterConfigPigeon.Builder().build()
        )
        ObjectPropertyAssertions(libraryDefault)
            .checkFieldIsNull("advIdentifiersTracking")
            .checkFieldIsNull("customHosts")
            .checkAll()

        val libraryEnabled = Converter.toNative(
            Pigeon.AppMetricaLibraryAdapterConfigPigeon.Builder()
                .setAdvIdentifiersTracking(true)
                .build()
        )
        ObjectPropertyAssertions(libraryEnabled)
            .checkField("advIdentifiersTracking", true)
            .checkFieldIsNull("customHosts")
            .checkAll()

        val libraryDisabled = Converter.toNative(
            Pigeon.AppMetricaLibraryAdapterConfigPigeon.Builder()
                .setAdvIdentifiersTracking(false)
                .build()
        )
        ObjectPropertyAssertions(libraryDisabled)
            .checkField("advIdentifiersTracking", false)
            .checkFieldIsNull("customHosts")
            .checkAll()

        val reporterApiKey = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
        val reporterMinimal = Converter.toNative(
            Pigeon.ReporterConfigPigeon.Builder()
                .setApiKey(reporterApiKey)
                .build()
        )
        ObjectPropertyAssertions(reporterMinimal)
            .checkField("apiKey", reporterApiKey)
            .checkField("appEnvironment", emptyMap<String, String>())
            .checkField("errorEnvironment", emptyMap<String, String>())
            .checkField("additionalConfig", emptyMap<String, Any>())
            .checkFieldsAreNull(
                "sessionTimeout",
                "dataSendingEnabled",
                "maxReportsInDatabaseCount",
                "userProfileID",
                "logs",
                "dispatchPeriodSeconds",
                "maxReportsCount",
            )
            .checkAll()

        val reporterFull = Converter.toNative(
            Pigeon.ReporterConfigPigeon.Builder()
                .setApiKey("ffffffff-1111-2222-3333-444444444444")
                .setAppEnvironment(mapOf("env_key" to "env_value", "key2" to "value2"))
                .setDataSendingEnabled(true)
                .setDispatchPeriodSeconds(120L)
                .setLogs(true)
                .setMaxReportsCount(50L)
                .setMaxReportsInDatabaseCount(2000L)
                .setSessionTimeout(60L)
                .setUserProfileID("reporter_user_123")
                .build()
        )
        ObjectPropertyAssertions(reporterFull)
            .checkField("apiKey", "ffffffff-1111-2222-3333-444444444444")
            .checkField(
                "appEnvironment",
                mapOf("env_key" to "env_value", "key2" to "value2")
            )
            .checkField("dataSendingEnabled", true)
            .checkField("dispatchPeriodSeconds", 120)
            .checkField("logs", true)
            .checkField("maxReportsCount", 50)
            .checkField("maxReportsInDatabaseCount", 2000)
            .checkField("sessionTimeout", 60)
            .checkField("userProfileID", "reporter_user_123")
            .checkField("errorEnvironment", emptyMap<String, String>())
            .checkField("additionalConfig", emptyMap<String, Any>())
            .checkAll()

        val preloadMinimal = Converter.toNative(
            Pigeon.PreloadInfoPigeon.Builder()
                .setTrackingId("tracking_123")
                .build()
        )
        ObjectPropertyAssertions(preloadMinimal)
            .withPrivateFields(true)
            .checkField("a", "getTrackingId", "tracking_123")
            .checkField("b", "getAdditionalParams", emptyMap<String, String>())
            .checkAll()

        val preloadFull = Converter.toNative(
            Pigeon.PreloadInfoPigeon.Builder()
                .setTrackingId("tracking_456")
                .setAdditionalInfo(
                    mapOf(
                        "source" to "partner_app",
                        "campaign" to "preinstall_promo",
                    )
                )
                .build()
        )
        ObjectPropertyAssertions(preloadFull)
            .withPrivateFields(true)
            .checkField("a", "getTrackingId", "tracking_456")
            .checkField(
                "b",
                "getAdditionalParams",
                mapOf("source" to "partner_app", "campaign" to "preinstall_promo")
            )
            .checkAll()

        val locationMinimal = Converter.toNative(
            Pigeon.LocationPigeon.Builder()
                .setLatitude(55.751244)
                .setLongitude(37.618423)
                .build()
        )
        assertThat(locationMinimal.latitude).isEqualTo(55.751244)
        assertThat(locationMinimal.longitude).isEqualTo(37.618423)
        assertThat(locationMinimal.provider).isNull()
        assertThat(locationMinimal.hasAltitude()).isFalse()
        assertThat(locationMinimal.hasAccuracy()).isFalse()
        assertThat(locationMinimal.hasBearing()).isFalse()
        assertThat(locationMinimal.hasSpeed()).isFalse()

        val locationFull = Converter.toNative(
            Pigeon.LocationPigeon.Builder()
                .setLatitude(-33.8688)
                .setLongitude(-151.2093)
                .setProvider("network")
                .setAltitude(-430.5)
                .setAccuracy(0.5)
                .setCourse(359.9)
                .setSpeed(300.0)
                .setTimestamp(1_234_567_890L)
                .build()
        )
        assertThat(locationFull.latitude).isEqualTo(-33.8688)
        assertThat(locationFull.longitude).isEqualTo(-151.2093)
        assertThat(locationFull.provider).isEqualTo("network")
        assertThat(locationFull.altitude).isEqualTo(-430.5)
        assertThat(locationFull.accuracy).isEqualTo(0.5f)
        assertThat(locationFull.bearing).isEqualTo(359.9f)
        assertThat(locationFull.speed).isEqualTo(300f)
        assertThat(locationFull.time).isEqualTo(1_234_567_890L)
    }

    @Test
    fun `toNative userProfile converts attribute types including reset and ifUndefined`() {
        val empty = Converter.toNative(
            Pigeon.UserProfilePigeon.Builder()
                .setAttributes(emptyList())
                .build()
        )
        assertThat(empty.userProfileUpdates).isEmpty()

        fun attr(
            type: Pigeon.UserProfileAttributeType,
            key: String = "",
            configure: Pigeon.UserProfileAttributePigeon.Builder.() -> Unit = {},
        ): Pigeon.UserProfileAttributePigeon {
            return Pigeon.UserProfileAttributePigeon.Builder()
                .setKey(key)
                .setType(type)
                .apply(configure)
                .build()
        }

        val profile = Converter.toNative(
            Pigeon.UserProfilePigeon.Builder()
                .setAttributes(
                    listOf(
                        attr(Pigeon.UserProfileAttributeType.NAME) { setStringValue("Alice") },
                        attr(Pigeon.UserProfileAttributeType.GENDER) {
                            setGenderValue(Pigeon.GenderPigeon.FEMALE)
                        },
                        attr(Pigeon.UserProfileAttributeType.BIRTH_DATE) { setAge(25L) },
                        attr(Pigeon.UserProfileAttributeType.BIRTH_DATE) { setYear(1990L) },
                        attr(Pigeon.UserProfileAttributeType.BIRTH_DATE) {
                            setYear(1985L)
                            setMonth(6L)
                        },
                        attr(Pigeon.UserProfileAttributeType.BIRTH_DATE) {
                            setYear(1985L)
                            setMonth(6L)
                            setDay(15L)
                        },
                        attr(Pigeon.UserProfileAttributeType.BIRTH_DATE) { setReset(true) },
                        attr(Pigeon.UserProfileAttributeType.NOTIFICATION_ENABLED) {
                            setBoolValue(true)
                        },
                        attr(Pigeon.UserProfileAttributeType.STRING, "level") {
                            setStringValue("gold")
                        },
                        attr(Pigeon.UserProfileAttributeType.STRING, "status") {
                            setStringValue("active")
                            setIfUndefined(true)
                        },
                        attr(Pigeon.UserProfileAttributeType.STRING, "country") { setReset(true) },
                        attr(Pigeon.UserProfileAttributeType.NUMBER, "score") {
                            setDoubleValue(1500.5)
                        },
                        attr(Pigeon.UserProfileAttributeType.NUMBER, "default_score") {
                            setDoubleValue(100.0)
                            setIfUndefined(true)
                        },
                        attr(Pigeon.UserProfileAttributeType.NUMBER, "balance") { setReset(true) },
                        attr(Pigeon.UserProfileAttributeType.BOOLEAN, "premium") {
                            setBoolValue(true)
                        },
                        attr(Pigeon.UserProfileAttributeType.BOOLEAN, "is_new") {
                            setBoolValue(false)
                            setIfUndefined(true)
                        },
                        attr(Pigeon.UserProfileAttributeType.BOOLEAN, "is_premium") {
                            setReset(true)
                        },
                        attr(Pigeon.UserProfileAttributeType.COUNTER, "purchases") {
                            setDoubleValue(1.0)
                        },
                        attr(Pigeon.UserProfileAttributeType.GENDER) { setReset(true) },
                        attr(Pigeon.UserProfileAttributeType.NAME) { setReset(true) },
                        attr(Pigeon.UserProfileAttributeType.NOTIFICATION_ENABLED) {
                            setReset(true)
                        },
                        attr(Pigeon.UserProfileAttributeType.PHONE_HASH) {
                            setStringValues(listOf("+1234567890", null, "+0987654321"))
                        },
                        attr(Pigeon.UserProfileAttributeType.EMAIL_HASH) {
                            setStringValues(listOf("user@example.com", "test@test.com"))
                        },
                        attr(Pigeon.UserProfileAttributeType.TELEGRAM_LOGIN_HASH) {
                            setStringValues(listOf("@user1", "@user2"))
                        },
                        attr(Pigeon.UserProfileAttributeType.GENDER) {
                            setGenderValue(Pigeon.GenderPigeon.MALE)
                        },
                        attr(Pigeon.UserProfileAttributeType.GENDER) {
                            setGenderValue(Pigeon.GenderPigeon.OTHER)
                        },
                    )
                )
                .build()
        )
        assertThat(profile.userProfileUpdates).hasSize(26)
        assertThat(profile.userProfileUpdates).doesNotContainNull()
    }

    @Test
    fun `toNative stackTrace pluginError adRevenue and externalAttribution`() {
        val stackItem = Converter.toNative(
            Pigeon.StackTraceElementPigeon.Builder()
                .setClassName("io.example.Foo")
                .setFileName("foo.dart")
                .setMethodName("bar")
                .setLine(42L)
                .setColumn(7L)
                .build()
        )
        // Published analytics AAR obfuscates StackTraceItem / PluginErrorDetails fields.
        ObjectPropertyAssertions(stackItem)
            .withPrivateFields(true)
            .checkField("a", "getClassName", "io.example.Foo")
            .checkField("b", "getFileName", "foo.dart")
            .checkField("c", "getLine", 42)
            .checkField("d", "getColumn", 7)
            .checkField("e", "getMethodName", "bar")
            .checkAll()

        val errorWithBacktrace = Converter.toNative(
            Pigeon.ErrorDetailsPigeon.Builder()
                .setExceptionClass("TestException")
                .setMessage("Test error message")
                .setDartVersion("3.5.0")
                .setBacktrace(
                    listOf(
                        Pigeon.StackTraceElementPigeon.Builder()
                            .setClassName("ClassA")
                            .setFileName("a.dart")
                            .setMethodName("methodA")
                            .setLine(10L)
                            .setColumn(1L)
                            .build()
                    )
                )
                .build()
        )
        ObjectPropertyAssertions(errorWithBacktrace)
            .withPrivateFields(true)
            .checkField("a", "getExceptionClass", "TestException")
            .checkField("b", "getMessage", "Test error message")
            .checkFieldMatchPredicate<List<StackTraceItem>>("c", "getStacktrace") { stack ->
                stack.size == 1 && stack[0].fileName == "a.dart"
            }
            .checkField("d", "getPlatform", PluginErrorDetails.Platform.FLUTTER)
            .checkField("e", "getVirtualMachineVersion", "3.5.0")
            .checkField("f", "getPluginEnvironment", emptyMap<String, String>())
            .checkAll()

        val errorWithoutBacktrace = Converter.toNative(
            Pigeon.ErrorDetailsPigeon.Builder()
                .setExceptionClass("")
                .setDartVersion("3.5.0")
                .build()
        )
        ObjectPropertyAssertions(errorWithoutBacktrace)
            .withPrivateFields(true)
            .checkField("a", "getExceptionClass", "")
            .checkFieldIsNull("b", "getMessage")
            .checkField("c", "getStacktrace", emptyList<StackTraceItem>())
            .checkField("d", "getPlatform", PluginErrorDetails.Platform.FLUTTER)
            .checkField("e", "getVirtualMachineVersion", "3.5.0")
            .checkField("f", "getPluginEnvironment", emptyMap<String, String>())
            .checkAll()

        val adRevenueFull = Converter.toNative(
            Pigeon.AdRevenuePigeon.Builder()
                .setAdRevenue("0.05")
                .setCurrency("USD")
                .setAdType(Pigeon.AdTypePigeon.BANNER)
                .setAdNetwork("AdMob")
                .setAdUnitId("unit_123")
                .setAdUnitName("Banner Unit")
                .setAdPlacementId("placement_456")
                .setAdPlacementName("Home Screen")
                .setPrecision("publisher_defined")
                .setPayload(mapOf("key1" to "value1", "key2" to "value2"))
                .build()
        )
        ObjectPropertyAssertions(adRevenueFull)
            .checkField("adRevenue", BigDecimal("0.05"))
            .checkField("currency", Currency.getInstance("USD"))
            .checkField("adType", AdType.BANNER)
            .checkField("adNetwork", "AdMob")
            .checkField("adUnitId", "unit_123")
            .checkField("adUnitName", "Banner Unit")
            .checkField("adPlacementId", "placement_456")
            .checkField("adPlacementName", "Home Screen")
            .checkField("precision", "publisher_defined")
            .checkField("payload", mapOf("key1" to "value1", "key2" to "value2"))
            .checkAll()

        val adRevenueMinimal = Converter.toNative(
            Pigeon.AdRevenuePigeon.Builder()
                .setAdRevenue("1.23")
                .setCurrency("EUR")
                .build()
        )
        ObjectPropertyAssertions(adRevenueMinimal)
            .checkField("adRevenue", BigDecimal("1.23"))
            .checkField("currency", Currency.getInstance("EUR"))
            .checkFieldsAreNull(
                "adType",
                "adNetwork",
                "adUnitId",
                "adUnitName",
                "adPlacementId",
                "adPlacementName",
                "precision",
                "payload",
            )
            .checkAll()

        val adTypes = mapOf(
            Pigeon.AdTypePigeon.UNKNOWN to null,
            Pigeon.AdTypePigeon.NATIVE to AdType.NATIVE,
            Pigeon.AdTypePigeon.BANNER to AdType.BANNER,
            Pigeon.AdTypePigeon.REWARDED to AdType.REWARDED,
            Pigeon.AdTypePigeon.INTERSTITIAL to AdType.INTERSTITIAL,
            Pigeon.AdTypePigeon.MREC to AdType.MREC,
            Pigeon.AdTypePigeon.APP_OPEN to AdType.APP_OPEN,
            Pigeon.AdTypePigeon.OTHER to AdType.OTHER,
        )
        adTypes.forEach { (pigeonType, expected) ->
            val converted = Converter.toNative(
                Pigeon.AdRevenuePigeon.Builder()
                    .setAdRevenue("1")
                    .setCurrency("USD")
                    .setAdType(pigeonType)
                    .build()
            )
            assertThat(converted.adType).isEqualTo(expected)
        }

        val sources = mapOf(
            "appsflyer" to ModulesFacade.EXTERNAL_ATTRIBUTION_APPSFLYER,
            "adjust" to ModulesFacade.EXTERNAL_ATTRIBUTION_ADJUST,
            "kochava" to ModulesFacade.EXTERNAL_ATTRIBUTION_KOCHAVA,
            "tenjin" to ModulesFacade.EXTERNAL_ATTRIBUTION_TENJIN,
            "airbridge" to ModulesFacade.EXTERNAL_ATTRIBUTION_AIRBRIDGE,
            "singular" to ModulesFacade.EXTERNAL_ATTRIBUTION_SINGULAR,
        )
        sources.forEach { (source, expectedSource) ->
            val data = mapOf<String, Any>(
                "campaign" to "${source}_campaign",
                "network" to "facebook",
            )
            val attribution = Converter.toNative(
                Pigeon.ExternalAttributionPigeon.Builder()
                    .setSource(source)
                    .setData(data)
                    .build()
            )
            ObjectPropertyAssertions(attribution)
                .checkField("source", expectedSource)
                .checkFieldNonNull("data")
                .checkAll()
            val json = JSONObject(attribution.data)
            assertThat(json.getString("campaign")).isEqualTo("${source}_campaign")
            assertThat(json.getString("network")).isEqualTo("facebook")
        }

        val adjustFull = Converter.toNative(
            Pigeon.ExternalAttributionPigeon.Builder()
                .setSource("adjust")
                .setData(
                    mapOf(
                        "trackerToken" to "token123",
                        "trackerName" to "TrackerName",
                        "network" to "facebook",
                        "campaign" to "summer_promo",
                        "adgroup" to "group1",
                        "creative" to "creative1",
                        "clickLabel" to "click_label",
                        "adid" to "adid123",
                        "costType" to "cpi",
                        "costAmount" to 1.5,
                        "costCurrency" to "USD",
                        "fbInstallReferrer" to "fb_referrer",
                    )
                )
                .build()
        )
        ObjectPropertyAssertions(adjustFull)
            .checkField("source", ModulesFacade.EXTERNAL_ATTRIBUTION_ADJUST)
            .checkFieldNonNull("data")
            .checkAll()
        val adjustJson = JSONObject(adjustFull.data)
        assertThat(adjustJson.getString("trackerToken")).isEqualTo("token123")
        assertThat(adjustJson.getDouble("costAmount")).isEqualTo(1.5)
    }

    @Test
    fun `toPigeon startup params statuses items result reason and combined`() {
        assertThat(Converter.toPigeon(StartupParamsItemStatus.OK))
            .isEqualTo(Pigeon.StartupParamsItemStatusPigeon.OK)
        assertThat(Converter.toPigeon(StartupParamsItemStatus.PROVIDER_UNAVAILABLE))
            .isEqualTo(Pigeon.StartupParamsItemStatusPigeon.PROVIDER_UNAVAILABLE)
        assertThat(Converter.toPigeon(StartupParamsItemStatus.INVALID_VALUE_FROM_PROVIDER))
            .isEqualTo(Pigeon.StartupParamsItemStatusPigeon.INVALID_VALUE_FROM_PROVIDER)
        assertThat(Converter.toPigeon(StartupParamsItemStatus.FEATURE_DISABLED))
            .isEqualTo(Pigeon.StartupParamsItemStatusPigeon.FEATURE_DISABLED)
        assertThat(Converter.toPigeon(StartupParamsItemStatus.UNKNOWN_ERROR))
            .isEqualTo(Pigeon.StartupParamsItemStatusPigeon.UNKNOWN_ERROR)
        assertThat(Converter.toPigeon(StartupParamsItemStatus.FORBIDDEN_BY_CLIENT_CONFIG))
            .isEqualTo(Pigeon.StartupParamsItemStatusPigeon.UNKNOWN_ERROR)

        val item = Converter.toPigeon(
            StartupParamsItem("item_123", StartupParamsItemStatus.OK, "No errors")
        )
        ObjectPropertyAssertions(item)
            .withPrivateFields(true)
            .withFinalFieldOnly(false)
            .checkField("id", "getId", "item_123")
            .checkField("status", "getStatus", Pigeon.StartupParamsItemStatusPigeon.OK)
            .checkField("errorDetails", "getErrorDetails", "No errors")
            .checkAll()

        val itemWithNulls = Converter.toPigeon(
            StartupParamsItem(null, StartupParamsItemStatus.UNKNOWN_ERROR, null)
        )
        ObjectPropertyAssertions(itemWithNulls)
            .withPrivateFields(true)
            .withFinalFieldOnly(false)
            .checkFieldIsNull("id", "getId")
            .checkField("status", "getStatus", Pigeon.StartupParamsItemStatusPigeon.UNKNOWN_ERROR)
            .checkFieldIsNull("errorDetails", "getErrorDetails")
            .checkAll()

        val parameters = linkedMapOf(
            StartupParamsCallback.APPMETRICA_DEVICE_ID to
                StartupParamsItem("device_123", StartupParamsItemStatus.OK, null),
            StartupParamsCallback.APPMETRICA_DEVICE_ID_HASH to
                StartupParamsItem("hash_456", StartupParamsItemStatus.OK, null),
            StartupParamsCallback.APPMETRICA_UUID to
                StartupParamsItem("uuid_789", StartupParamsItemStatus.OK, null),
            "param1" to StartupParamsItem("id1", StartupParamsItemStatus.OK, null),
            "device_id" to StartupParamsItem(
                "device_value",
                StartupParamsItemStatus.FEATURE_DISABLED,
                null
            ),
        )
        val resultPigeon = Converter.toPigeon(StartupParamsCallback.Result(parameters))
        ObjectPropertyAssertions(resultPigeon)
            .withPrivateFields(true)
            .withFinalFieldOnly(false)
            .checkField("deviceId", "getDeviceId", "device_123")
            .checkField("deviceIdHash", "getDeviceIdHash", "hash_456")
            .checkField("uuid", "getUuid", "uuid_789")
            .checkFieldMatchPredicate<Map<String, Pigeon.StartupParamsItemPigeon?>>("parameters") {
                it.size == 5 &&
                    it["param1"]!!.id == "id1" &&
                    it["param1"]!!.status == Pigeon.StartupParamsItemStatusPigeon.OK &&
                    it["device_id"]!!.status ==
                    Pigeon.StartupParamsItemStatusPigeon.FEATURE_DISABLED
            }
            .checkAll()

        val emptyResult = Converter.toPigeon(StartupParamsCallback.Result(emptyMap()))
        ObjectPropertyAssertions(emptyResult)
            .withPrivateFields(true)
            .withFinalFieldOnly(false)
            .checkFieldIsNull("deviceId", "getDeviceId")
            .checkFieldIsNull("deviceIdHash", "getDeviceIdHash")
            .checkFieldIsNull("uuid", "getUuid")
            .checkField("parameters", "getParameters", emptyMap<String, Any>())
            .checkAll()

        assertThat(Converter.toPigeon(StartupParamsCallback.Reason.NETWORK).value)
            .isEqualTo("NETWORK")
        assertThat(Converter.toPigeon(StartupParamsCallback.Reason.INVALID_RESPONSE).value)
            .isEqualTo("INVALID_RESPONSE")
        assertThat(Converter.toPigeon(StartupParamsCallback.Reason.UNKNOWN).value)
            .isEqualTo("UNKNOWN")
        assertThat(Converter.toPigeon(StartupParamsCallback.Reason("SOME_NEW_REASON")).value)
            .isEqualTo("SOME_NEW_REASON")

        val withResultOnly = Converter.toPigeon(
            StartupParamsCallback.Result(
                mapOf(
                    StartupParamsCallback.APPMETRICA_DEVICE_ID to
                        StartupParamsItem("device_123", StartupParamsItemStatus.OK, null),
                    StartupParamsCallback.APPMETRICA_UUID to
                        StartupParamsItem("uuid_456", StartupParamsItemStatus.OK, null),
                )
            ),
            null
        )
        assertThat(withResultOnly.result!!.deviceId).isEqualTo("device_123")
        assertThat(withResultOnly.result!!.uuid).isEqualTo("uuid_456")
        assertThat(withResultOnly.reason).isNull()

        val withReasonOnly = Converter.toPigeon(null, StartupParamsCallback.Reason.NETWORK)
        assertThat(withReasonOnly.result).isNull()
        assertThat(withReasonOnly.reason!!.value).isEqualTo("NETWORK")

        val withBoth = Converter.toPigeon(
            StartupParamsCallback.Result(
                mapOf(
                    StartupParamsCallback.APPMETRICA_DEVICE_ID to
                        StartupParamsItem("device_id", StartupParamsItemStatus.OK, null)
                )
            ),
            StartupParamsCallback.Reason.INVALID_RESPONSE
        )
        assertThat(withBoth.result!!.deviceId).isEqualTo("device_id")
        assertThat(withBoth.reason!!.value).isEqualTo("INVALID_RESPONSE")

        val emptyParams = Converter.toPigeon(null, null)
        assertThat(emptyParams.result).isNull()
        assertThat(emptyParams.reason).isNull()
    }

    @Test
    fun `toPigeon deferred deeplink and parameters`() {
        val success = Converter.toPigeon("app://deeplink/path", null, null)
        assertThat(success.deeplink).isEqualTo("app://deeplink/path")
        assertThat(success.error).isNull()

        val errors = listOf(
            DeferredDeeplinkListener.Error.NOT_A_FIRST_LAUNCH to
                Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.NOT_A_FIRST_LAUNCH,
            DeferredDeeplinkListener.Error.PARSE_ERROR to
                Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.PARSE_ERROR,
            DeferredDeeplinkListener.Error.NO_REFERRER to
                Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.NO_REFERRER,
            DeferredDeeplinkListener.Error.UNKNOWN to
                Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.UNKNOWN,
        )
        errors.forEach { (error, expectedReason) ->
            val pigeon = Converter.toPigeon(null, error, "message_arg")
            assertThat(pigeon.deeplink).isNull()
            assertThat(pigeon.error!!.reason).isEqualTo(expectedReason)
            assertThat(pigeon.error!!.message).isEqualTo("message_arg")
            assertThat(pigeon.error!!.errorDescription).isEqualTo(error.description)
        }

        val unknownWithoutError = Converter.toPigeon(null as String?, null, "fallback")
        assertThat(unknownWithoutError.error!!.reason)
            .isEqualTo(Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.UNKNOWN)
        assertThat(unknownWithoutError.error!!.errorDescription).isEmpty()
        assertThat(unknownWithoutError.error!!.message).isEqualTo("fallback")

        val paramsSuccess = Converter.toPigeon(
            mapOf("key" to "value", "campaign" to "summer"),
            null,
            null
        )
        assertThat(paramsSuccess.parameters)
            .isEqualTo(mapOf("key" to "value", "campaign" to "summer"))
        assertThat(paramsSuccess.error).isNull()

        val paramErrors = listOf(
            DeferredDeeplinkParametersListener.Error.NOT_A_FIRST_LAUNCH to
                Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.NOT_A_FIRST_LAUNCH,
            DeferredDeeplinkParametersListener.Error.PARSE_ERROR to
                Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.PARSE_ERROR,
            DeferredDeeplinkParametersListener.Error.NO_REFERRER to
                Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.NO_REFERRER,
            DeferredDeeplinkParametersListener.Error.UNKNOWN to
                Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.UNKNOWN,
        )
        paramErrors.forEach { (error, expectedReason) ->
            val pigeon = Converter.toPigeon(null as Map<String, String>?, error, "params_message")
            assertThat(pigeon.parameters).isNull()
            assertThat(pigeon.error!!.reason).isEqualTo(expectedReason)
            assertThat(pigeon.error!!.message).isEqualTo("params_message")
            assertThat(pigeon.error!!.errorDescription).isEqualTo(error.description)
        }

        val paramsUnknown = Converter.toPigeon(null as Map<String, String>?, null, null)
        assertThat(paramsUnknown.error!!.reason)
            .isEqualTo(Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.UNKNOWN)
        assertThat(paramsUnknown.error!!.errorDescription).isEmpty()
    }
}
