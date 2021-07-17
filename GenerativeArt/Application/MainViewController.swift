import UIKit

final class MainViewController: UIViewController {
  private let controlsView = MainControlsView()

  init() {
    super.init(nibName: nil, bundle: nil)
    title = "Generative Art"
    navigationItem.largeTitleDisplayMode = .always
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground

    let indexViewController = IndexViewController { [weak self] in self?.update($0) }
    let tableView = indexViewController.tableView!
    addChild(indexViewController)
    view.addSubview(tableView)
    indexViewController.didMove(toParent: self)

    let separatorView = UIView()
    separatorView.backgroundColor = .separator

    view.addSubview(separatorView)
    view.addSubview(controlsView)

    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

    separatorView.translatesAutoresizingMaskIntoConstraints = false
    separatorView.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
    separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    separatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true

    controlsView.translatesAutoresizingMaskIntoConstraints = false
    controlsView.topAnchor.constraint(equalTo: separatorView.bottomAnchor).isActive = true
    controlsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    controlsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    controlsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }

  private func update(_ action: IndexViewController.Action) {
    switch action {
    case let .showTiledDrawing(variation):
      let viewModel = TiledDrawingViewModel(
        variation: variation,
        tileForegroundColor: variation.defaultForegroundColor,
        tileBackgroundColor: variation.defaultBackgroundColor
      )
      let viewController = TiledDrawingViewController(viewModel: viewModel, animated: controlsView.animationSwitch.isOn) { [weak self] in
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
