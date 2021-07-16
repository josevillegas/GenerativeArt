import UIKit

final class SizeControl: UIView {
  enum Action {
    case valueDidChange(CGFloat)
  }

  var perform: (Action) -> Void = { _ in }

  private let slider = UISlider()
  private var lastValue: CGFloat = 0

  init() {
    super.init(frame: .zero)

    backgroundColor = .systemBackground
    layer.borderWidth = 1 / UIScreen.main.scale
    layer.borderColor = UIColor.lightGray.cgColor
    layer.cornerRadius = 12

    slider.setContentCompressionResistancePriority(.required, for: .vertical)

    addSubview(slider)

    slider.translatesAutoresizingMaskIntoConstraints = false
    slider.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
    slider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    slider.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
    slider.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true

    slider.addTarget(self, action: #selector(valueDidChange), for: .valueChanged)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(min: CGFloat, max: CGFloat) {
    slider.minimumValue = Float(min)
    slider.maximumValue = Float(max)
  }

  @objc private func valueDidChange() {
    let value = CGFloat(slider.value)
    if value == lastValue { return }
    lastValue = value
    perform(.valueDidChange(value))
  }
}
