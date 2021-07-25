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
    let navigationController = UINavigationController(rootViewController: viewController(for: lastSelectedDrawingType))
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

    controller.setViewController(indexViewController(), for: .primary)
    controller.setViewController(secondaryNavigationController, for: .secondary)
    controller.setViewController(compactNavigationController, for: .compact)

    return controller
  }()

  private let configuration: Configuration
  private var lastSelectedDrawingType: DrawingType = .tile(.diagonals)

  init(configuration: Configuration) {
    self.configuration = configuration
  }

  private func update(_ message: Message) {
    switch message {
    case .dismissDrawing:
      dismissDrawing()
    case let .showDrawing(type):
      lastSelectedDrawingType = type
      showDrawing(viewController(for: type))
    }
  }

  private func viewController(for type: DrawingType) -> UIViewController {
    switch type {
    case .paintingStyle(.mondrian):
      return MondrianViewController { [weak self] in self?.update($0) }
    case let .tile(type):
      return TiledDrawingViewController(viewModel: TiledDrawingViewModel(type: type)) { [weak self] in
        self?.update($0)
      }
    }
  }

  private func showDrawing(_ viewController: UIViewController) {
    splitViewController.preferredDisplayMode = .automatic
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
  func splitViewControllerDidExpand(_ svc: UISplitViewController) {
    secondaryNavigationController.viewControllers = [viewController(for: lastSelectedDrawingType)]
  }

  func splitViewControllerDidCollapse(_ svc: UISplitViewController) {
    compactNavigationController.popToRootViewController(animated: false)
    compactNavigationController.pushViewController(viewController(for: lastSelectedDrawingType), animated: false)
  }
}
