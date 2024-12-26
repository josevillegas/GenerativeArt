import SwiftUI

struct TiledDrawingViewRepresentable: UIViewRepresentable {
  let type: TiledDrawingTypeWrapper
  let tiles: Tiles
  let foregroundColor: Color
  let backgroundColor: Color

  func makeUIView(context: Context) -> TiledDrawingUIView {
    let tiledDrawing = TiledDrawing(type: type.type, tiles: tiles)
    return TiledDrawingUIView(tiledDrawing: tiledDrawing)
  }

  func updateUIView(_ view: TiledDrawingUIView, context: Context) {
    view.panelView.tiledDrawing.tiles = tiles
    view.panelView.tiledDrawing.foregroundColor = foregroundColor
    view.panelView.tiledDrawing.backgroundColor = backgroundColor
    view.panelView.tiledDrawing.type = type.type
    view.panelView.tiledDrawing.updateVariations()
    view.panelView.setNeedsDisplay()

    let panelSize = view.panelView.tiledDrawing.tiles.size
    view.panelWidthConstraint.constant = panelSize.width
    view.panelHeightConstraint.constant = panelSize.height
  }
}

final class TiledDrawingUIView: UIView {
  let panelView: DrawingPanelView
  let panelWidthConstraint: NSLayoutConstraint
  let panelHeightConstraint: NSLayoutConstraint

  init(tiledDrawing: TiledDrawing) {
    panelView = DrawingPanelView(tiledDrawing: tiledDrawing)
    panelWidthConstraint = panelView.widthAnchor.constraint(equalToConstant: 0)
    panelHeightConstraint = panelView.heightAnchor.constraint(equalToConstant: 0)
    super.init(frame: .zero)

    panelView.backgroundColor = .white

    panelWidthConstraint.isActive = true
    panelHeightConstraint.isActive = true

    addSubview(panelView)
    panelView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      panelView.centerXAnchor.constraint(equalTo: centerXAnchor),
      panelView.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

final class DrawingPanelView: UIView {
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
