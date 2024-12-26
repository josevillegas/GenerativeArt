import SwiftUI

struct TiledDrawingView: UIViewRepresentable {
  let paths: [GAPath]

  func makeUIView(context: Context) -> TiledDrawingCanvas {
    let view = TiledDrawingCanvas()
    view.backgroundColor = .white
    view.paths = paths
    return view
  }

  func updateUIView(_ view: TiledDrawingCanvas, context: Context) {
    view.paths = paths
  }
}

final class TiledDrawingCanvas: UIView {
  var paths: [GAPath] = [] {
    didSet { setNeedsDisplay() }
  }

  override func draw(_: CGRect) {
    paths.draw()
  }
}
