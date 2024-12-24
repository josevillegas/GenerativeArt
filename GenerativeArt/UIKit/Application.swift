import UIKit

final class Application {
//  private lazy var splitViewController: UISplitViewController = {
//    let controller = UISplitViewController(style: .doubleColumn)
//    // Set the display mode for the initial state only.
//    controller.preferredDisplayMode = .oneOverSecondary
//    controller.preferredSplitBehavior = .overlay
//    controller.delegate = self
//    return controller
//  }()

  private var lastDisplayMode: UISplitViewController.DisplayMode = .automatic

  private func secondaryNavigationController(rootViewController: UIViewController) -> UINavigationController {
    let navigationController = UINavigationController(rootViewController: rootViewController)
    navigationController.isNavigationBarHidden = true
    navigationController.isToolbarHidden = false
    return navigationController
  }
}

extension Application: UISplitViewControllerDelegate {
  func splitViewControllerDidExpand(_ splitViewController: UISplitViewController) {
//    secondaryNavigationController.viewControllers = [viewController(for: lastSelectedDrawingType, presentationMode: .secondary)]
  }

  func splitViewControllerDidCollapse(_ splitViewController: UISplitViewController) {
//    var viewControllers = [compactNavigationController.viewControllers.first].compactMap { $0 }
//    if lastDisplayMode == .secondaryOnly {
//      viewControllers.append(viewController(for: lastSelectedDrawingType, presentationMode: .pushed))
//    }
//    compactNavigationController.viewControllers = viewControllers
  }

  func splitViewController(
    _ splitViewController: UISplitViewController,
    topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column
  ) -> UISplitViewController.Column {
    lastDisplayMode = splitViewController.displayMode
    return proposedTopColumn
  }

  func splitViewController(
    _ splitViewController: UISplitViewController,
    displayModeForExpandingToProposedDisplayMode proposedDisplayMode: UISplitViewController.DisplayMode
  ) -> UISplitViewController.DisplayMode {
//    compactNavigationController.viewControllers.count == 1 ? .oneOverSecondary : .secondaryOnly
    .oneOverSecondary
  }
}
