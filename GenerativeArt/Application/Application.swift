import UIKit

enum Message {
  case showDrawing(DrawingType)
}

enum DrawingMessage {
  case dismiss
}

protocol Configuration {
  var sections: [Index.Section] { get }
}

final class Application {
  var rootViewController: UIViewController {
    navigationController
  }

  private lazy var navigationController: UINavigationController = {
    MainNavigationController(
      rootViewController: IndexViewController(index: Index(sections: configuration.sections)) { [weak self] in self?.update($0) }
    )
  }()

  private let configuration: Configuration

  init(configuration: Configuration) {
    self.configuration = configuration
  }

  private func update(_ message: Message) {
    switch message {
    case let .showDrawing(type):
      switch type {
      case .paintingStyle(.mondrian):
        push(MondrianViewController { [weak self] in self?.update($0) })
      case let .tile(type):
        let viewModel = TiledDrawingViewModel(
          variation: type,
          tileForegroundColor: type.defaultForegroundColor,
          tileBackgroundColor: type.defaultBackgroundColor
        )
        let viewController = TiledDrawingViewController(viewModel: viewModel) { [weak self] in
          self?.update($0)
        }
        push(viewController)
      }
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
