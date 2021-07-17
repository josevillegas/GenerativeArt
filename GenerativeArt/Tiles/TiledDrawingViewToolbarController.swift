import UIKit

final class TiledDrawingViewToolbarController: BarButtonItemProvider {
  enum Message {
    case dismiss
    case showBackgroundColors
    case showForegroundColors
    case showSizeSlider
    case toggleAnimation
    case updateVariations
  }

  var send: (Message) -> Void = { _ in }

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
    send(.dismiss)
  }

  @objc private func showBackgroundColors() {
    send(.showBackgroundColors)
  }

  @objc private func showForegroundColors() {
    send(.showForegroundColors)
  }

  @objc private func showSizeSlider() {
    send(.showSizeSlider)
  }

  @objc private func toggleAnimation() {
    send(.toggleAnimation)
  }

  @objc private func updateVariations() {
    send(.updateVariations)
  }
}
