package io.appmetrica.analytics.flutter;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.appmetrica.analytics.flutter.impl.AppMetricaConfigConverterImpl;
import io.appmetrica.analytics.flutter.impl.AppMetricaImpl;
import io.appmetrica.analytics.flutter.impl.InitialDeepLinkHolderImpl;
import io.appmetrica.analytics.flutter.impl.ReporterImpl;
import io.appmetrica.analytics.flutter.pigeon.Pigeon;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

/** AppMetricaPlugin */
public class AppMetricaPlugin implements FlutterPlugin, ActivityAware {

    @Nullable
    private AppMetricaImpl appMetrica = null;
    @Nullable
    private InitialDeepLinkHolderImpl deeplinkHolder = null;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        appMetrica = new AppMetricaImpl(binding.getApplicationContext());
        deeplinkHolder = new InitialDeepLinkHolderImpl();

        Pigeon.AppMetricaPigeon.setup(binding.getBinaryMessenger(), appMetrica);
        Pigeon.ReporterPigeon.setup(binding.getBinaryMessenger(), new ReporterImpl(binding.getApplicationContext()));
        Pigeon.AppMetricaConfigConverterPigeon.setup(binding.getBinaryMessenger(), new AppMetricaConfigConverterImpl());
        Pigeon.InitialDeepLinkHolderPigeon.setup(binding.getBinaryMessenger(), deeplinkHolder);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        if (appMetrica != null) {
            appMetrica.activity = binding.getActivity();
        }
        if (deeplinkHolder != null) {
            deeplinkHolder.activity = binding.getActivity();
        }
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        if (appMetrica != null) {
            appMetrica.activity = null;
        }
        if (deeplinkHolder != null) {
            deeplinkHolder.activity = null;
        }
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        if (appMetrica != null) {
            appMetrica.activity = binding.getActivity();
        }
        if (deeplinkHolder != null) {
            deeplinkHolder.activity = binding.getActivity();
        }
    }

    @Override
    public void onDetachedFromActivity() {
        if (appMetrica != null) {
            appMetrica.activity = null;
        }
        if (deeplinkHolder != null) {
            deeplinkHolder.activity = null;
        }
    }
}
