import Flutter
import UIKit
    
public class SwiftKeyboardHeightPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var height: Int = 0
  private var eventSink: FlutterEventSink?
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "keyboard_height", binaryMessenger: registrar.messenger())
    let instance = SwiftKeyboardHeightPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
    let eventChannel = FlutterEventChannel.init(name: "com.crater.plugins.keyboardheight/stream", binaryMessenger: registrar.messenger())
    eventChannel.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getKeyboardHeight":
      result(height)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = eventSink
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: .UIKeyboardWillShow,
      object: nil
    )
    return nil
  }
  
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    NotificationCenter.default.removeObserver(self)
    eventSink = nil
    return nil
  }
  
  @objc func keyboardWillShow(_ notification: Notification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      height = Int(keyboardSize.height)
      self.sendKeyboardHeightEvent()
    }
  }
  
  private func sendKeyboardHeightEvent() {
    if (eventSink == nil) {
      return
    }
    eventSink!(height)
  }
  
}
