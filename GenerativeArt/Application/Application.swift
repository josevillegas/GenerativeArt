import UIKit

enum Message {
  case showTiledDrawing(TiledDrawingType)
  case showMondrian
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
      let viewController = MondrianViewController { [weak self] in self?.update($0) }
      push(viewController)
    }
  }

  private func update(_ action: TiledDrawingViewController.Action) {
    switch action {
    case .dismiss: pop()
    }
  }

  private func update(_ action: MondrianViewController.Action) {
    switch action {
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
