import SwiftUI

struct TiledDrawingView: View {
  let type: TiledDrawingTypeWrapper
  let foregroundColor: Color
  let backgroundColor: Color
  let tileSize: CGFloat
  let viewSize: CGSize

  @State private var tileSizeControl: TileSizeControl = .empty
  @State private var unitSize: CGFloat = 30

  private let scale = UIScreen.main.scale

  var body: some View {
    GeometryReader { proxy in
      TiledDrawingViewRepresentable(type: type, tiles: tiles, foregroundColor: foregroundColor, backgroundColor: backgroundColor,
                                    unitSize: unitSize, viewSize: viewSize)
    }
    .onChange(of: tileSize) { _, newValue in unitSize = tileSizeControl.widthForValue(newValue) }
    .onChange(of: viewSize) { _, _ in
      tileSizeControl = TileSizeControl(boundsSize: viewSize, minWidth: 20)
      unitSize = tileSizeControl.widthForValue(tileSize)
    }
  }

  private var tiles: Tiles {
    Tiles(maxSize: viewSize, maxTileSize: unitSize, scale: scale)
  }
}

struct TiledDrawingViewRepresentable: UIViewRepresentable {
  let type: TiledDrawingTypeWrapper
  let tiles: Tiles
  let foregroundColor: Color
  let backgroundColor: Color
  let unitSize: CGFloat
  let viewSize: CGSize

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
