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
      .flexibleSpace,
      UIBarButtonItem(title: "Front", style: .plain, target: self, action: #selector(showForegroundColors)),
      .flexibleSpace,
      UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(showBackgroundColors)),
      .flexibleSpace,
      UIBarButtonItem(title: "Size", style: .plain, target: self, action: #selector(showSizeSlider)),
      .flexibleSpace,
      UIBarButtonItem(image: .goForward, style: .plain, target: self, action: #selector(updateVariations))
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
