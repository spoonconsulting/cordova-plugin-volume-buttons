package com.spoon.volumebuttons;

import android.content.Context;
import android.media.AudioManager;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

public class CDVVolumeButtons extends CordovaPlugin implements View.OnKeyListener {
    private CallbackContext volumeCallbackContext;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("start")) {
            start(callbackContext);
            PluginResult pluginResult = new PluginResult(PluginResult.Status.NO_RESULT);
            pluginResult.setKeepCallback(true);
            this.volumeCallbackContext.sendPluginResult(pluginResult);
            return true;
        } else if (action.equals("stop")) {
            stop();
            return false;
        }
        return false;
    }

    @Override
    public void onResume(boolean multitasking) {
        this.webView.getView().setOnKeyListener(this);
    }

    @Override
    public void onReset() {
        this.webView.getView().setOnKeyListener(null);
    }

    @Override
    public void onDestroy() {
        this.webView.getView().setOnKeyListener(null);
    }

    private void start(CallbackContext callbackContext) {
        if (this.volumeCallbackContext != null) {
            return;
        }
        this.webView.getView().requestFocus();
        this.volumeCallbackContext = callbackContext;
        this.webView.getView().setOnKeyListener(this);
    }

    private void stop() {
        this.webView.getView().setOnKeyListener(null);
        this.volumeCallbackContext.success();
        this.volumeCallbackContext = null;
    }

    @Override
    public boolean onKey(View view, int i, KeyEvent keyEvent) {
        if (keyEvent.getAction() == KeyEvent.ACTION_DOWN ) {
            if(i == KeyEvent.KEYCODE_VOLUME_UP) {
                PluginResult pluginResult = new PluginResult(PluginResult.Status.OK);
                pluginResult.setKeepCallback(true);
                this.volumeCallbackContext.sendPluginResult(pluginResult);
            }
            else if (i == KeyEvent.KEYCODE_VOLUME_DOWN) {
                PluginResult pluginResult = new PluginResult(PluginResult.Status.OK);
                pluginResult.setKeepCallback(true);
                this.volumeCallbackContext.sendPluginResult(pluginResult);
            }
        }
        return true;
    }
}
