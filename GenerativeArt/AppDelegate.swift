import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let window = UIWindow()
    self.window = window
    window.rootViewController = MainNavigationController(rootViewController: MainViewController())
    window.makeKeyAndVisible()
    return true
  }
}
