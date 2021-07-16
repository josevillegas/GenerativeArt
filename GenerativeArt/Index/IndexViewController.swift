import UIKit

class IndexViewController: UITableViewController {
  enum Action {
    case showTiledDrawing(TiledDrawingType)
    case showMondrian
  }

  enum Row {
    case tiledDrawing(TiledDrawingType)
    case mondrian

    var title: String {
      switch self {
      case let .tiledDrawing(variation): return variation.title
      case .mondrian: return "Mondrian"
      }
    }
  }

  private let perform: (Action) -> ()

  private let rows: [Row] = [
    .tiledDrawing(.tiledLines),
    .tiledDrawing(.kellyTiles1),
    .tiledDrawing(.kellyTiles2),
    .tiledDrawing(.kellyTiles3),
    .tiledDrawing(.scribbles),
    .tiledDrawing(.concentricShapes),
    .mondrian
  ]

  init(perform: @escaping (Action) -> ()) {
    self.perform = perform
    super.init(style: .plain)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    navigationController?.setToolbarHidden(false, animated: false)
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rows.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    if indexPath.row < rows.count {
      cell.textLabel?.text = rows[indexPath.row].title
    }
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.row < rows.count else { return }
    switch rows[indexPath.row] {
    case let .tiledDrawing(type): perform(.showTiledDrawing(type))
    case .mondrian: perform(.showMondrian)
    }
  }
}
