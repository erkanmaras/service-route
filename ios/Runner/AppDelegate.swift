import UIKit
import Flutter
// Google map
import GoogleMaps
// Google map
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      // Google map Api Key
      GMSServices.provideAPIKey("AIzaSyBI_-xfrCCRa5W7RnQIP7q3gGKiOckpPz8")
      // Google map Api Key
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
