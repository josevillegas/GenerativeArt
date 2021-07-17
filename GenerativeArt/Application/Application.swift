import UIKit

final class Application {
  lazy var rootViewController: UIViewController = {
    MainNavigationController(rootViewController: MainViewController())
  }()
}
