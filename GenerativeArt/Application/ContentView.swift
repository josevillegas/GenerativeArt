import SwiftUI

enum Message {
  case dismissDrawing
  case showDrawing(DrawingType)
}

struct ContentView: View {
  @Environment(\.horizontalSizeClass) var horizontalSizeClass

  @State private var lastSelectedDrawingType: DrawingType = .tile(.diagonals)

  private let app = Application()
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
      CompactView(sections: sections, send: send)
    } else {
      NavigationSplitView {
        SidebarView(sections: sections, send: send)
      } detail: {
        DetailView(drawingType: lastSelectedDrawingType, app: app, send: send)
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

struct SidebarView: UIViewControllerRepresentable {
  let sections: [IndexSection]
  let send: (Message) -> Void

  typealias UIViewControllerType = UIViewController

  func makeUIViewController(context: Context) -> UIViewController {
    IndexViewController(sections: sections, appearance: .sidebar, send: send)
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct DetailView: UIViewControllerRepresentable {
  let drawingType: DrawingType
  let app: Application
  let send: (Message) -> Void

  typealias UIViewControllerType = UIViewController

  func makeUIViewController(context: Context) -> UIViewController {
    app.viewController(for: drawingType, presentationMode: .secondary, send: send)
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct CompactView: UIViewControllerRepresentable {
  let sections: [IndexSection]
  let send: (Message) -> Void

  typealias UIViewControllerType = UIViewController

  func makeUIViewController(context: Context) -> UIViewController {
    IndexViewController(sections: sections, appearance: .insetGrouped, send: send)
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
