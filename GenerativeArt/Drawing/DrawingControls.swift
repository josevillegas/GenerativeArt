import Algorithms
import Combine
import UIKit

final class DrawingControls {
  enum Message {
    case dismiss
    case showBackgroundColors
    case showForegroundColors
    case showNext
    case showNextFromTimer
    case showSizeSlider
  }

  struct Options: OptionSet {
    let rawValue: Int

    static let colors = Options(rawValue: 1 << 0)
    static let size = Options(rawValue: 1 << 1)

    static let all: Options = [.colors, .size]
    static let none: Options = []
  }

  var send: (Message) -> Void = { _ in }

  private(set) var toolbarItems: [UIBarButtonItem] = []
  private let playButton = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
  private let timer = DrawingTimer()
  private var cancellables: [AnyCancellable] = []
  private var wasPlaying = false

  init(options: Options, presentationMode: DrawingPresentationMode) {
    toolbarItems = [
      barButtonItem(image: .dismiss(with: presentationMode), action: #selector(dismiss)),
      options.contains(.colors) ? barButtonItem(title: "Front", action: #selector(showForegroundColors)) : nil,
      options.contains(.colors) ? barButtonItem(title: "Back", action: #selector(showBackgroundColors)) : nil,
      options.contains(.size) ? barButtonItem(title: "Size", action: #selector(showSizeSlider)): nil,
      playButton,
      barButtonItem(image: .goForward, action: #selector(showNext))
    ]
      .compactMap { $0 }
      .addingFlexibleSpaces()

    playButton.image = playButtonImage(isPlaying: false)
    playButton.target = self
    playButton.action = #selector(toggleAnimation)

    timer.onFire
      .sink { [weak self] in self?.send(.showNextFromTimer) }
      .store(in: &cancellables)
    timer.$isPlaying
      .sink { [weak self] in self?.updatePlayButton(isPlaying: $0) }
      .store(in: &cancellables)
  }

  func viewDidAppear() {
    if wasPlaying {
      timer.start()
    }
  }

  func viewWillDisappear() {
    wasPlaying = timer.isPlaying
    timer.stop()
  }

  private func updatePlayButton(isPlaying: Bool) {
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
    timer.isPlaying.toggle()
  }

  @objc private func showNext() {
    send(.showNext)
  }

  private func barButtonItem(title: String, action: Selector) -> UIBarButtonItem {
    UIBarButtonItem(title: title, style: .plain, target: self, action: action)
  }

  private func barButtonItem(image: UIImage, action: Selector) -> UIBarButtonItem {
    UIBarButtonItem(image: image, style: .plain, target: self, action: action)
  }
}

extension Array where Element == UIBarButtonItem {
  func addingFlexibleSpaces() -> [UIBarButtonItem] {
    Array(self.interspersed(with: .flexibleSpace()))
  }
}
