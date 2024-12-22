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
  var body: some View {
    ViewControllerView()
  }
}

struct ViewControllerView: UIViewControllerRepresentable {
  private let app = Application()

  typealias UIViewControllerType = UIViewController

  func makeUIViewController(context: Context) -> UIViewController {
    app.rootViewController
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
