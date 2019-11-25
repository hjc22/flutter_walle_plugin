import Flutter
import UIKit

public class SwiftFlutterWallePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "plugins.hjc.com/flutter_walle_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterWallePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
