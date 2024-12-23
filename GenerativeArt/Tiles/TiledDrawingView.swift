import UIKit

final class TiledDrawingView: UIView {
  enum Message {
    case sizeDidChange(CGSize)
  }

  let panelView: DrawingPanelView
  var send: (Message) -> Void = { _ in }

  private let panelWidthConstraint: NSLayoutConstraint
  private let panelHeightConstraint: NSLayoutConstraint
  private var lastSize: CGSize = .zero

  init(tiledDrawing: TiledDrawing) {
    panelView = DrawingPanelView(tiledDrawing: tiledDrawing)
    panelWidthConstraint = panelView.widthAnchor.constraint(equalToConstant: 0)
    panelHeightConstraint = panelView.heightAnchor.constraint(equalToConstant: 0)
    panelWidthConstraint.isActive = true
    panelHeightConstraint.isActive = true
    super.init(frame: .zero)

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
    panelView.tiledDrawing.maxSize = bounds.size
    let panelSize = panelView.tiledDrawing.size
    panelWidthConstraint.constant = panelSize.width
    panelHeightConstraint.constant = panelSize.height
  }
}

final class DrawingPanelView: UIView {
  var tiledDrawing: TiledDrawing

  private var lastSize: CGSize = .zero

  init(tiledDrawing: TiledDrawing) {
    self.tiledDrawing = tiledDrawing
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
