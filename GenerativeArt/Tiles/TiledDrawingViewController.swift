import UIKit

final class TiledDrawingViewController: UIViewController {
  enum Action {
    case dismiss
  }

  private let viewModel: TiledDrawingViewModel
  private var drawingView: TiledDrawingView { return view as! TiledDrawingView }
  private let toolbarController = TiledDrawingViewToolbarController()
  private let perform: (Action) -> ()
  private var timer: Timer?

  override var preferredStatusBarStyle: UIStatusBarStyle {
    .darkContent
  }

  init(viewModel: TiledDrawingViewModel, animated: Bool, perform: @escaping (Action) -> ()) {
    self.viewModel = viewModel
    self.perform = perform
    super.init(nibName: nil, bundle: nil)

    toolbarItems = toolbarController.toolbarItems
    toolbarController.perform = { [weak self] in self?.update($0) }

    if animated {
      timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { [weak self] _ in self?.updateRandomTiles() }
    }
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

  private func update(_ action: TiledDrawingViewModel.Action) {
    switch action {
    case .dismissControl: drawingView.hideControl()
    }
  }

  private func update(_ action: TiledDrawingViewToolbarController.Action) {
    switch action {
    case .dismiss:  perform(.dismiss)
    case .updateVariations: drawingView.updateVariations()
    case .showForegroundColors: drawingView.showForegroundColorPicker()
    case .showBackgroundColors: drawingView.showBackgroundColorPicker()
    case .showSizeSlider: drawingView.showSizeControl()
    }
  }
}