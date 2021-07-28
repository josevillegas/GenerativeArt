import Foundation
import Combine

final class DrawingTimer {
  enum Message {
    case started
    case stopped
    case timerFired
  }

  var send: (Message) -> Void = { _ in }

  private(set) var isPlaying = false

  private var cancellable: AnyCancellable?

  func start() {
    guard !isPlaying else { return }
    isPlaying = true

    cancellable = Timer.publish(every: 0.8, on: .main, in: .default)
      .autoconnect()
      .sink { [weak self] _ in self?.send(.timerFired) }
    send(.started)
  }

  func stop() {
    guard isPlaying else { return }
    isPlaying = false

    cancellable?.cancel()
    send(.stopped)
  }

  func togglePlay() {
    if isPlaying {
      stop()
    } else {
      start()
    }
  }
}
