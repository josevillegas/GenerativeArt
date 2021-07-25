import UIKit

final class MondrianViewToolbarController: BarButtonItemProvider {
  enum Message {
    case dismiss
    case redraw
  }

  var send: (Message) -> Void = { _ in }
  private(set) var toolbarItems: [UIBarButtonItem] = []

  init(presentationMode: DrawingPresentationMode) {
    toolbarItems = [
      barButtonItem(image: .dismiss(with: presentationMode), action: #selector(dismiss)),
      barButtonItem(image: .goForward, action: #selector(redraw))
    ].addingFlexibleSpaces()
  }

  @objc private func dismiss() {
    send(.dismiss)
  }

  @objc private func redraw() {
    send(.redraw)
  }
}
