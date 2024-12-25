import SwiftUI

struct TiledDrawingView: View {
  let type: TiledDrawingTypeWrapper
  let foregroundColor: Color
  let backgroundColor: Color
  let tileSize: CGFloat
  let viewSize: CGSize

  @State private var tileSizeControl: TileSizeControl = .empty
  @State private var unitSize: CGFloat = 30

  var body: some View {
    GeometryReader { proxy in
      TiledDrawingViewRepresentable(type: type, foregroundColor: foregroundColor, backgroundColor: backgroundColor, unitSize: unitSize)
    }
    .onChange(of: tileSize) { _, newValue in unitSize = tileSizeControl.widthForValue(newValue) }
    .onChange(of: viewSize) { _, _ in
      tileSizeControl = TileSizeControl(boundsSize: viewSize, minWidth: 20)
      unitSize = tileSizeControl.widthForValue(tileSize)
    }
  }
}

struct TiledDrawingViewRepresentable: UIViewRepresentable {
  let type: TiledDrawingTypeWrapper
  let foregroundColor: Color
  let backgroundColor: Color
  let unitSize: CGFloat

  private let scale = UIScreen.main.scale

  func makeUIView(context: Context) -> TiledDrawingUIView {
    TiledDrawingUIView(type: type.type, scale: scale)
  }

  func updateUIView(_ view: TiledDrawingUIView, context: Context) {
    view.panelView.tiledDrawing.foregroundColor = foregroundColor
    view.panelView.tiledDrawing.backgroundColor = backgroundColor
    view.unitSize = unitSize
    view.panelView.type = type.type
  }
}

final class TiledDrawingUIView: UIView {
  var unitSize: CGFloat {
    get { panelView.unitSize }
    set {
      guard newValue != panelView.unitSize else { return }
      panelView.unitSize = newValue
      updatePanelSize()
    }
  }

  let panelView: DrawingPanelView

  private let panelWidthConstraint: NSLayoutConstraint
  private let panelHeightConstraint: NSLayoutConstraint
  private var lastSize: CGSize = .zero

  init(type: TiledDrawingType, scale: CGFloat) {
    panelView = DrawingPanelView(type: type, scale: scale)
    panelWidthConstraint = panelView.widthAnchor.constraint(equalToConstant: 0)
    panelHeightConstraint = panelView.heightAnchor.constraint(equalToConstant: 0)
    super.init(frame: .zero)

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

  override func layoutSubviews() {
    super.layoutSubviews()

    guard lastSize != bounds.size else { return }
    lastSize = bounds.size
    updatePanelSize()
  }

  func updatePanelSize() {
    panelView.maxSize = bounds.size
    let panelSize = panelView.tiledDrawing.tiles.size
    panelWidthConstraint.constant = panelSize.width
    panelHeightConstraint.constant = panelSize.height
  }
}

final class DrawingPanelView: UIView {
  var type: TiledDrawingType {
    didSet {
      tiledDrawing.type = type
      tiledDrawing.updateVariations()
      setNeedsDisplay()
    }
  }

  var unitSize: CGFloat {
    didSet {
      guard unitSize != oldValue else { return }
      tiledDrawing.tiles = Tiles(maxSize: maxSize, maxTileSize: unitSize, scale: tiledDrawing.tiles.scale)
    }
  }

  var maxSize: CGSize {
    get { tiledDrawing.tiles.maxSize }
    set {
      guard maxSize != newValue else { return }
      tiledDrawing.tiles = Tiles(maxSize: newValue, maxTileSize: unitSize, scale: tiledDrawing.tiles.scale)
    }
  }

  var tiledDrawing: TiledDrawing
  private let scale: CGFloat
  private var lastSize: CGSize = .zero

  init(type: TiledDrawingType, scale: CGFloat) {
    self.type = type
    self.scale = scale
    self.unitSize = type.defaultUnitSize
    tiledDrawing = TiledDrawing(type: type, tiles: Tiles(maxSize: .zero, maxTileSize: unitSize, scale: scale))
    super.init(frame: .zero)

    backgroundColor = .white
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    if lastSize != bounds.size {
      lastSize = bounds.size
      tiledDrawing.updateVariations()
      setNeedsDisplay()
    }
  }

  override func draw(_: CGRect) {
    tiledDrawing.paths.draw()
  }
}
