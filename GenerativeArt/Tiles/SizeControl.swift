import UIKit

final class SizeControl: UIView {
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

struct TileSizeControl {
  private let maxCount: Int
  private let width: CGFloat

  init(boundsSize: CGSize, minWidth: CGFloat) {
    guard boundsSize.width > 0, boundsSize.height > 0, minWidth > 0 else {
      maxCount = 0
      width = 0
      return
    }
    width = min(boundsSize.width, boundsSize.height)
    maxCount = Int(width / minWidth)
  }

  /// Expects a value from 0 to 1.
  func widthForValue(_ value: CGFloat) -> CGFloat {
    guard maxCount > 1, width > 0 else { return 0 }

    let value = 1 - max(0, min(1, value))
    let range = CGFloat(maxCount - 1)
    let count = 1 + round(range * value)
    return width / count
  }

  static var empty: TileSizeControl {
    TileSizeControl(boundsSize: .zero, minWidth: 0)
  }
}
