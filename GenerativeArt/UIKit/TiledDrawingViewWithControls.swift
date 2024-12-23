import SwiftUI

final class TiledDrawingViewWithControls: UIView {
  private let boundsView: TiledDrawingView
  private var tileSizeControl: TileSizeControl = .empty

  init(type: TiledDrawingType) {
    boundsView = TiledDrawingView(type: type)
    super.init(frame: .zero)

    addSubview(boundsView)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateVariations() {
//    boundsView.panelView.tiledDrawing.updateVariations()
//    boundsView.panelView.setNeedsDisplay()
  }

  func updateRandomTiles(count: Int) {
//    guard count > 0 else { return }
//    for _ in 1...count { boundsView.panelView.tiledDrawing.updateRandomTile() }
//    boundsView.panelView.setNeedsDisplay()
  }

  private func update() { // (_ message: UISizeControl.Message) {
//    switch message {
//    case .valueDidChange:
//      let initialTileSize = boundsView.panelView.tiledDrawing.tileSize
//      boundsView.panelView.tiledDrawing.unitSize = tileSizeControl.widthForValue(value)
//      guard initialTileSize != boundsView.panelView.tiledDrawing.tileSize else { return }
      boundsView.updatePanelSize()
      updateVariations()
//    }
  }

  private func update(_ message: TiledDrawingView.Message) {
    switch message {
    case let .sizeDidChange(size): tileSizeControl = TileSizeControl(boundsSize: size, minWidth: 20)
    }
  }
}
