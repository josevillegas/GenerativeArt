import UIKit
import Combine

final class TiledDrawingViewController: UIViewController, ToolbarController {
  private let viewModel: TiledDrawingViewModel
  private var drawingView: TiledDrawingView { return view as! TiledDrawingView }
  private let toolbarController: TiledDrawingViewToolbarController
  private let send: (Message) -> ()
  private let timer = DrawingTimer()
  private var cancellables: [AnyCancellable] = []
  private var wasPlaying = false

  override var preferredStatusBarStyle: UIStatusBarStyle {
    .darkContent
  }

  init(viewModel: TiledDrawingViewModel, presentationMode: DrawingPresentationMode,  send: @escaping (Message) -> ()) {
    self.viewModel = viewModel
    toolbarController = TiledDrawingViewToolbarController(presentationMode: presentationMode)
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

    timer.onFire.sink { [weak self] in self?.drawingView.updateRandomTiles(count: 20) }
      .store(in: &cancellables)
    timer.$isPlaying.sink { [weak self] in self?.toolbarController.updatePlayButton(isPlaying: $0) }
      .store(in: &cancellables)
    toolbarController.send = { [weak self] in self?.update($0) }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    if wasPlaying {
      timer.start()
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    wasPlaying = timer.isPlaying
    timer.stop()
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
    case .toggleAnimation: timer.isPlaying.toggle()
    case .updateVariations: drawingView.updateVariations()
    }
  }
}
