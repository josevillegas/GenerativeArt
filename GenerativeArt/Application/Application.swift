import UIKit

enum Message {
  case dismissDrawing
  case showDrawing(DrawingType)
}

final class Application {
  func detailViewController(drawingType: DrawingType, send: @escaping (Message) -> Void) -> UIViewController {
    viewController(for: drawingType, presentationMode: .secondary, send: send)
  }

//  private lazy var splitViewController: UISplitViewController = {
//    let controller = UISplitViewController(style: .doubleColumn)
//    // Set the display mode for the initial state only.
//    controller.preferredDisplayMode = .oneOverSecondary
//    controller.preferredSplitBehavior = .overlay
//    controller.delegate = self
//
//    controller.setViewController(indexViewController(appearance: .sidebar), for: .primary)
//    controller.setViewController(detailViewController, for: .secondary)
//    controller.setViewController(compactNavigationController, for: .compact)
//
//    return controller
//  }()

  private var lastDisplayMode: UISplitViewController.DisplayMode = .automatic

  private func viewController(
    for type: DrawingType,
    presentationMode: DrawingPresentationMode,
    send: @escaping (Message) -> Void
  ) -> UIViewController {
    switch type {
    case .paintingStyle(.mondrian):
      MondrianViewController(presentationMode: presentationMode, send: send)
    case let .tile(type):
      TiledDrawingViewController(viewModel: TiledDrawingViewModel(type: type), presentationMode: presentationMode, send: send)
    }
  }

  func indexViewController(sections: [IndexSection], appearance: IndexAppearance, send: @escaping (Message) -> Void) -> UIViewController {
    IndexViewController(sections: sections, appearance: appearance, send: send)
  }

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
