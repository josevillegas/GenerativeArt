import UIKit

final class TiledDrawingViewController: UIViewController, ToolbarController {
  private let viewModel: TiledDrawingViewModel
  private var drawingView: TiledDrawingView { return view as! TiledDrawingView }
  private let toolbarController = TiledDrawingViewToolbarController()
  private let send: (Message) -> ()
  private var timer: Timer?
  private var isPlaying = false {
    didSet {
      guard isPlaying != oldValue else { return }
      updateForIsPlaying()
    }
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    .darkContent
  }

  init(viewModel: TiledDrawingViewModel, send: @escaping (Message) -> ()) {
    self.viewModel = viewModel
    self.send = send
    super.init(nibName: nil, bundle: nil)

    toolbarItems = toolbarController.toolbarItems
    toolbarController.send = { [weak self] in self?.update($0) }
    updateForIsPlaying()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    timer?.invalidate()
  }

  override func loadView() {
    view = TiledDrawingView(viewModel: viewModel) { [weak self] in
      self?.update($0)
    }
  }

  private func updateRandomTiles() {
    drawingView.updateRandomTiles(count: 20)
  }

  private func update(_ message: TiledDrawingViewModel.Message) {
    switch message {
    case .dismissControl: drawingView.hideControl()
    }
  }

  private func update(_ message: TiledDrawingViewToolbarController.Message) {
    switch message {
    case .dismiss:  send(.dismissDrawing)
    case .showBackgroundColors: drawingView.showBackgroundColorPicker()
    case .showForegroundColors: drawingView.showForegroundColorPicker()
    case .showSizeSlider: drawingView.showSizeControl()
    case .toggleAnimation: isPlaying.toggle()
    case .updateVariations: drawingView.updateVariations()
    }
  }

  private func updateForIsPlaying() {
    timer?.invalidate()
    if isPlaying {
      timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { [weak self] _ in self?.updateRandomTiles() }
    } else {
      timer = nil
    }
    toolbarController.updatePlayButton(isPlaying: isPlaying)
  }
}
