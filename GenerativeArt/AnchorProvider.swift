import UIKit

protocol AnchorProvider {
  var topAnchor: NSLayoutYAxisAnchor { get }
  var bottomAnchor: NSLayoutYAxisAnchor { get }
  var leftAnchor: NSLayoutXAxisAnchor { get }
  var rightAnchor: NSLayoutXAxisAnchor { get }
  var widthAnchor: NSLayoutDimension { get }
  var heightAnchor: NSLayoutDimension { get }
  var centerXAnchor: NSLayoutXAxisAnchor { get }
  var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: AnchorProvider {}
extension UILayoutGuide: AnchorProvider {}

extension AnchorProvider {
  func addSizeConstraints(size: CGSize) {
    widthAnchor.constraint(equalToConstant: size.width).isActive = true
    heightAnchor.constraint(equalToConstant: size.height).isActive = true
  }

  func addEdgeConstraints(to anchorProvider: AnchorProvider, insets: UIEdgeInsets = .zero) {
    (self as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
    topAnchor.constraint(equalTo: anchorProvider.topAnchor, constant: insets.top).isActive = true
    bottomAnchor.constraint(equalTo: anchorProvider.bottomAnchor, constant: insets.bottom).isActive = true
    leftAnchor.constraint(equalTo: anchorProvider.leftAnchor, constant: insets.left).isActive = true
    rightAnchor.constraint(equalTo: anchorProvider.rightAnchor, constant: insets.right).isActive = true
  }

  func addEdgeConstraints(to anchorProvider: AnchorProvider, margin: CGFloat) {
    addEdgeConstraints(to: anchorProvider, insets: UIEdgeInsets(top: margin, left: margin, bottom: -margin, right: -margin))
  }

  func center(with anchorProvider: AnchorProvider) {
    (self as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
    centerXAnchor.constraint(equalTo: anchorProvider.centerXAnchor).isActive = true
    centerYAnchor.constraint(equalTo: anchorProvider.centerYAnchor).isActive = true
  }
}
