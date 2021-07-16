import UIKit

struct TiledDrawingViewModel {
  enum Action {
    case dismissControl
  }

  let variation: TiledDrawingType
  var tileForegroundColor: Color
  var tileBackgroundColor: Color
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

  private let perform: (TiledDrawingViewModel.Action) -> Void
  private var colorPickerTopConstraint: NSLayoutConstraint!
  private var colorPickerBottomConstraint: NSLayoutConstraint!
  private var sizeControlTopConstraint: NSLayoutConstraint!
  private var sizeControlBottomConstraint: NSLayoutConstraint!
  private var colorSelection: ColorSelection = .none
  private var isColorPickerHidden = true
  private var isSizeControlHidden = true
  private var isAnimating = false

  init(viewModel: TiledDrawingViewModel, perform: @escaping (TiledDrawingViewModel.Action) -> Void) {
    self.viewModel = viewModel
    self.perform = perform
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

    colorPickerView.translatesAutoresizingMaskIntoConstraints = false
    colorPickerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
    colorPickerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true

    colorPickerTopConstraint = colorPickerView.topAnchor.constraint(equalTo: bottomAnchor)
    colorPickerTopConstraint.priority = .defaultHigh
    colorPickerTopConstraint.isActive = true

    colorPickerBottomConstraint = colorPickerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -12)
    colorPickerBottomConstraint.priority = .defaultLow
    colorPickerBottomConstraint.isActive = true

    addSubview(sizeControl)

    sizeControl.translatesAutoresizingMaskIntoConstraints = false
    sizeControl.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
    sizeControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true

    sizeControlTopConstraint = sizeControl.topAnchor.constraint(equalTo: bottomAnchor)
    sizeControlTopConstraint.priority = .defaultHigh
    sizeControlTopConstraint.isActive = true

    sizeControlBottomConstraint = sizeControl.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -12)
    sizeControlBottomConstraint.priority = .defaultLow
    sizeControlBottomConstraint.isActive = true

    colorPickerView.didSelect = { [weak self] in self?.didSelectColor($0) }
    boundsView.perform = { [weak self] in self?.update($0) }
    sizeControl.perform = { [weak self] in self?.update($0) }
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
    perform(.dismissControl)
  }

  private func update(_ action: SizeControl.Action) {
    switch action {
    case let .valueDidChange(value):
      let initialTileSize = boundsView.panelView.tiledDrawing.tileSize
      boundsView.panelView.tiledDrawing.unitSize = value
      guard initialTileSize != boundsView.panelView.tiledDrawing.tileSize else { return }
      boundsView.updatePanelSize()
      updateVariations()
    }
  }

  private func update(_ action: DrawingBoundsView.Action) {
    switch action {
    case let .sizeDidChange(size): sizeControl.configure(min: 10, max: min(size.width, size.height))
    }
  }
}

final class DrawingBoundsView: UIView {
  enum Action {
    case sizeDidChange(CGSize)
  }

  let panelView: DrawingPanelView
  var perform: (Action) -> Void = { _ in }

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
    perform(.sizeDidChange(bounds.size))
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
    Draw.paths(tiledDrawing.paths)
  }
}
