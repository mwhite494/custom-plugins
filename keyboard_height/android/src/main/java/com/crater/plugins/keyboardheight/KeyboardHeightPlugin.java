package com.crater.plugins.keyboardheight;

import android.app.Activity;
import android.graphics.Point;
import android.graphics.Rect;
import android.view.View;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.view.Window;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.view.FlutterView;

/** KeyboardHeightPlugin */
public class KeyboardHeightPlugin implements MethodCallHandler {

  private static final String STREAM = "com.crater.plugins.keyboardheight/stream";
  private final Activity activity;
  private final View rootView;
  private final Window rootWindow;
  private int height;

  private KeyboardHeightPlugin(Activity activity, FlutterView view) {
    this.activity = activity;
    height = 0;

    rootWindow = activity.getWindow();
    rootView = rootWindow.getDecorView().findViewById(android.R.id.content);

    new EventChannel(view, STREAM).setStreamHandler(
      new EventChannel.StreamHandler() {
        OnGlobalLayoutListener listener = null;

        @Override
        public void onListen(Object args, EventSink events) {
          listener = createOnGlobalLayoutListener(events);
          rootView.getViewTreeObserver().addOnGlobalLayoutListener(listener);    
        }

        @Override
        public void onCancel(Object args) {
          if (listener != null) {
            rootView.getViewTreeObserver().removeOnGlobalLayoutListener(listener);
          }
        }
      }
    );

  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "keyboard_height");
    channel.setMethodCallHandler(new KeyboardHeightPlugin(registrar.activity(), registrar.view()));
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

  private OnGlobalLayoutListener createOnGlobalLayoutListener(final EventSink events) {
    return new OnGlobalLayoutListener() {
      @Override
      public void onGlobalLayout() {
        Rect rect = new Rect();
        Point screen = new Point();
        KeyboardHeightPlugin.this.activity.getWindowManager().getDefaultDisplay().getSize(screen);
        View view = rootWindow.getDecorView();
        view.getWindowVisibleDisplayFrame(rect);
        height = screen.y - rect.bottom;
        events.success(height);
      }
    };
  }

}
