import SwiftUI

@main
struct GenerativeArtApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}

struct ContentView: View {
  @Environment(\.horizontalSizeClass) var horizontalSizeClass

  private let app = Application()

  var body: some View {
    if horizontalSizeClass == .compact {
      CompactView(app: app)
    } else {
      NavigationSplitView {
        SidebarView(app: app)
      } detail: {
        DetailView(app: app)
      }
    }
  }
}

struct SidebarView: UIViewControllerRepresentable {
  let app: Application

  typealias UIViewControllerType = UIViewController

  func makeUIViewController(context: Context) -> UIViewController {
    app.indexViewController(appearance: .sidebar)
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct DetailView: UIViewControllerRepresentable {
  let app: Application

  typealias UIViewControllerType = UIViewController

  func makeUIViewController(context: Context) -> UIViewController {
    app.detailViewController
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct CompactView: UIViewControllerRepresentable {
  let app: Application

  typealias UIViewControllerType = UIViewController

  func makeUIViewController(context: Context) -> UIViewController {
    app.indexViewController(appearance: .insetGrouped)
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
