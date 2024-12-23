import SwiftUI

final class TiledDrawingViewWithControls: UIView {
  enum Message {
    case dismissControl
  }

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
  private let boundsView: TiledDrawingView
  private let dismissControl = UIControl()

  private let send: (Message) -> Void
  private var colorSelection: ColorSelection = .none
  private var tileSizeControl: TileSizeControl = .empty
  private var isColorPickerHidden = true
  private var isSizeControlHidden = true
  private var isAnimating = false

  private var tileForegroundColor: Color = .red
  private var tileBackgroundColor: Color = .red

  init(type: TiledDrawingType, send: @escaping (Message) -> Void) {
    self.send = send
    boundsView = TiledDrawingView(type: type)
    colorPickerView = ColorPickerView()
    super.init(frame: .zero)

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
//    boundsView.send = { [weak self] in self?.update($0) }
    sizeControl.send = { [weak self] in self?.update($0) }
    dismissControl.addTarget(self, action: #selector(didPressDismissControl), for: .touchUpInside)
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

  func showForegroundColorPicker() {
    if !isColorPickerHidden, colorSelection == .foreground {
      toggleColorPicker()
      return
    }
    colorSelection = .foreground
    colorPickerView.select(tileForegroundColor)
    showColorPicker()
  }

  func showBackgroundColorPicker() {
    if !isColorPickerHidden, colorSelection == .background {
      toggleColorPicker()
      return
    }
    colorSelection = .background
    colorPickerView.select(tileBackgroundColor)
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
      tileForegroundColor = color
//      boundsView.panelView.tiledDrawing.foregroundColor = color.color()
    case .background:
      tileBackgroundColor = color
//      boundsView.panelView.tiledDrawing.backgroundColor = color.color()
    }
    colorSelection = .none
  }

  @objc private func didPressDismissControl() {
    send(.dismissControl)
  }

  private func update(_ message: SizeControl.Message) {
    switch message {
    case .valueDidChange:
//      let initialTileSize = boundsView.panelView.tiledDrawing.tileSize
//      boundsView.panelView.tiledDrawing.unitSize = tileSizeControl.widthForValue(value)
//      guard initialTileSize != boundsView.panelView.tiledDrawing.tileSize else { return }
      boundsView.updatePanelSize()
      updateVariations()
    }
  }

  private func update(_ message: TiledDrawingView.Message) {
    switch message {
    case let .sizeDidChange(size): tileSizeControl = TileSizeControl(boundsSize: size, minWidth: 20)
    }
  }
}
