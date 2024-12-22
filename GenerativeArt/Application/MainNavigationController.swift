import UIKit

final class MainNavigationController: UINavigationController, UINavigationControllerDelegate {
  override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)

    delegate = self
    isNavigationBarHidden = true
    isToolbarHidden = false
    navigationBar.prefersLargeTitles = true
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    if viewController is ToolbarController {
      isToolbarHidden = false
      isNavigationBarHidden = true
    } else {
      isToolbarHidden = true
      isNavigationBarHidden = false
    }
  }
}

protocol ToolbarController {}
