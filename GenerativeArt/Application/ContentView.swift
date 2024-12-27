import SwiftUI
import Combine

struct ContentView: View {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @State private var selectedDrawingType: DrawingType? = .defaultType
  @State private var drawingID = UUID()
  @State private var foregroundColor: Color = .red
  @State private var backgroundColor: Color = .white
  @State private var tileSize: CGFloat = 0.5 // A value from zero to one.
  @State private var splitViewVisibility: NavigationSplitViewVisibility = .all
  @State private var isPlaying: Bool = false
  @State private var timer = Timer.publish(every: 1, on: .main, in: .common)
  @State private var timerCancellable: (any Cancellable)?

  private let timerDuration: TimeInterval = 1.5

  var body: some View {
    DrawingNavigationView(drawingID: drawingID, selectedDrawingType: $selectedDrawingType, splitViewVisibility: $splitViewVisibility,
                          foregroundColor: $foregroundColor, backgroundColor: $backgroundColor, tileSize: $tileSize, isPlaying: $isPlaying,
                          perform: update)
    .onChange(of: selectedDrawingType) { _, _ in isPlaying = false }
    .onReceive(timer) { _ in next() }
    .onDisappear { timerCancellable?.cancel() }
    .onChange(of: isPlaying) { _, _ in updateForIsPlaying() }
  }

  private func update(action: ToolbarAction) {
    switch action {
    case .next: next()
    case .toggleSidebar: toggleSidebar()
    }
  }

  private func next() {
    drawingID = UUID()
  }

  private func toggleSidebar() {
    if horizontalSizeClass == .compact {
      selectedDrawingType = nil
      return
    }
    switch splitViewVisibility {
    case .all: splitViewVisibility = .detailOnly
    case .detailOnly: splitViewVisibility = .all
    default: break
    }
  }

  private func updateForIsPlaying() {
    timerCancellable?.cancel()
    timerCancellable = nil
    if isPlaying {
      timer = Timer.publish(every: timerDuration, on: .main, in: .common)
      timerCancellable = timer.connect()
    }
  }
}

struct NavigationBarModifier: ViewModifier {
  func body(content: Content) -> some View {
    if #available(iOS 18, *) {
      content
        .toolbarVisibility(.hidden, for: .navigationBar)
    } else {
      content
        .navigationBarHidden(true)
    }
  }
}
