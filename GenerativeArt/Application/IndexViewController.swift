import UIKit

struct Index {
  let sections: [Section]

  subscript (_ indexPath: IndexPath) -> DrawingType {
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
  typealias DataSource = UICollectionViewDiffableDataSource<String, DrawingType>
  typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>

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

    let sections = index.sections.map(\.title)
    var snapshot = NSDiffableDataSourceSnapshot<String, DrawingType>()
    snapshot.appendSections(sections)
    dataSource.apply(snapshot)

    for section in index.sections {
      var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<DrawingType>()
      sectionSnapshot.append(section.rows)
      dataSource.apply(sectionSnapshot, to: section.title, animatingDifferences: false)
    }
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    send(.showDrawing(index[indexPath]))
  }

  func makeDataSource() -> DataSource {
    let registration = UICollectionView.CellRegistration<UICollectionViewListCell, DrawingType> { cell, _, item in
      var configuration = cell.defaultContentConfiguration()
      configuration.text = item.title
      cell.contentConfiguration = configuration
    }
    let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
      collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
    }

    let headerRegistration = HeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] view, _, indexPath in
      guard let self = self else { return }
      let title = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
      var configuration = view.defaultContentConfiguration()
      configuration.text = title
      view.contentConfiguration = configuration
    }
    dataSource.supplementaryViewProvider = { [weak self] view, kind, indexPath in
      self?.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
    }

    return dataSource
  }
}
