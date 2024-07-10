package io.appmetrica.analytics.flutter.impl;

import androidx.annotation.NonNull;
import io.appmetrica.analytics.flutter.pigeon.Pigeon;
import io.appmetrica.analytics.flutter.utils.Converter;

public class AppMetricaConfigConverterImpl implements Pigeon.AppMetricaConfigConverterPigeon {

    @NonNull
    @Override
    public String toJson(@NonNull Pigeon.AppMetricaConfigPigeon config) {
        return Converter.toNative(config).toJson();
    }
}
