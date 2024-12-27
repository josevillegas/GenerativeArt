import SwiftUI

struct DrawingCanvas: View {
  let paths: [GAPath]
  let backgroundColor: Color

  var body: some View {
    Canvas { context, size in
      for gaPath in paths {
        let path = gaPath.path()
        if let fillColor = gaPath.fillColor {
          context.fill(path, with: .color(fillColor), style: FillStyle())
        }
        if let strokeColor = gaPath.strokeColor {
          context.stroke(path, with: .color(strokeColor), style: StrokeStyle(lineWidth: gaPath.lineWidth))
        }
      }
    }
    .background(backgroundColor, ignoresSafeAreaEdges: Edge.Set())
  }
}

struct TiledDrawingCanvas: View {
  let tiledDrawing: TiledDrawing
  let backgroundColor: Color

  var body: some View {
    DrawingCanvas(paths: tiledDrawing.paths, backgroundColor: backgroundColor)
      .frame(width: tiledDrawing.tiles.size.width, height: tiledDrawing.tiles.size.height)
  }
}
