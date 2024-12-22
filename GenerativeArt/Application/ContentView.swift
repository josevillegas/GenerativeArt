import SwiftUI

enum Message {
  case dismissDrawing
  case showDrawing(DrawingType)
}

struct ContentView: View {
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @State private var selectedDrawingType: DrawingType?

  private let sections = [
    IndexSection(title: "Lines", rows: [
      .tile(.diagonals),
      .tile(.scribbles)
    ]),
    IndexSection(title: "Shapes", rows: [
      .tile(.triangles),
      .tile(.quadrants),
      .tile(.trianglesAndQuadrants),
      .tile(.concentricShapes)
    ]),
    IndexSection(title: "Painting Styles", rows: [
      .paintingStyle(.mondrian)
    ])
  ]

  var body: some View {
    if horizontalSizeClass == .compact {
      NavigationStack {
        SidebarView(sections: sections, selectedDrawingType: $selectedDrawingType)
          .navigationDestination(item: $selectedDrawingType) { drawingType in
            GeneralDrawingView(drawingType: drawingType, send: send)
          }
      }
    } else {
      NavigationSplitView {
        SidebarView(sections: sections, selectedDrawingType: $selectedDrawingType)
      } detail: {
        if let selectedDrawingType {
          GeneralDrawingView(drawingType: selectedDrawingType, send: send)
        } else {
          Text("Select an item")
        }
      }
    }
  }

  private func send(_ message: Message) {}
}

struct GeneralDrawingView: View {
  let drawingType: DrawingType
  let send: (Message) -> Void

  var body: some View {
    switch drawingType {
    case .paintingStyle(.mondrian):
      MondrianViewRepresentable(send: send)
    case let .tile(type):
      TiledDrawingViewRepresentable(type: type, send: send)
    }
  }
}
