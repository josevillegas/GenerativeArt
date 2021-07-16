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
      UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismiss)),
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(redraw))
    ]
  }

  @objc private func dismiss() {
    perform(.dismiss)
  }

  @objc private func redraw() {
    perform(.redraw)
  }
}
