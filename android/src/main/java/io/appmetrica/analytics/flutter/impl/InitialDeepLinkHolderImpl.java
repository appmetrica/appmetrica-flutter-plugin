package io.appmetrica.analytics.flutter.impl;

import android.app.Activity;
import android.content.Intent;
import androidx.annotation.Nullable;
import io.appmetrica.analytics.flutter.pigeon.Pigeon;

public class InitialDeepLinkHolderImpl implements Pigeon.InitialDeepLinkHolderPigeon {

    @Nullable
    public Activity activity = null;

    @Nullable
    @Override
    public String getInitialDeeplink() {
        if (activity != null) {
            final Intent intent = activity.getIntent();
            if (intent != null) {
                return intent.getDataString();
            }
        }
        return null;
    }
}
