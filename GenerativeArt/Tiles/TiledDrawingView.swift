import SwiftUI

struct TiledDrawingView: UIViewRepresentable {
  let type: TiledDrawingTypeWrapper
  let tiles: Tiles
  let foregroundColor: Color
  let backgroundColor: Color

  func makeUIView(context: Context) -> TiledDrawingUIView {
    TiledDrawingUIView(tiledDrawing: TiledDrawing(type: type.type, tiles: tiles))
  }

  func updateUIView(_ view: TiledDrawingUIView, context: Context) {
    view.canvas.tiledDrawing.tiles = tiles
    view.canvas.tiledDrawing.foregroundColor = foregroundColor
    view.canvas.tiledDrawing.backgroundColor = backgroundColor
    view.canvas.tiledDrawing.type = type.type
    view.canvas.tiledDrawing.updateVariations()
    view.canvas.setNeedsDisplay()

    let panelSize = view.canvas.tiledDrawing.tiles.size
    view.panelWidthConstraint.constant = panelSize.width
    view.panelHeightConstraint.constant = panelSize.height
  }
}

final class TiledDrawingUIView: UIView {
  let canvas: TiledDrawingCanvas
  let panelWidthConstraint: NSLayoutConstraint
  let panelHeightConstraint: NSLayoutConstraint

  init(tiledDrawing: TiledDrawing) {
    canvas = TiledDrawingCanvas(tiledDrawing: tiledDrawing)
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
  var tiledDrawing: TiledDrawing

  init(tiledDrawing: TiledDrawing) {
    self.tiledDrawing = tiledDrawing
    super.init(frame: .zero)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_: CGRect) {
    tiledDrawing.paths.draw()
  }
}
