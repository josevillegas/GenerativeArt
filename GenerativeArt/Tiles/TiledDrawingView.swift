import SwiftUI

final class TiledDrawingView: UIView {
  enum Action {
    case sizeDidChange(CGSize)
  }

  let panelView: DrawingPanelView
  private let perform: (Action) -> Void

  private let panelWidthConstraint: NSLayoutConstraint
  private let panelHeightConstraint: NSLayoutConstraint
  private var lastSize: CGSize = .zero

  init(type: TiledDrawingType, perform: @escaping (Action) -> Void) {
    self.perform = perform
    panelView = DrawingPanelView(type: type)
    panelWidthConstraint = panelView.widthAnchor.constraint(equalToConstant: 0)
    panelHeightConstraint = panelView.heightAnchor.constraint(equalToConstant: 0)
    super.init(frame: .zero)

    panelWidthConstraint.isActive = true
    panelHeightConstraint.isActive = true

    addSubview(panelView)
    panelView.center(with: self)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    guard lastSize != bounds.size else { return }
    lastSize = bounds.size
    updatePanelSize()
    perform(.sizeDidChange(bounds.size))
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
  private var lastSize: CGSize = .zero

  init(type: TiledDrawingType) {
    self.type = type
    self.unitSize = type.defaultUnitSize
    tiledDrawing = TiledDrawing(type: type, tiles: Tiles(maxSize: .zero, maxTileSize: unitSize, scale: UIScreen.main.scale))
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
