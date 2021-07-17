import UIKit

final class MondrianViewToolbarController: BarButtonItemProvider {
  enum Action {
    case dismiss
    case redraw
  }

  var perform: (Action) -> Void = { _ in }
  private(set) var toolbarItems: [UIBarButtonItem] = []

  init() {
    toolbarItems = [
      barButtonItem(image: .backChevron, action: #selector(dismiss)),
      barButtonItem(image: .goForward, action: #selector(redraw))
    ].addingFlexibleSpaces()
  }

  @objc private func dismiss() {
    perform(.dismiss)
  }

  @objc private func redraw() {
    perform(.redraw)
  }
}
