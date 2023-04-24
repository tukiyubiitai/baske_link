import UIKit
import Flutter
import GoogleMaps // 追加

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
   GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyBRtf8M-zYgPr9sTX6Fy3JWoml6FQne5Jc") // 追加
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
