import UIKit

final class TiledDrawingViewController: UIViewController, ToolbarController {
  private let viewModel: TiledDrawingViewModel
  private var drawingView: TiledDrawingView { return view as! TiledDrawingView }
  private let toolbarController: TiledDrawingViewToolbarController
  private let send: (Message) -> ()

  override var preferredStatusBarStyle: UIStatusBarStyle {
    .darkContent
  }

  init(viewModel: TiledDrawingViewModel, presentationMode: DrawingPresentationMode,  send: @escaping (Message) -> ()) {
    self.viewModel = viewModel
    toolbarController = TiledDrawingViewToolbarController(options: viewModel.type.options, presentationMode: presentationMode)
    self.send = send
    super.init(nibName: nil, bundle: nil)

    toolbarItems = toolbarController.toolbarItems
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    view = TiledDrawingView(viewModel: viewModel) { [weak self] in self?.update($0) }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    toolbarController.send = { [weak self] in self?.update($0) }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    toolbarController.viewDidAppear()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    toolbarController.viewWillDisappear()
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
    case .showNext: drawingView.updateVariations()
    case .showNextFromTimer: drawingView.updateRandomTiles(count: 20)
    case .showSizeSlider: drawingView.showSizeControl()
    }
  }
}
