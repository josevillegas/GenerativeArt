import UIKit

enum Message {
  case dismissDrawing
  case showDrawing(DrawingType)
}

protocol Configuration {
  var sections: [Index.Section] { get }
}

final class Application {
  var rootViewController: UIViewController {
    splitViewController
  }

  private lazy var compactNavigationController: UINavigationController = {
    MainNavigationController(rootViewController: indexViewController())
  }()

  private lazy var secondaryNavigationController: UINavigationController = {
    let navigationController = UINavigationController(rootViewController:  tileViewController(type: .diagonals))
    navigationController.isNavigationBarHidden = true
    navigationController.isToolbarHidden = false
    return navigationController
  }()

  private lazy var splitViewController: UISplitViewController = {
    let controller = UISplitViewController(style: .doubleColumn)
    controller.delegate = self
    controller.preferredSplitBehavior = .overlay

    controller.setViewController(indexViewController(), for: .primary)
    controller.setViewController(secondaryNavigationController, for: .secondary)
    controller.setViewController(compactNavigationController, for: .compact)

    return controller
  }()

  private let configuration: Configuration

  init(configuration: Configuration) {
    self.configuration = configuration
  }

  private func update(_ message: Message) {
    switch message {
    case .dismissDrawing: dismissDrawing()
    case let .showDrawing(type):
      switch type {
      case .paintingStyle(.mondrian):
        showDrawing(MondrianViewController { [weak self] in self?.update($0) })
      case let .tile(type):
        showDrawing(tileViewController(type: type))
      }
    }
  }

  private func showDrawing(_ viewController: UIViewController) {
    if splitViewController.isCollapsed {
      compactNavigationController.pushViewController(viewController, animated: true)
    } else {
      secondaryNavigationController.viewControllers = [viewController]
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

  private func tileViewController(type: TiledDrawingType) -> UIViewController {
    let viewModel = TiledDrawingViewModel(
      variation: type,
      tileForegroundColor: type.defaultForegroundColor,
      tileBackgroundColor: type.defaultBackgroundColor
    )
    return TiledDrawingViewController(viewModel: viewModel) { [weak self] in
      self?.update($0)
    }
  }

  private func indexViewController() -> UIViewController {
    IndexViewController(index: Index(sections: configuration.sections)) { [weak self] in self?.update($0) }
  }

  private func secondaryNavigationController(rootViewController: UIViewController) -> UINavigationController {
    let navigationController = UINavigationController(rootViewController: rootViewController)
    navigationController.isNavigationBarHidden = true
    navigationController.isToolbarHidden = false
    return navigationController
  }
}

extension Application: UISplitViewControllerDelegate {
  func splitViewController(_ svc: UISplitViewController, willShow column: UISplitViewController.Column) {
    print("WILL SHOW: \(column)")
  }

  func splitViewController(_ svc: UISplitViewController, willHide column: UISplitViewController.Column) {
    print("WILL HIDE: \(column)")
  }

  func splitViewController(
    _ svc: UISplitViewController,
    topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column
  ) -> UISplitViewController.Column {
    print("COLLAPSING: \(proposedTopColumn)")
    return proposedTopColumn
  }

  func splitViewController(
    _ svc: UISplitViewController,
    displayModeForExpandingToProposedDisplayMode proposedDisplayMode: UISplitViewController.DisplayMode
  ) -> UISplitViewController.DisplayMode {
    print("EXPANDING: \(proposedDisplayMode)")
    return proposedDisplayMode
  }

  func splitViewControllerDidExpand(_ svc: UISplitViewController) {
    print("DID EXPAND")
  }

  func splitViewControllerDidCollapse(_ svc: UISplitViewController) {
    print("DID COLLAPSE")
  }

  func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
    print("WILL CHANGE: \(displayMode)")
  }
}
