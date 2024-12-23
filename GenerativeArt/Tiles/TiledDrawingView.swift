import UIKit

final class TiledDrawingView: UIView {
  enum Message {
    case sizeDidChange(CGSize)
  }

  var type: TiledDrawingType {
    get { panelView.type }
    set { panelView.type = newValue }
  }

  private let panelView: DrawingPanelView
  private var send: (Message) -> Void = { _ in }

  private let panelWidthConstraint: NSLayoutConstraint
  private let panelHeightConstraint: NSLayoutConstraint
  private var lastSize: CGSize = .zero

  init(type: TiledDrawingType) {
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
    send(.sizeDidChange(bounds.size))
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
      guard type != oldValue else { return }
      tiledDrawing.type = type
      tiledDrawing.updateVariations()
      setNeedsDisplay()
    }
  }

  var maxSize: CGSize {
    get { tiledDrawing.tiles.maxSize }
    set {
      guard maxSize != newValue else { return }
      tiledDrawing.tiles = Tiles(maxSize: newValue, maxTileSize: tiledDrawing.tiles.maxTileSize, scale: tiledDrawing.tiles.scale)
    }
  }

  var size: CGSize {
    tiledDrawing.tiles.size
  }

  private var tiledDrawing: TiledDrawing
  private var lastSize: CGSize = .zero

  init(type: TiledDrawingType) {
    self.type = type
    tiledDrawing = TiledDrawing(type: type, tiles: Tiles(maxSize: .zero, maxTileSize: type.defaultUnitSize, scale: UIScreen.main.scale))
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
