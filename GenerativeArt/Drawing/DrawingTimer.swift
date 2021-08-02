import Foundation
import Combine

final class DrawingTimer {
  let onFire: AnyPublisher<Void, Never>

  @Published var isPlaying = false {
    didSet {
      guard isPlaying != oldValue else { return }

      if isPlaying {
        cancellable = Timer.publish(every: 0.8, on: .main, in: .default)
          .autoconnect()
          .sink { [weak self] _ in self?.onFireSubject.send() }
      } else {
        cancellable = nil
      }
    }
  }

  private let onFireSubject = PassthroughSubject<Void, Never>()
  private var cancellable: AnyCancellable?

  init() {
    onFire = onFireSubject.eraseToAnyPublisher()
  }

  func start() {
    isPlaying = true
  }

  func stop() {
    isPlaying = false
  }
}
