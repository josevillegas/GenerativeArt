import UIKit

final class MondrianViewController: UIViewController, ToolbarController {
  private let toolbarController: MondrianViewToolbarController
  private let mondrianView = MondrianView()
  private let send: (Message) -> ()

  init(presentationMode: DrawingPresentationMode, send: @escaping (Message) -> ()) {
    toolbarController = MondrianViewToolbarController(presentationMode: presentationMode)
    self.send = send
    super.init(nibName: nil, bundle: nil)

    toolbarItems = toolbarController.toolbarItems
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    view = mondrianView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    toolbarController.send = { [weak self] in self?.update($0) }
  }

  private func update(_ message: MondrianViewToolbarController.Message) {
    switch message {
    case .dismiss: send(.dismissDrawing)
    case .redraw: mondrianView.redraw()
    }
  }
}

final class MondrianView: UIView {
  private let drawingView = MondrianDrawingView()

  init() {
    super.init(frame: .zero)

    backgroundColor = UIColor(white: 0.9, alpha: 1)

    addSubview(drawingView)
    drawingView.addEdgeConstraints(to: safeAreaLayoutGuide, margin: 24)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func redraw() {
    drawingView.redraw()
  }
}

final class MondrianDrawingView: UIView {
  private let drawing = MondrianDrawing()

  init() {
    super.init(frame: .zero)
    backgroundColor = .white
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func redraw() {
    setNeedsDisplay()
  }

  override func draw(_ rect: CGRect) {
    Draw.paths(drawing.paths(frame: bounds))
  }

  override func layoutSubviews() {
    redraw()
  }
}
