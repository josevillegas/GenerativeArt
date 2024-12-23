import UIKit

final class UISizeControl: UIView {
  enum Message {
    case valueDidChange(CGFloat)
  }

  var send: (Message) -> Void = { _ in }

  private let slider = UISlider()
  private var lastValue: CGFloat = 0

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
    slider.addEdgeConstraints(to: self, insets: UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))

    slider.addTarget(self, action: #selector(valueDidChange), for: .valueChanged)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc private func valueDidChange() {
    let value = CGFloat(slider.value)
    if value == lastValue { return }
    lastValue = value
    send(.valueDidChange(value))
  }
}
