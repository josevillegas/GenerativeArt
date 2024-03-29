import UIKit

struct TiledDrawingViewModel {
  enum Message {
    case dismissControl
  }

  let options: DrawingControls.Options
  let backgroundColor: Color
  var tileForegroundColor: Color
  var tileBackgroundColor: Color
  let defaultUnitSize: CGFloat
  let paths: (TiledDrawing.PathProperties) -> [Path]
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
  private var colorSelection: ColorSelection = .none
  private var tileSizeControl: TileSizeControl = .empty
  private var isColorPickerHidden = true
  private var isSizeControlHidden = true
  private var isAnimating = false

  init(viewModel: TiledDrawingViewModel, send: @escaping (TiledDrawingViewModel.Message) -> Void) {
    self.viewModel = viewModel
    self.send = send
    let tiledDrawing = TiledDrawing(
      unitSize: viewModel.defaultUnitSize,
      foregroundColor: viewModel.tileForegroundColor.color(),
      backgroundColor: viewModel.tileBackgroundColor.color(),
      makePaths: viewModel.paths
    )
    boundsView = DrawingBoundsView(tiledDrawing: tiledDrawing)
    colorPickerView = ColorPickerView()
    super.init(frame: .zero)

    backgroundColor = viewModel.backgroundColor.color()

    colorPickerView.isHidden = true
    sizeControl.isHidden = true
    dismissControl.isHidden = true

    colorPickerView.alpha = 0
    sizeControl.alpha = 0

    addSubview(boundsView)
    boundsView.addEdgeConstraints(to: safeAreaLayoutGuide, margin: 12)

    addSubview(dismissControl)
    dismissControl.addEdgeConstraints(to: self)

    addSubview(colorPickerView)
    colorPickerView.addHorizontalConstraints(to: self, margin: 12)
    colorPickerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -12).isActive = true

    addSubview(sizeControl)
    sizeControl.addHorizontalConstraints(to: self, margin: 12)
    sizeControl.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -12).isActive = true

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

    isColorPickerHidden.toggle()
    dismissControl.isHidden.toggle()

    if !isColorPickerHidden {
      colorPickerView.isHidden = false
    }

    UIView.animate(
      withDuration: 0.2,
      animations: { [weak self] in
        guard let self = self else { return }
        self.colorPickerView.alpha = self.isColorPickerHidden ? 0 : 1
      },
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

    isSizeControlHidden.toggle()
    dismissControl.isHidden.toggle()

    if !isSizeControlHidden {
      sizeControl.isHidden = false
    }

    UIView.animate(
      withDuration: 0.2,
      animations: { [weak self] in
        guard let self = self else { return }
        self.sizeControl.alpha = self.isSizeControlHidden ? 0 : 1
      },
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
      boundsView.panelView.tiledDrawing.unitSize = tileSizeControl.widthForValue(value)
      guard initialTileSize != boundsView.panelView.tiledDrawing.tileSize else { return }
      boundsView.updatePanelSize()
      updateVariations()
    }
  }

  private func update(_ message: DrawingBoundsView.Message) {
    switch message {
    case let .sizeDidChange(size): tileSizeControl = TileSizeControl(boundsSize: size, minWidth: 20)
    }
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
