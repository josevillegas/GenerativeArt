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
    secondaryNavigationController.viewControllers = [viewController(for: lastSelectedDrawingType, presentationMode: .secondary)]
  }

  func splitViewControllerDidCollapse(_ svc: UISplitViewController) {
    compactNavigationController.viewControllers = [
      compactNavigationController.viewControllers.first,
      viewController(for: lastSelectedDrawingType, presentationMode: .pushed)
    ].compactMap { $0 }
  }
}
