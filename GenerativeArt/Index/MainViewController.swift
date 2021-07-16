import UIKit

final class MainViewController: UIViewController {
  private var mainView: MainView {
    view as! MainView
  }

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    view = MainView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let indexViewController = IndexViewController { [weak self] in self?.update($0) }
    addChild(indexViewController)
    mainView.indexView = indexViewController.view
    indexViewController.didMove(toParent: self)

    navigationController?.isNavigationBarHidden = true
  }

  private func update(_ action: IndexViewController.Action) {
    switch action {
    case let .showTiledDrawing(variation):
      let viewModel = TiledDrawingViewModel(
        variation: variation,
        tileForegroundColor: variation.defaultForegroundColor,
        tileBackgroundColor: variation.defaultBackgroundColor
      )
      let viewController = TiledDrawingViewController(viewModel: viewModel, animated: mainView.animateVariations) { [weak self] in
        self?.update($0)
      }
      push(viewController)
    case .showMondrian:
      let viewController = MondrianViewController { [weak self] in self?.update($0) }
      push(viewController)
    }
  }

  private func update(_ action: TiledDrawingViewController.Action) {
    switch action {
    case .dismiss: pop()
    }
  }

  private func update(_ action: MondrianViewController.Action) {
    switch action {
    case .dismiss: pop()
    }
  }

  private func push(_ viewController: UIViewController) {
    navigationController?.pushViewController(viewController, animated: true)
  }

  private func pop() {
    navigationController?.popViewController(animated: true)
  }
}

final class MainView: UIView {
  var indexView: UIView? {
    didSet {
      if let view = oldValue { view.removeFromSuperview() }
      guard let view = indexView else { return }
      addToContainerView(view)
    }
  }

  var animateVariations: Bool {
    controlsView.animationSwitch.isOn
  }

  private let containerView = UIView()
  private let controlsView = MainControlsView()

  init() {
    super.init(frame: .zero)

    backgroundColor = .systemBackground

    let separatorView = UIView()
    separatorView.backgroundColor = .lightGray

    addSubview(containerView)
    addSubview(separatorView)
    addSubview(controlsView)

    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

    separatorView.translatesAutoresizingMaskIntoConstraints = false
    separatorView.topAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    separatorView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    separatorView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    separatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true

    controlsView.translatesAutoresizingMaskIntoConstraints = false
    controlsView.topAnchor.constraint(equalTo: separatorView.bottomAnchor).isActive = true
    controlsView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    controlsView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    controlsView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func addToContainerView(_ view: UIView) {
    containerView.addSubview(view)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
    view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
    view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
  }
}

final class MainControlsView: UIStackView {
  let animationSwitch = UISwitch()

  init() {
    super.init(frame: .zero)

    layoutMargins = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)

    isLayoutMarginsRelativeArrangement = true
    preservesSuperviewLayoutMargins = true
    axis = .vertical
    spacing = 8

    let animationSwitchLabel = UILabel()
    animationSwitchLabel.text = "Animate Variations"

    let horizontalStackView = UIStackView()
    horizontalStackView.spacing = 8

    horizontalStackView.addArrangedSubview(animationSwitchLabel)
    horizontalStackView.addArrangedSubview(animationSwitch)

    addArrangedSubview(horizontalStackView)

    let heightConstraint = heightAnchor.constraint(equalToConstant: 0)
    heightConstraint.priority = .defaultLow
    heightConstraint.isActive = true
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
