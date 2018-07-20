package com.crater.plugins.keyboardheight;

import android.app.Activity;
import android.graphics.Point;
import android.graphics.Rect;
import android.view.View;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.view.Window;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** KeyboardHeightPlugin */
public class KeyboardHeightPlugin implements MethodCallHandler {

  private final Activity activity;
  private final View rootView;
  private final Window rootWindow;
  private int height;

  private KeyboardHeightPlugin(Activity activity) {
    this.activity = activity;
    height = 0;

    rootWindow = activity.getWindow();
    rootView = rootWindow.getDecorView().findViewById(android.R.id.content);
    rootView.getViewTreeObserver().addOnGlobalLayoutListener(new OnGlobalLayoutListener() {
        @Override
        public void onGlobalLayout() {
            Rect rect = new Rect();
            Point screen = new Point();
            KeyboardHeightPlugin.this.activity.getWindowManager().getDefaultDisplay().getSize(screen);
            View view = rootWindow.getDecorView();
            view.getWindowVisibleDisplayFrame(rect);
            height = screen.y - rect.bottom;
        }
    });

  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "keyboard_height");
    channel.setMethodCallHandler(new KeyboardHeightPlugin(registrar.activity()));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch(call.method) {
      case "getKeyboardHeight":
        //result.success(height);
        result.success(height);
        break;
      default:
        result.notImplemented();
    }
  }

}
