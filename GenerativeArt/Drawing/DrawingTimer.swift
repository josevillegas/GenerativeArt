import Foundation

final class DrawingTimer {
  enum Message {
    case started
    case stopped
    case timerFired
  }

  var send: (Message) -> Void = { _ in }

  private(set) var isPlaying = false
  private var timer: Timer?

  deinit {
    timer?.invalidate()
  }

  func start() {
    guard !isPlaying else { return }
    isPlaying = true
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { [weak self] _ in
      self?.send(.timerFired)
    }
    send(.started)
  }

  func stop() {
    guard isPlaying else { return }
    isPlaying = false
    timer?.invalidate()
    timer = nil
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
