import Foundation
import Combine

final class DrawingTimer {
  var send: () -> Void = {}

  @Published private(set) var isPlaying = false

  private var cancellable: AnyCancellable?

  func start() {
    guard !isPlaying else { return }
    isPlaying = true

    cancellable = Timer.publish(every: 0.8, on: .main, in: .default)
      .autoconnect()
      .sink { [weak self] _ in self?.send() }
  }

  func stop() {
    guard isPlaying else { return }
    isPlaying = false

    cancellable = nil
  }

  func togglePlay() {
    if isPlaying {
      stop()
    } else {
      start()
    }
  }
}
