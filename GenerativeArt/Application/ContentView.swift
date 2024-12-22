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
            DrawingView(drawingType: drawingType)
          }
      }
    } else {
      NavigationSplitView {
        SidebarView(sections: sections, selectedDrawingType: $selectedDrawingType)
      } detail: {
        if let selectedDrawingType {
          DrawingView(drawingType: selectedDrawingType)
        } else {
          Text("Select an item")
        }
      }
    }
  }

  private func send(_ message: Message) {}
}
