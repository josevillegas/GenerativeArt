import UIKit

final class TiledDrawingViewToolbarController: BarButtonItemProvider {
  enum Action {
    case dismiss
    case showBackgroundColors
    case showForegroundColors
    case showSizeSlider
    case toggleAnimation
    case updateVariations
  }

  var perform: (Action) -> Void = { _ in }

  private(set) var toolbarItems: [UIBarButtonItem] = []
  private let playButton = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)

  init() {
    toolbarItems = [
      barButtonItem(image: .backChevron, action: #selector(dismiss)),
      barButtonItem(title: "Front", action: #selector(showForegroundColors)),
      barButtonItem(title: "Back", action: #selector(showBackgroundColors)),
      barButtonItem(title: "Size", action: #selector(showSizeSlider)),
      playButton,
      barButtonItem(image: .goForward, action: #selector(updateVariations))
    ].addingFlexibleSpaces()

    playButton.image = playButtonImage(isPlaying: false)
    playButton.target = self
    playButton.action = #selector(toggleAnimation)
  }

  func updatePlayButton(isPlaying: Bool) {
    playButton.image = playButtonImage(isPlaying: isPlaying)
  }

  private func playButtonImage(isPlaying: Bool) -> UIImage {
    isPlaying ? .pause : .play
  }

  @objc private func dismiss() {
    perform(.dismiss)
  }

  @objc private func showBackgroundColors() {
    perform(.showBackgroundColors)
  }

  @objc private func showForegroundColors() {
    perform(.showForegroundColors)
  }

  @objc private func showSizeSlider() {
    perform(.showSizeSlider)
  }

  @objc private func toggleAnimation() {
    perform(.toggleAnimation)
  }

  @objc private func updateVariations() {
    perform(.updateVariations)
  }
}
