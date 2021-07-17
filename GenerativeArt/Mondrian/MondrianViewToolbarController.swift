import UIKit

final class MondrianViewToolbarController {
  enum Action {
    case dismiss
    case redraw
  }

  var perform: (Action) -> Void = { _ in }
  private(set) var toolbarItems: [UIBarButtonItem] = []

  init() {
    toolbarItems = [
      UIBarButtonItem(image: .backChevron, style: .plain, target: self, action: #selector(dismiss)),
      .flexibleSpace,
      UIBarButtonItem(image: .goForward, style: .plain, target: self, action: #selector(redraw))
    ]
  }

  @objc private func dismiss() {
    perform(.dismiss)
  }

  @objc private func redraw() {
    perform(.redraw)
  }
}
