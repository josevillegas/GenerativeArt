import UIKit

enum Message {
  case dismissDrawing
  case showDrawing(DrawingType)
}

final class Application {
  var rootViewController: UIViewController {
    splitViewController
  }

  private lazy var compactNavigationController: UINavigationController = {
    MainNavigationController(rootViewController: indexViewController(appearance: .insetGrouped))
  }()

  private lazy var secondaryNavigationController: UINavigationController = {
    let rootViewController = viewController(for: lastSelectedDrawingType, presentationMode: .secondary)
    let navigationController = UINavigationController(rootViewController: rootViewController)
    navigationController.isNavigationBarHidden = true
    navigationController.isToolbarHidden = false
    return navigationController
  }()

  private lazy var splitViewController: UISplitViewController = {
    let controller = UISplitViewController(style: .doubleColumn)
    // Set the display mode for the initial state only.
    controller.preferredDisplayMode = .oneOverSecondary
    controller.preferredSplitBehavior = .overlay
    controller.delegate = self

    controller.setViewController(indexViewController(appearance: .sidebar), for: .primary)
    controller.setViewController(secondaryNavigationController, for: .secondary)
    controller.setViewController(compactNavigationController, for: .compact)

    return controller
  }()

  private var lastSelectedDrawingType: DrawingType = .tile(.diagonals)
  private var lastDisplayMode: UISplitViewController.DisplayMode = .automatic

  private let sections = [
    IndexSection(title: "Lines", rows: [
      .tile(.diagonals),
      .tile(.scribbles)
    ]),
    IndexSection(title: "Shapes", rows: [
      .tile(.triangles),
      .tile(.quadrants),
      .tile(.trianglesAndQuadrants),
      .tile(.concentricShapes)
    ]),
    IndexSection(title: "Painting Styles", rows: [
      .paintingStyle(.mondrian)
    ])
  ]

  private func update(_ message: Message) {
    switch message {
    case .dismissDrawing:
      dismissDrawing()
    case let .showDrawing(type):
      lastSelectedDrawingType = type
      showDrawing(type)
    }
  }

  private func viewController(for type: DrawingType, presentationMode: DrawingPresentationMode) -> UIViewController {
    switch type {
    case .paintingStyle(.mondrian):
      return MondrianViewController(presentationMode: presentationMode) { [weak self] in self?.update($0) }
    case let .tile(type):
      return TiledDrawingViewController(viewModel: TiledDrawingViewModel(type: type), presentationMode: presentationMode) { [weak self] in
        self?.update($0)
      }
    }
  }

  private func showDrawing(_ type: DrawingType) {
    splitViewController.preferredDisplayMode = .automatic
    if splitViewController.isCollapsed {
      compactNavigationController.pushViewController(viewController(for: type, presentationMode: .pushed), animated: true)
    } else {
      secondaryNavigationController.viewControllers = [viewController(for: type, presentationMode: .secondary)]
      splitViewController.show(.secondary)
    }
  }

  private func dismissDrawing() {
    if splitViewController.isCollapsed {
      compactNavigationController.popViewController(animated: true)
    } else {
      splitViewController.show(.primary)
    }
  }

  private func indexViewController(appearance: IndexAppearance) -> UIViewController {
    IndexViewController(sections: sections, appearance: appearance) { [weak self] in self?.update($0) }
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
    secondaryNavigationController.viewControllers = [viewController(for: lastSelectedDrawingType, presentationMode: .secondary)]
  }

  func splitViewControllerDidCollapse(_ splitViewController: UISplitViewController) {
    var viewControllers = [compactNavigationController.viewControllers.first].compactMap { $0 }
    if lastDisplayMode == .secondaryOnly {
      viewControllers.append(viewController(for: lastSelectedDrawingType, presentationMode: .pushed))
    }
    compactNavigationController.viewControllers = viewControllers
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
    compactNavigationController.viewControllers.count == 1 ? .oneOverSecondary : .secondaryOnly
  }
}
