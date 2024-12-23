import Algorithms
import Combine
import UIKit

final class DrawingControls {
  private var toolbarItems: [UIBarButtonItem] = []
  private let playButton = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
  private let timer = DrawingTimer()
  private var cancellables: [AnyCancellable] = []
  private var wasPlaying = false

  init(presentationMode: DrawingPresentationMode) {
    toolbarItems = [
      UIBarButtonItem(image: Self.dismissImage(with: presentationMode), style: .plain, target: self, action: #selector(noop)),
      playButton
    ]
    .compactMap { $0 }

    playButton.image = playButtonImage(isPlaying: false)
    playButton.target = self
    playButton.action = #selector(toggleAnimation)

    timer.onFire
      .sink { } // Show next from timer.
      .store(in: &cancellables)
    timer.$isPlaying
      .sink { [weak self] in self?.updatePlayButton(isPlaying: $0) }
      .store(in: &cancellables)
  }

  static func dismissImage(with presentationMode: DrawingPresentationMode) -> UIImage {
    switch presentationMode {
    case .pushed: .backChevron
    case .secondary: .sidebar
    }
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

  @objc private func noop() {}

  @objc private func toggleAnimation() {
    timer.isPlaying.toggle()
  }
}

extension UIImage {
  static var backChevron: UIImage { image(withName: "chevron.backward") }
  static var pause: UIImage { image(withName: "pause") }
  static var play: UIImage { image(withName: "play") }
  static var sidebar: UIImage { image(withName: "sidebar.leading") }

  private static func image(withName name: String) -> UIImage {
    UIImage(systemName: name) ?? UIImage()
  }
}
