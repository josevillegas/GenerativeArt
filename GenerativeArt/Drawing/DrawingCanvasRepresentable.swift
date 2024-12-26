import SwiftUI

struct DrawingCanvasRepresentable: UIViewRepresentable {
  let paths: [GAPath]

  func makeUIView(context: Context) -> DrawingCanvas {
    let view = DrawingCanvas()
    view.backgroundColor = .white
    view.paths = paths
    return view
  }

  func updateUIView(_ view: DrawingCanvas, context: Context) {
    view.paths = paths
  }
}

final class DrawingCanvas: UIView {
  var paths: [GAPath] = [] {
    didSet { setNeedsDisplay() }
  }

  override func draw(_: CGRect) {
    paths.draw()
  }
}
