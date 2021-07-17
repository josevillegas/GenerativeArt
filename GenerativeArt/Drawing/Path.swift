import UIKit

struct Path {
  let fillColor: UIColor?
  let strokeColor: UIColor?
  let lineWidth: CGFloat
  let commands: [Command]

  init(fillColor: UIColor? = nil, strokeColor: UIColor? = nil, lineWidth: CGFloat = 1, commands: [Command]) {
    self.fillColor = fillColor
    self.strokeColor = strokeColor
    self.lineWidth = lineWidth
    self.commands = commands
  }
}

extension Path {
  enum Command {
    case moveTo(CGPoint)
    case addLineTo(CGPoint)
    case addArc(Arc)
    case addBezierCurve(BezierCurve)
    case addShape(Shape)
    case close

    static func moveTo(_ x: CGFloat, _ y: CGFloat) -> Command {
      .moveTo(CGPoint(x: x, y: y))
    }

    static func addLineTo(_ x: CGFloat, _ y: CGFloat) -> Command {
      .addLineTo(CGPoint(x: x, y: y))
    }

    static func addRect(_ rect: CGRect) -> Command {
      .addShape(.rect(rect))
    }
  }

  enum Shape {
    case oval(CGRect)
    case rect(CGRect)
    case roundedRect(CGRect, radius: CGFloat)
  }

  // `startAngle` and `endAngle` are in degrees.
  struct Arc {
    let center: CGPoint
    let radius: CGFloat
    let startAngle: CGFloat
    let endAngle: CGFloat
    let clockWise: Bool
  }

  struct BezierPoint {
    let position: CGPoint
    let control: CGPoint
  }

  struct BezierCurve {
    let start: BezierPoint
    let end: BezierPoint
  }
}
