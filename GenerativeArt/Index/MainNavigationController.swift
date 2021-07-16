import UIKit

final class MainNavigationController: UINavigationController {
  override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)

    isNavigationBarHidden = true
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
    if traitCollection.userInterfaceStyle == .dark {
      toolbar.isTranslucent = false
    } else {
      toolbar.isTranslucent = true
    }
  }
}
