import UIKit

final class SizeControl: UIView {
  enum Message {
    case valueDidChange(CGFloat)
  }

  var send: (Message) -> Void = { _ in }

  private let slider = UISlider()
  private var lastValue: CGFloat = 0
  private var min: CGFloat = 0
  private var max: CGFloat = 1

  init() {
    super.init(frame: .zero)

    slider.minimumValue = 0
    slider.maximumValue = 1

    backgroundColor = .tertiarySystemBackground
    layer.borderWidth = 1 / UIScreen.main.scale
    layer.borderColor = UIColor.opaqueSeparator.cgColor
    layer.cornerRadius = 12

    slider.setContentCompressionResistancePriority(.required, for: .vertical)

    addSubview(slider)
    slider.addEdgeConstraints(to: self, insets: UIEdgeInsets(top: 8, left: 12, bottom: -8, right: -12))

    slider.addTarget(self, action: #selector(valueDidChange), for: .valueChanged)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(min: CGFloat, max: CGFloat) {
    self.min = min
    self.max = max
  }

  @objc private func valueDidChange() {
    let value = currentValue()
    if value == lastValue { return }
    lastValue = value
    send(.valueDidChange(value))
  }

  private func currentValue() -> CGFloat {
    let sliderValue = CGFloat(slider.value)
    // y = - log(-.2(x - 5)) gives us a good curve with (5, 3) max coordinates.
    // We normalize the max coordinates with `x = sliderValue * 5` and dividing by 3 at the end.
    let y = -log(-0.2 * (sliderValue * 5 - 5)) / 3
    return min + (max - min) * Swift.min(1, y)
  }
}
