import UIKit

enum Message {
  case showTiledDrawing(TiledDrawingType)
  case showMondrian
}

enum DrawingMessage {
  case dismiss
}

final class Application {
  var rootViewController: UIViewController {
    navigationController
  }

  private lazy var navigationController: UINavigationController = {
    MainNavigationController(rootViewController: mainViewController)
  }()

  private lazy var mainViewController: MainViewController = {
    MainViewController { [weak self] in self?.update($0) }
  }()

  private func update(_ message: Message) {
    switch message {
    case let .showTiledDrawing(variation):
      let viewModel = TiledDrawingViewModel(
        variation: variation,
        tileForegroundColor: variation.defaultForegroundColor,
        tileBackgroundColor: variation.defaultBackgroundColor
      )
      let viewController = TiledDrawingViewController(viewModel: viewModel, animated: mainViewController.isAnimationOn) { [weak self] in
        self?.update($0)
      }
      push(viewController)
    case .showMondrian:
      push(MondrianViewController { [weak self] in self?.update($0) })
    }
  }

  private func update(_ message: DrawingMessage) {
    switch message {
    case .dismiss: pop()
    }
  }

  private func push(_ viewController: UIViewController) {
    navigationController.pushViewController(viewController, animated: true)
  }

  private func pop() {
    navigationController.popViewController(animated: true)
  }
}
