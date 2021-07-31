import UIKit

struct Index {
  let sections: [Section]

  subscript(indexPath: IndexPath) -> DrawingType {
    sections[indexPath.section].rows[indexPath.row]
  }
}

extension Index {
  struct Section: Hashable {
    let title: String
    let rows: [DrawingType]
  }
}

class IndexViewController: UICollectionViewController {
  typealias DataSource = UICollectionViewDiffableDataSource<Index.Section, DrawingType>
  typealias CellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, DrawingType>
  typealias SupplementaryRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>

  private let index: Index
  private let send: (Message) -> ()
  private lazy var dataSource: DataSource = { makeDataSource() }()

  init(index: Index, appearance: UICollectionLayoutListConfiguration.Appearance, send: @escaping (Message) -> ()) {
    self.index = index
    self.send = send

    var configuration = UICollectionLayoutListConfiguration(appearance: appearance)
    configuration.headerMode = .supplementary

    super.init(collectionViewLayout: UICollectionViewCompositionalLayout.list(using: configuration))

    title = "Generative Art"
    navigationItem.largeTitleDisplayMode = .always
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    applySnapshot()
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    send(.showDrawing(index[indexPath]))
  }

  func applySnapshot() {
    var snapshot = NSDiffableDataSourceSnapshot<Index.Section, DrawingType>()
    for section in index.sections {
      snapshot.appendSections([section])
      snapshot.appendItems(section.rows)
    }
    dataSource.apply(snapshot, animatingDifferences: false)
  }

  func makeDataSource() -> DataSource {
    let cellRegistration = CellRegistration { cell, _, item in
      var configuration = UIListContentConfiguration.cell()
      configuration.text = item.title
      cell.contentConfiguration = configuration
    }
    let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
      collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
    }

    let headerRegistration = SupplementaryRegistration(elementKind: "header") { [weak self] view, _, indexPath in
      guard let self = self else { return }
      var configuration = UIListContentConfiguration.groupedHeader()
      configuration.text = self.index.sections[indexPath.section].title
      view.contentConfiguration = configuration
    }
    dataSource.supplementaryViewProvider = { [weak self] view, _, indexPath in
      self?.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
    }

    return dataSource
  }
}
