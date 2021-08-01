import UIKit

struct TiledDrawingViewModel {
  enum Message {
    case dismissControl
  }

  let variation: TiledDrawingType
  var tileForegroundColor: Color
  var tileBackgroundColor: Color
}

extension TiledDrawingViewModel {
  init(type: TiledDrawingType) {
    self.init(variation: type, tileForegroundColor: type.defaultForegroundColor, tileBackgroundColor: type.defaultBackgroundColor)
  }
}

final class TiledDrawingView: UIView {
  private enum ColorSelection {
    case none
    case foreground
    case background
  }

  var isShowingControl: Bool {
    return !isColorPickerHidden || !isSizeControlHidden
  }

  private let colorPickerView: ColorPickerView
  private let sizeControl = SizeControl()
  private let boundsView: DrawingBoundsView
  private let dismissControl = UIControl()
  private var viewModel: TiledDrawingViewModel

  private let send: (TiledDrawingViewModel.Message) -> Void
  private var colorPickerTopConstraint: NSLayoutConstraint!
  private var colorPickerBottomConstraint: NSLayoutConstraint!
  private var sizeControlTopConstraint: NSLayoutConstraint!
  private var sizeControlBottomConstraint: NSLayoutConstraint!
  private var colorSelection: ColorSelection = .none
  private var isColorPickerHidden = true
  private var isSizeControlHidden = true
  private var isAnimating = false

  init(viewModel: TiledDrawingViewModel, send: @escaping (TiledDrawingViewModel.Message) -> Void) {
    self.viewModel = viewModel
    self.send = send
    let tiledDrawing = TiledDrawing(
      variation: viewModel.variation,
      foregroundColor: viewModel.tileForegroundColor.color(),
      backgroundColor: viewModel.tileBackgroundColor.color()
    )
    boundsView = DrawingBoundsView(tiledDrawing: tiledDrawing)
    colorPickerView = ColorPickerView()
    super.init(frame: .zero)

    backgroundColor = viewModel.variation.backgroundColor.color()

    colorPickerView.isHidden = true
    sizeControl.isHidden = true
    dismissControl.isHidden = true

    addSubview(boundsView)
    boundsView.addEdgeConstraints(to: safeAreaLayoutGuide, margin: 12)

    addSubview(dismissControl)
    dismissControl.addEdgeConstraints(to: self)

    addSubview(colorPickerView)
    colorPickerView.addHorizontalConstraints(to: self, margin: 12)

    colorPickerTopConstraint = colorPickerView.topAnchor.constraint(equalTo: bottomAnchor)
    colorPickerTopConstraint.priority = .defaultHigh
    colorPickerTopConstraint.isActive = true

    colorPickerBottomConstraint = colorPickerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -12)
    colorPickerBottomConstraint.priority = .defaultLow
    colorPickerBottomConstraint.isActive = true

    addSubview(sizeControl)
    sizeControl.addHorizontalConstraints(to: self, margin: 12)

    sizeControlTopConstraint = sizeControl.topAnchor.constraint(equalTo: bottomAnchor)
    sizeControlTopConstraint.priority = .defaultHigh
    sizeControlTopConstraint.isActive = true

    sizeControlBottomConstraint = sizeControl.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -12)
    sizeControlBottomConstraint.priority = .defaultLow
    sizeControlBottomConstraint.isActive = true

    colorPickerView.didSelect = { [weak self] in self?.didSelectColor($0) }
    boundsView.send = { [weak self] in self?.update($0) }
    sizeControl.send = { [weak self] in self?.update($0) }
    dismissControl.addTarget(self, action: #selector(didPressDismissControl), for: .touchUpInside)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateVariations() {
    boundsView.panelView.tiledDrawing.updateVariations()
    boundsView.panelView.setNeedsDisplay()
  }

  func updateRandomTiles(count: Int) {
    guard count > 0 else { return }
    for _ in 1...count { boundsView.panelView.tiledDrawing.updateRandomTile() }
    boundsView.panelView.setNeedsDisplay()
  }

  func showForegroundColorPicker() {
    if !isColorPickerHidden, colorSelection == .foreground {
      toggleColorPicker()
      return
    }
    colorSelection = .foreground
    colorPickerView.select(viewModel.tileForegroundColor)
    showColorPicker()
  }

  func showBackgroundColorPicker() {
    if !isColorPickerHidden, colorSelection == .background {
      toggleColorPicker()
      return
    }
    colorSelection = .background
    colorPickerView.select(viewModel.tileBackgroundColor)
    showColorPicker()
  }

  func showSizeControl() {
    guard isSizeControlHidden else {
      toggleSizeControl()
      return
    }
    if isShowingControl {
      hideControl { [weak self] in
        self?.toggleSizeControl()
      }
    } else {
      toggleSizeControl()
    }
  }

  func hideControl(completion: (() -> Void)? = nil) {
    guard isShowingControl else { return }
    if !isColorPickerHidden {
      toggleColorPicker(completion: completion)
    } else if !isSizeControlHidden {
      toggleSizeControl(completion: completion)
    }
  }

  private func showColorPicker() {
    guard isColorPickerHidden else { return }
    if isShowingControl {
      hideControl { [weak self] in
        self?.toggleColorPicker()
      }
    } else {
      toggleColorPicker()
    }
  }

  private func toggleColorPicker(completion: (() -> Void)? = nil) {
    if isAnimating { return }
    isAnimating = true

    colorPickerTopConstraint.priority = isColorPickerHidden ? .defaultLow : .defaultHigh
    colorPickerBottomConstraint.priority = isColorPickerHidden ? .defaultHigh : .defaultLow
    isColorPickerHidden.toggle()
    dismissControl.isHidden.toggle()

    if !isColorPickerHidden {
      colorPickerView.alpha = 1
      colorPickerView.isHidden = false
    }

    UIView.animate(
      withDuration: 0.3,
      animations: { [weak self] in self?.layoutIfNeeded() },
      completion: { [weak self] _ in
        guard let self = self else { return }
        self.isAnimating = false
        if self.isColorPickerHidden {
          self.colorPickerView.isHidden = true
        }
        completion?()
      }
    )
  }

  private func toggleSizeControl(completion: (() -> Void)? = nil) {
    if isAnimating { return }
    isAnimating = true

    sizeControlTopConstraint.priority = isSizeControlHidden ? .defaultLow : .defaultHigh
    sizeControlBottomConstraint.priority = isSizeControlHidden ? .defaultHigh : .defaultLow
    isSizeControlHidden.toggle()
    dismissControl.isHidden.toggle()

    if !isSizeControlHidden {
      sizeControl.alpha = 1
      sizeControl.isHidden = false
    }

    UIView.animate(
      withDuration: 0.3,
      animations: { [weak self] in self?.layoutIfNeeded() },
      completion: { [weak self] _ in
        guard let self = self else { return }
        self.isAnimating = false
        if self.isSizeControlHidden {
          self.sizeControl.isHidden = true
        }
        completion?()
      }
    )
  }

  private func didSelectColor(_ color: Color) {
    toggleColorPicker()
    switch colorSelection {
    case .none: break
    case .foreground:
      viewModel.tileForegroundColor = color
      boundsView.panelView.tiledDrawing.foregroundColor = color.color()
    case .background:
      viewModel.tileBackgroundColor = color
      boundsView.panelView.tiledDrawing.backgroundColor = color.color()
    }
    colorSelection = .none
  }

  @objc private func didPressDismissControl() {
    send(.dismissControl)
  }

  private func update(_ message: SizeControl.Message) {
    switch message {
    case let .valueDidChange(value):
      let initialTileSize = boundsView.panelView.tiledDrawing.tileSize
      boundsView.panelView.tiledDrawing.unitSize = drawingSizeControl.convertedValue(value)
      guard initialTileSize != boundsView.panelView.tiledDrawing.tileSize else { return }
      boundsView.updatePanelSize()
      updateVariations()
    }
  }

  private var drawingSizeControl = DrawingSizeControl.standard

  private func update(_ message: DrawingBoundsView.Message) {
    switch message {
    case let .sizeDidChange(size): drawingSizeControl = DrawingSizeControl(min: 20, max: min(size.width, size.height))
    }
  }
}

struct DrawingSizeControl {
  let min: CGFloat
  let max: CGFloat

  func convertedValue(_ value: CGFloat) -> CGFloat {
    // y = - log(-.2(x - 5)) gives us a good curve with (5, 3) max coordinates.
    // We normalize the max coordinates with `x = sliderValue * 5` and dividing by 3 at the end.
    let y = -log(-0.2 * (value * 5 - 5)) / 3
    return min + (max - min) * Swift.min(1, y)
  }

  static var standard: DrawingSizeControl {
    DrawingSizeControl(min: 0, max: 1)
  }
}

final class DrawingBoundsView: UIView {
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
