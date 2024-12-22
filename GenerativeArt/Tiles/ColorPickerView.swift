import UIKit

final class ColorPickerView: UIView {
  var didSelect: (GAColor) -> Void = { _ in }

  private let colorItems: [ColorPickerItem]

  init() {
    let colors: [GAColor] = [.black, .white, .red, .orange, .green, .yellow, .blue, .purple]
    colorItems = colors.map { ColorPickerItem(color: $0) }
    super.init(frame: .zero)

    clipsToBounds = true
    backgroundColor = .tertiarySystemBackground
    layer.borderWidth = 1 / UIScreen.main.scale
    layer.borderColor = UIColor.opaqueSeparator.cgColor
    layer.cornerRadius = 12

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
    scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

    addSubview(scrollView)
    scrollView.addSubview(stackView)

    scrollView.addEdgeConstraints(to: self)
    stackView.addEdgeConstraints(to: scrollView.contentLayoutGuide)
    stackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor).isActive = true
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func select(_ color: GAColor) {
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

  private func updateSelection(_ control: UIControl, color: GAColor) {
    guard !control.isSelected else { return }
    select(control)
    didSelect(color)
  }
}

final class ColorPickerItem: UIControl {
  let color: GAColor
  override var isSelected: Bool {
    didSet { selectionLayer.isHidden = !isSelected }
  }
  var didSelect: (GAColor) -> Void = { _ in }

  private let colorLayer = CALayer()
  private let selectionLayer = CALayer()

  init(color: GAColor) {
    self.color = color
    super.init(frame: .zero)

    selectionLayer.backgroundColor = GAColor.selection.color().cgColor
    // The cgColor isn't correct if we get it from a Color.
    colorLayer.backgroundColor = UIColor(color.color()).cgColor

    selectionLayer.isHidden = true

    layer.addSublayer(selectionLayer)
    layer.addSublayer(colorLayer)

    if color == .white {
      colorLayer.borderWidth = 1 / UIScreen.main.scale
      colorLayer.borderColor = UIColor.opaqueSeparator.cgColor
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
