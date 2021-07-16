import UIKit

final class ColorPickerView: UIView {
  var didSelect: (Color) -> Void = { _ in }

  private let colorItems: [ColorPickerItem]

  init() {
    let colors: [Color] = [.black, .white, .red, .orange, .green, .yellow, .blue, .purple]
    colorItems = colors.map { ColorPickerItem(color: $0) }
    super.init(frame: .zero)

    clipsToBounds = true
    backgroundColor = .systemBackground
    layer.borderWidth = 1 / UIScreen.main.scale
    layer.borderColor = UIColor.lightGray.cgColor
    layer.cornerRadius = 24

    let stackView = UIStackView(arrangedSubviews: colorItems)
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
    stackView.spacing = 8

    for item in colorItems {
      item.addSizeConstraints(size: CGSize(width: 44, height: 44))
      item.didSelect = { [weak self, weak item] in
        guard let self = self, let item = item else { return }
        self.updateSelection(item, color: $0)
      }
    }

    let scrollView = UIScrollView()

    scrollView.addSubview(stackView)
    addSubview(scrollView)

    scrollView.addEdgeConstraints(to: self)
    scrollView.addEdgeConstraints(to: scrollView.contentLayoutGuide)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor).isActive = true
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func select(_ color: Color) {
    guard let control = colorItems.first(where: { $0.color == color }) else { return }
    select(control)
  }

  private func select(_ control: UIControl) {
    guard !control.isSelected else { return }
    for item in colorItems {
      item.isSelected = false
    }
    control.isSelected = true
  }

  private func updateSelection(_ control: UIControl, color: Color) {
    guard !control.isSelected else { return }
    select(control)
    didSelect(color)
  }
}

final class ColorPickerItem: UIControl {
  let color: Color
  override var isSelected: Bool {
    didSet { selectionLayer.isHidden = !isSelected }
  }
  var didSelect: (Color) -> Void = { _ in }

  private let colorLayer = CALayer()
  private let selectionLayer = CALayer()

  init(color: Color) {
    self.color = color
    super.init(frame: .zero)

    selectionLayer.backgroundColor = Color.selection.color().cgColor
    colorLayer.backgroundColor = color.color().cgColor

    selectionLayer.isHidden = true

    layer.addSublayer(selectionLayer)
    layer.addSublayer(colorLayer)

    if color == .white {
      colorLayer.borderWidth = 1 / UIScreen.main.scale
      colorLayer.borderColor = UIColor.lightGray.cgColor
    }
    addTarget(self, action: #selector(didTouch), for: .touchUpInside)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    let selectionFrame = bounds.insetBy(dx: -3, dy: -3)
    selectionLayer.frame = selectionFrame
    selectionLayer.cornerRadius = min(selectionFrame.size.width, selectionFrame.size.height) / 2

    colorLayer.frame = bounds
    colorLayer.cornerRadius = min(bounds.size.width, bounds.size.height) / 2
  }

  @objc private func didTouch() {
    didSelect(color)
  }
}
