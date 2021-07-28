import Foundation
import Combine

final class DrawingTimer {
  var send: () -> Void = {}

  @Published var isPlaying = false {
    didSet {
      guard isPlaying != oldValue else { return }
      if isPlaying {
        cancellable = Timer.publish(every: 0.8, on: .main, in: .default)
          .autoconnect()
          .sink { [weak self] _ in self?.send() }
      } else {
        cancellable = nil
      }
    }
  }

  private var cancellable: AnyCancellable?

  func start() {
    isPlaying = true
  }

  func stop() {
    isPlaying = false
  }
}
