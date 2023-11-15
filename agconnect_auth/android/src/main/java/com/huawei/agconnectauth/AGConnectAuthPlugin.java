/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2021. All rights reserved.
 */

package com.huawei.agconnectauth;

import android.content.Context;

import androidx.annotation.NonNull;

import com.huawei.agconnect.AGConnectInstance;
import com.huawei.agconnect.auth.AGConnectAuth;
import com.huawei.agconnect.core.service.auth.OnTokenListener;
import com.huawei.agconnect.core.service.auth.TokenSnapshot;
import com.huawei.agconnectauth.handlers.AGConnectAuthMethodCallHandler;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class AGConnectAuthPlugin implements FlutterPlugin, EventChannel.StreamHandler {
    private MethodChannel channel;
    private EventChannel eventChannel;
    private EventChannel.EventSink eventSink;
    private MethodCallHandler methodCallHandler;
    private AGConnectAuthModule agConnectAuthModule;

    public static void registerWith(Registrar registrar) {
        AGConnectAuthPlugin instance = new AGConnectAuthPlugin();
        instance.initPlugin(registrar.messenger(), registrar.context().getApplicationContext());
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        initPlugin(flutterPluginBinding.getBinaryMessenger(), flutterPluginBinding.getApplicationContext());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        eventChannel.setStreamHandler(null);
        methodCallHandler = null;
    }

    private void initPlugin(BinaryMessenger messenger, Context context) {
        if (AGConnectInstance.getInstance() == null) {
            AGConnectInstance.initialize(context);
        }
        agConnectAuthModule = new AGConnectAuthModule();
        methodCallHandler = new AGConnectAuthMethodCallHandler(agConnectAuthModule);
        channel = new MethodChannel(messenger, "com.huawei.flutter/agconnect_auth");
        channel.setMethodCallHandler(methodCallHandler);
        eventChannel = new EventChannel(messenger, "com.huawei.flutter.event/agconnect_auth");
        eventChannel.setStreamHandler(this);

        AGConnectAuth.getInstance().addTokenListener(new OnTokenListener() {
            @Override
            public void onChanged(TokenSnapshot tokenSnapshot) {
                if (eventSink != null) {
                    eventSink.success(mapFromTokenSnapshot(tokenSnapshot));
                }
            }
        });
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        eventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        eventSink = null;
    }

    private Map<String, Object> mapFromTokenSnapshot(TokenSnapshot token) {
        if (token != null) {
            Map<String, Object> res = new HashMap<>();
            res.put("state", token.getState().ordinal());
            res.put("token", token.getToken());
            return res;
        } else {
            return null;
        }
    }

}
