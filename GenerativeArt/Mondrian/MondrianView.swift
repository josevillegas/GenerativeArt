import SwiftUI

struct MondrianView: UIViewRepresentable {
  let drawing: MondrianDrawing

  func makeUIView(context: Context) -> MondrianCanvas {
    let view = MondrianCanvas()
    view.drawing = drawing
    view.backgroundColor = .white
    return view
  }

  func updateUIView(_ view: MondrianCanvas, context: Context) {
    view.drawing = drawing
  }
}

final class MondrianCanvas: UIView {
  var drawing: MondrianDrawing? {
    didSet { setNeedsDisplay() }
  }

  override func draw(_ rect: CGRect) {
    drawing?.paths(frame: bounds).draw()
  }
}
