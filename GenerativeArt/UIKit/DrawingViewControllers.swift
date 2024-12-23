import UIKit

final class TiledDrawingViewController: UIViewController, ToolbarController {
  private var drawingView: TiledDrawingView { return view as! TiledDrawingView }
  private let send: (Message) -> () = { _ in }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    .darkContent
  }

  private func update(_ message: TiledDrawingView.Message) {
    switch message {
    case .dismissControl: drawingView.hideControl()
    }
  }

  private func update(_ message: DrawingControls.Message) {
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

final class MondrianViewController: UIViewController, ToolbarController {
  private func update(_ message: DrawingControls.Message) {
    switch message {
    case .dismiss: break // send(.dismissDrawing)
    case .showNext, .showNextFromTimer: break // mondrianView.redraw()
    case .showBackgroundColors, .showForegroundColors, .showSizeSlider: break
    }
  }
}
