import SwiftUI

struct MondrianView: View {
  let drawing: MondrianDrawing

  var body: some View {
    MondrianViewRepresentable(drawing: drawing)
      .padding(24)
      .background(Color(white: 0.9), ignoresSafeAreaEdges: Edge.Set())
  }
}

struct MondrianViewRepresentable: UIViewRepresentable {
  let drawing: MondrianDrawing

  func makeUIView(context: Context) -> MondrianDrawingView {
    MondrianDrawingView(drawing: drawing)
  }

  func updateUIView(_ view: MondrianDrawingView, context: Context) {
    view.drawing = drawing
  }
}

final class MondrianDrawingView: UIView {
  var drawing: MondrianDrawing {
    didSet { setNeedsDisplay() }
  }

  init(drawing: MondrianDrawing) {
    self.drawing = drawing
    super.init(frame: .zero)

    backgroundColor = .white
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {
    drawing.paths(frame: bounds).draw()
  }

  override func layoutSubviews() {
    setNeedsDisplay()
  }
}
