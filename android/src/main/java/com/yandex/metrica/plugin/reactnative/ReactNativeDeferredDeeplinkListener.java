/*
 * Version for React Native
 * © 2020 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

package com.yandex.metrica.plugin.reactnative;

import com.facebook.react.bridge.Callback;
import com.yandex.metrica.DeferredDeeplinkListener;

public class ReactNativeDeferredDeeplinkListener implements DeferredDeeplinkListener {

    private final Callback listener;

    ReactNativeDeferredDeeplinkListener(Callback listener) {
        this.listener = listener;
    }

    @Override
    public void onDeeplinkLoaded(String deeplink) {
        Log.i("Deeplink", "deeplink = " + deeplink);
        listener.invoke(deeplink, null);
    }

    @Override
    public void onError(Error error, String referrer) {
        Log.i("Deeplink", "Error: " + error.getDescription() + ", unparsed referrer: " + referrer);
        listener.invoke(null, "Error: " + error.getDescription() + ", unparsed referrer: " + referrer);
    }
}
