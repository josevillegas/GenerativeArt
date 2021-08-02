import UIKit

final class TiledDrawingViewToolbarController: BarButtonItemProvider {
  struct Options: OptionSet {
    let rawValue: Int

    static let colors = Options(rawValue: 1 << 0)
    static let all: Options = [.colors]
  }

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

  init(options: Options, presentationMode: DrawingPresentationMode) {
    toolbarItems = [
      barButtonItem(image: .dismiss(with: presentationMode), action: #selector(dismiss)),
      options.contains(.colors) ? barButtonItem(title: "Front", action: #selector(showForegroundColors)) : nil,
      options.contains(.colors) ? barButtonItem(title: "Back", action: #selector(showBackgroundColors)) : nil,
      barButtonItem(title: "Size", action: #selector(showSizeSlider)),
      playButton,
      barButtonItem(image: .goForward, action: #selector(updateVariations))
    ]
      .compactMap { $0 }
      .addingFlexibleSpaces()

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
