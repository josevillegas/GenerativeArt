import UIKit

final class TiledDrawingViewToolbarController: BarButtonItemProvider {
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
      barButtonItem(image: .backChevron, action: #selector(dismiss)),
      barButtonItem(title: "Front", action: #selector(showForegroundColors)),
      barButtonItem(title: "Back", action: #selector(showBackgroundColors)),
      barButtonItem(title: "Size", action: #selector(showSizeSlider)),
      barButtonItem(image: .goForward, action: #selector(updateVariations))
    ].addingFlexibleSpaces()
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
