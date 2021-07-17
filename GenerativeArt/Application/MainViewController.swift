import UIKit

final class MainViewController: UIViewController {
  private let controlsView = MainControlsView()
  private let send: (Message) -> ()

  init(send: @escaping (Message) -> ()) {
    self.send = send
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

    let indexViewController = IndexViewController(send: send)
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
