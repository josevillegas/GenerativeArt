import SwiftUI

struct MondrianView: UIViewRepresentable {
  let paths: [GAPath]

  func makeUIView(context: Context) -> MondrianCanvas {
    let view = MondrianCanvas()
    view.backgroundColor = .white
    view.paths = paths
    return view
  }

  func updateUIView(_ view: MondrianCanvas, context: Context) {
    view.paths = paths
  }
}

final class MondrianCanvas: UIView {
  var paths: [GAPath] = [] {
    didSet { setNeedsDisplay() }
  }

  override func draw(_ rect: CGRect) {
    paths.draw()
  }
}
