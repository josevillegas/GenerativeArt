import SwiftUI

enum Message {
  case dismissDrawing
  case showDrawing(DrawingType)
}

struct ContentView: View {
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @State private var lastSelectedDrawingType: DrawingType = .tile(.diagonals)
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
      SidebarView(sections: sections, selectedDrawingType: $selectedDrawingType)
    } else {
      NavigationSplitView {
        SidebarView(sections: sections, selectedDrawingType: $selectedDrawingType)
      } detail: {
        DetailView(drawingType: lastSelectedDrawingType, send: send)
      }
    }
  }

  private func send(_ message: Message) {
    switch message {
    case .dismissDrawing:
      dismissDrawing()
    case let .showDrawing(type):
      lastSelectedDrawingType = type
      showDrawing(type)
    }
  }

  private func showDrawing(_ type: DrawingType) {
//    splitViewController.preferredDisplayMode = .automatic
//    if splitViewController.isCollapsed {
//      compactNavigationController.pushViewController(viewController(for: type, presentationMode: .pushed), animated: true)
//    } else {
//      secondaryNavigationController.viewControllers = [viewController(for: type, presentationMode: .secondary)]
//      splitViewController.show(.secondary)
//    }
  }

  private func dismissDrawing() {
//    if splitViewController.isCollapsed {
//      compactNavigationController.popViewController(animated: true)
//    } else {
//      splitViewController.show(.primary)
//    }
  }
}
