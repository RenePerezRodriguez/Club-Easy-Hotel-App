import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private var deepLinkUrl: URL?

  override func application(_ application: UIApplication,
                            continue userActivity: NSUserActivity,
                            restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
       let incomingURL = userActivity.webpageURL {
      deepLinkUrl = incomingURL
      // Guarda la URL para usarla cuando Flutter la solicite
    }
    return false
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let deepLinkChannel = FlutterMethodChannel(name: "com.easyhotel/deeplink",
                                               binaryMessenger: controller.binaryMessenger)
    deepLinkChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: FlutterResult) -> Void in
      // Verifica que el método llamado desde Flutter sea 'getDeepLink'
      if call.method == "getDeepLink" {
        self.sendDeepLink(result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func sendDeepLink(result: FlutterResult) {
    if let url = deepLinkUrl {
      result(url.absoluteString)
    } else {
      result(nil)
    }
  }
}