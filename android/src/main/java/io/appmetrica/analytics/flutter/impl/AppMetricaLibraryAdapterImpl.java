package io.appmetrica.analytics.flutter.impl;

import android.content.Context;
import androidx.annotation.NonNull;
import io.appmetrica.analytics.AppMetricaLibraryAdapter;
import io.appmetrica.analytics.flutter.pigeon.Pigeon;

public class AppMetricaLibraryAdapterImpl implements Pigeon.AppMetricaLibraryAdapterPigeon {

    @NonNull
    private final Context context;

    public AppMetricaLibraryAdapterImpl(
        @NonNull final Context context
    ) {
        this.context = context;
    }

    @Override
    public void subscribeForAutoCollectedData(@NonNull String apiKey) {
        AppMetricaLibraryAdapter.subscribeForAutoCollectedData(context, apiKey);
    }
}
