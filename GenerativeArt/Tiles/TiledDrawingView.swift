import SwiftUI

struct TiledDrawingSizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero

  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}

struct TiledDrawingView: View {
  let type: TiledDrawingTypeWrapper
  let foregroundColor: Color
  let backgroundColor: Color
  let tileSize: CGFloat

  @State private var tileSizeControl: TileSizeControl = .empty
  @State private var unitSize: CGFloat = 30

  var body: some View {
    GeometryReader { proxy in
      TiledDrawingViewRepresentable(type: type, foregroundColor: foregroundColor, backgroundColor: backgroundColor, unitSize: unitSize)
        .preference(key: TiledDrawingSizePreferenceKey.self, value: proxy.size)
    }
    .onChange(of: tileSize) { _, newValue in unitSize = tileSizeControl.widthForValue(newValue) }
    .onPreferenceChange(TiledDrawingSizePreferenceKey.self) { size in
      tileSizeControl = TileSizeControl(boundsSize: size, minWidth: 20)
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
    view.drawingForegroundColor = foregroundColor
    view.drawingBackgroundColor = backgroundColor
    view.unitSize = unitSize
    view.type = type.type
  }
}

final class TiledDrawingUIView: UIView {
  var type: TiledDrawingType {
    get { panelView.type }
    set { panelView.type = newValue }
  }

  var drawingForegroundColor: Color {
    get { panelView.drawingForegroundColor }
    set {
      guard newValue != panelView.drawingForegroundColor else { return }
      panelView.drawingForegroundColor = newValue
    }
  }

  var drawingBackgroundColor: Color {
    get { panelView.drawingBackgroundColor }
    set {
      guard newValue != panelView.drawingBackgroundColor else { return }
      panelView.drawingBackgroundColor = newValue
    }
  }

  var unitSize: CGFloat {
    get { panelView.unitSize }
    set {
      guard newValue != panelView.unitSize else { return }
      panelView.unitSize = newValue
      updatePanelSize()
    }
  }

  private let panelView: DrawingPanelView

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
    let panelSize = panelView.size
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

  var drawingForegroundColor: Color = .red {
    didSet { tiledDrawing.foregroundColor = drawingForegroundColor }
  }

  var drawingBackgroundColor: Color = .white {
    didSet { tiledDrawing.backgroundColor = drawingBackgroundColor }
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

  var size: CGSize {
    tiledDrawing.tiles.size
  }

  private var tiledDrawing: TiledDrawing
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
