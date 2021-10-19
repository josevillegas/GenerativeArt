import UIKit

final class MainNavigationController: UINavigationController, UINavigationControllerDelegate {
  override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)

    delegate = self
    isNavigationBarHidden = true
    isToolbarHidden = false
    navigationBar.prefersLargeTitles = true
    updateToolbarColor()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
      updateToolbarColor()
    }
  }

  private func updateToolbarColor() {
    if #available(iOS 15, *) { return }

    if traitCollection.userInterfaceStyle == .dark {
      toolbar.isTranslucent = false
    } else {
      toolbar.isTranslucent = true
    }
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
