import UIKit

final class TiledDrawingViewToolbarController {
  enum Action {
    case dismiss
    case updateVariations
    case showForegroundColors
    case showBackgroundColors
    case showSizeSlider
  }

  var perform: (Action) -> Void = { _ in }
  private(set) var toolbarItems: [UIBarButtonItem] = []

  init() {
    toolbarItems = [
      UIBarButtonItem(image: .backChevron, style: .plain, target: self, action: #selector(dismiss)),
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(updateVariations)),
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      UIBarButtonItem(title: "Front", style: .plain, target: self, action: #selector(showForegroundColors)),
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(showBackgroundColors)),
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      UIBarButtonItem(title: "Size", style: .plain, target: self, action: #selector(showSizeSlider))
    ]
  }

  @objc private func dismiss() {
    perform(.dismiss)
  }

  @objc private func updateVariations() {
    perform(.updateVariations)
  }

  @objc private func showForegroundColors() {
    perform(.showForegroundColors)
  }

  @objc private func showBackgroundColors() {
    perform(.showBackgroundColors)
  }

  @objc private func showSizeSlider() {
    perform(.showSizeSlider)
  }
}
