import SwiftUI

struct TiledDrawingView: UIViewRepresentable {
  let type: TiledDrawingTypeWrapper
  let tiles: Tiles
  let foregroundColor: Color
  let backgroundColor: Color

  func makeUIView(context: Context) -> TiledDrawingUIView {
    let view = TiledDrawingUIView()
    view.canvas.tiledDrawing = TiledDrawing(type: type.type, tiles: tiles)
    return view
  }

  func updateUIView(_ view: TiledDrawingUIView, context: Context) {
    guard var tiledDrawing = view.canvas.tiledDrawing else { return }

    tiledDrawing.tiles = tiles
    tiledDrawing.foregroundColor = foregroundColor
    tiledDrawing.backgroundColor = backgroundColor
    tiledDrawing.type = type.type
    tiledDrawing.updateVariations()
    view.canvas.tiledDrawing = tiledDrawing

    let panelSize = tiledDrawing.tiles.size
    view.panelWidthConstraint.constant = panelSize.width
    view.panelHeightConstraint.constant = panelSize.height

    view.canvas.setNeedsDisplay()
  }
}

final class TiledDrawingUIView: UIView {
  let canvas = TiledDrawingCanvas()
  let panelWidthConstraint: NSLayoutConstraint
  let panelHeightConstraint: NSLayoutConstraint

  init() {
    panelWidthConstraint = canvas.widthAnchor.constraint(equalToConstant: 0)
    panelHeightConstraint = canvas.heightAnchor.constraint(equalToConstant: 0)
    super.init(frame: .zero)

    canvas.backgroundColor = .white

    panelWidthConstraint.isActive = true
    panelHeightConstraint.isActive = true

    addSubview(canvas)
    canvas.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      canvas.centerXAnchor.constraint(equalTo: centerXAnchor),
      canvas.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

final class TiledDrawingCanvas: UIView {
  var tiledDrawing: TiledDrawing?

  override func draw(_: CGRect) {
    tiledDrawing?.paths.draw()
  }
}
