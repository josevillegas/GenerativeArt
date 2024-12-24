import SwiftUI

struct DrawingView: View {
  let drawingType: DrawingType
  @Binding var splitViewVisibility: NavigationSplitViewVisibility

  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @Environment(\.dismiss) private var dismiss
  @State var tiledDrawingType = TiledDrawingTypeWrapper(type: .triangles)
  @State var mondrianDrawing = MondrianDrawing()
  @State var foregroundColor: Color = .red
  @State var backgroundColor: Color = .white
  @State var tileSize: CGFloat = 0.5 // A value from zero to one.

  var body: some View {
    Group {
      switch drawingType {
      case .paintingStyle(.mondrian):
        MondrianViewRepresentable(drawing: mondrianDrawing)
          .modifier(PaintingToolbarModifier(dismissImageName: dismissImageName, toggleSidebar: toggleSidebar, next: next))
      case .tile:
        TiledDrawingViewRepresentable(type: tiledDrawingType, foregroundColor: foregroundColor, backgroundColor: backgroundColor)
          .modifier(ToolbarModifier(foregroundColor: $foregroundColor, backgroundColor: $backgroundColor, tileSize: $tileSize,
                                    dismissImageName: dismissImageName, toggleSidebar: toggleSidebar, next: next))
      }
    }
    .onChange(of: drawingType) { _, _ in
      switch drawingType {
      case let .tile(type): tiledDrawingType = TiledDrawingTypeWrapper(type: type)
      case .paintingStyle(.mondrian): mondrianDrawing = MondrianDrawing()
      }
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

  private var dismissImageName: String {
    horizontalSizeClass == .compact ?  "chevron.backward" : "sidebar.leading"
  }
}

struct TiledDrawingViewRepresentable: UIViewRepresentable {
  let type: TiledDrawingTypeWrapper
  let foregroundColor: Color
  let backgroundColor: Color

  func makeUIView(context: Context) -> TiledDrawingView {
    TiledDrawingView(type: type.type)
  }

  func updateUIView(_ view: TiledDrawingView, context: Context) {
    view.panelView.drawingForegroundColor = foregroundColor
    view.panelView.drawingBackgroundColor = backgroundColor
    view.panelView.type = type.type
  }
}

struct MondrianViewRepresentable: UIViewRepresentable {
  let drawing: MondrianDrawing

  func makeUIView(context: Context) -> MondrianView {
    MondrianView(drawing: drawing)
  }

  func updateUIView(_ view: MondrianView, context: Context) {
    view.drawing = drawing
  }
}

// This is needed so that the UIViewRepresentable registers changes.
struct TiledDrawingTypeWrapper: Equatable {
  let id = UUID()
  let type: TiledDrawingType
}
