package com.hjc.flutter_walle_plugin;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import java.util.Map;
import android.app.Activity;

import com.meituan.android.walle.ChannelInfo;
import com.meituan.android.walle.WalleChannelReader;

/** FlutterWallePlugin */
public class FlutterWallePlugin implements MethodCallHandler {

  Registrar mRegistrar;

  private FlutterWallePlugin(Registrar mRegistrar) {
    this.mRegistrar = mRegistrar;
 }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "plugins.hjc.com/flutter_walle_plugin");
    final FlutterWallePlugin flutterWallePlugin = new FlutterWallePlugin(registrar);
    channel.setMethodCallHandler(flutterWallePlugin);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getWalleChannel")) {
      getWalleChannel(result);
    } else if (call.method.equals("getWalleChannelInfo")) {
      getWalleChannelInfo(result);
    }
  }

  public void getWalleChannel(Result result) {
    Activity activity = mRegistrar.activity();
    if (activity != null) {
        String channel = WalleChannelReader.getChannel(activity.getApplicationContext());
        result.success(channel);
    } else {
        result.error("NO_ACTIVITY", "no activity error", null);
    }
}

public void getWalleChannelInfo(Result result) {
    Activity activity = mRegistrar.activity();
    if (activity != null) {
        ChannelInfo channelInfo = WalleChannelReader.getChannelInfo(activity.getApplicationContext());
        if (channelInfo != null) {
            String channel = channelInfo.getChannel();
            Map<String, String> extraInfo = channelInfo.getExtraInfo();
            extraInfo.put("_channel", channel);
            result.success(extraInfo);
        } else {
            result.success(null);
        }
    } else {
        result.error("NO_ACTIVITY", "no activity error", null);
    }
}
}
