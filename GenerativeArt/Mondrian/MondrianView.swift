import SwiftUI

final class MondrianView: UIView {
  var drawing: MondrianDrawing {
    get { drawingView.drawing }
    set { drawingView.drawing = newValue }
  }

  private let drawingView: MondrianDrawingView

  init(drawing: MondrianDrawing) {
    drawingView = MondrianDrawingView(drawing: drawing)
    super.init(frame: .zero)

    backgroundColor = UIColor(white: 0.9, alpha: 1)

    addSubview(drawingView)
    drawingView.translatesAutoresizingMaskIntoConstraints = false
    let margin: CGFloat = 24
    NSLayoutConstraint.activate([
      drawingView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: margin),
      drawingView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -margin),
      drawingView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: margin),
      drawingView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -margin)
    ])

    drawingView.drawing = drawing
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
