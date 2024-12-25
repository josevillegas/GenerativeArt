import SwiftUI
import Combine

struct DrawingView: View {
  let drawingType: DrawingType
  @Binding var splitViewVisibility: NavigationSplitViewVisibility

  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @Environment(\.dismiss) private var dismiss
  @State private var tiledDrawingType = TiledDrawingTypeWrapper(type: .triangles)
  @State private var mondrianDrawing = MondrianDrawing()
  @State private var foregroundColor: Color = .red
  @State private var backgroundColor: Color = .white
  @State private var tileSizeControl: TileSizeControl = .empty
  @State private var unitSize: CGFloat = 30
  @State private var tileSize: CGFloat = 0.5 // A value from zero to one.
  @State private var isPlaying: Bool = false
  @State private var timer = Timer.publish(every: 1, on: .main, in: .common)
  @State private var timerCancellable: (any Cancellable)?

  private let timerDuration: TimeInterval = 2

  var body: some View {
    Group {
      switch drawingType {
      case .paintingStyle(.mondrian): MondrianView(drawing: mondrianDrawing)
      case .tile:
        TiledDrawingViewRepresentable(type: tiledDrawingType, foregroundColor: foregroundColor, backgroundColor: backgroundColor,
                                      unitSize: unitSize, perform: update)
      }
    }
    .modifier(ToolbarModifier(type: drawingType, foregroundColor: foregroundColor, backgroundColor: backgroundColor, tileSize: tileSize,
                              dismissImageName: dismissImageName, playImageName: playImageName, perform: update))
    .onChange(of: drawingType) { _, _ in updateForDrawingType() }
    .onReceive(timer) { _ in updateForDrawingType() }
    .onDisappear { timerCancellable?.cancel() }
  }

  private func updateForDrawingType() {
    switch drawingType {
    case let .tile(type): tiledDrawingType = TiledDrawingTypeWrapper(type: type)
    case .paintingStyle(.mondrian): mondrianDrawing = MondrianDrawing()
    }
  }

  private func update(action: TiledDrawingView.Action) {
    switch action {
    case let .sizeDidChange(size):
      tileSizeControl = TileSizeControl(boundsSize: size, minWidth: 20)
      unitSize = tileSizeControl.widthForValue(tileSize)
    }
  }

  private func update(action: ToolbarAction) {
    switch action {
    case .next: next()
    case let .setBackgroundColor(color): backgroundColor = color
    case let .setForegroundColor(color): foregroundColor = color
    case let .setTileSize(size):
      tileSize = size
      unitSize = tileSizeControl.widthForValue(size)
    case .togglePlaying: togglePlaying()
    case .toggleSidebarOrDismiss: toggleSidebar()
    }
  }

  private func toggleSidebar() {
    if horizontalSizeClass == .compact {
      dismiss()
      return
    }
    switch splitViewVisibility {
    case .all: splitViewVisibility = .detailOnly
    case .detailOnly: splitViewVisibility = .all
    default: break
    }
  }

  private func next() {
    switch drawingType {
    case let .tile(type): tiledDrawingType = TiledDrawingTypeWrapper(type: type)
    case .paintingStyle(.mondrian): mondrianDrawing = MondrianDrawing()
    }
  }

  private func togglePlaying() {
    isPlaying.toggle()

    timerCancellable?.cancel()
    if isPlaying {
      timer = Timer.publish(every: timerDuration, on: .main, in: .common)
      timerCancellable = timer.connect()
    }
  }

  private var dismissImageName: String {
    horizontalSizeClass == .compact ?  "chevron.backward" : "sidebar.leading"
  }

  private var playImageName: String {
    isPlaying ? "pause" : "play"
  }
}

struct TiledDrawingViewRepresentable: UIViewRepresentable {
  let type: TiledDrawingTypeWrapper
  let foregroundColor: Color
  let backgroundColor: Color
  let unitSize: CGFloat
  let perform: (TiledDrawingView.Action) -> Void

  func makeUIView(context: Context) -> TiledDrawingView {
    TiledDrawingView(type: type.type, perform: perform)
  }

  func updateUIView(_ view: TiledDrawingView, context: Context) {
    view.drawingForegroundColor = foregroundColor
    view.drawingBackgroundColor = backgroundColor
    view.unitSize = unitSize
    view.type = type.type
  }
}

// This is needed so that the UIViewRepresentable registers changes.
struct TiledDrawingTypeWrapper: Equatable {
  let id = UUID()
  let type: TiledDrawingType
}
