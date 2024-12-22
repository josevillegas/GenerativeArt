import UIKit

struct IndexSection: Hashable {
  let title: String
  let rows: [DrawingType]
}

enum IndexAppearance {
  case insetGrouped
  case sidebar
}

class IndexViewController: UICollectionViewController {
  typealias DataSource = UICollectionViewDiffableDataSource<IndexSection, DrawingType>
  typealias CellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, DrawingType>
  typealias SupplementaryRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>

  private let sections: [IndexSection]
  private let send: (Message) -> ()
  private let appearance: IndexAppearance
  private lazy var dataSource: DataSource = { makeDataSource() }()

  init(sections: [IndexSection], appearance: IndexAppearance, send: @escaping (Message) -> ()) {
    self.sections = sections
    self.send = send
    self.appearance = appearance

    var configuration = UICollectionLayoutListConfiguration(appearance: appearance.systemAppearance)
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
    send(.showDrawing(sections[indexPath.section].rows[indexPath.row]))
  }

  func applySnapshot() {
    var snapshot = NSDiffableDataSourceSnapshot<IndexSection, DrawingType>()
    for section in sections {
      snapshot.appendSections([section])
      snapshot.appendItems(section.rows)
    }
    dataSource.apply(snapshot, animatingDifferences: false)
  }

  func makeDataSource() -> DataSource {
    let cellRegistration = CellRegistration { [appearance] cell, _, item in
      var configuration = appearance.cellConfiguration()
      configuration.text = item.title
      cell.contentConfiguration = configuration
      cell.accessories = appearance.accessories()
    }
    let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
      collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
    }

    let headerKind = UICollectionView.elementKindSectionHeader
    let headerRegistration = SupplementaryRegistration(elementKind: headerKind) { [weak self] view, _, indexPath in
      guard let self = self else { return }
      var configuration = self.appearance.headerConfiguration()
      configuration.text = self.sections[indexPath.section].title
      view.contentConfiguration = configuration
    }
    dataSource.supplementaryViewProvider = { [weak self] view, _, indexPath in
      self?.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
    }

    return dataSource
  }
}

extension IndexAppearance {
  var systemAppearance: UICollectionLayoutListConfiguration.Appearance {
    switch self {
    case .insetGrouped: return .insetGrouped
    case .sidebar: return .sidebar
    }
  }

  func cellConfiguration() -> UIListContentConfiguration {
    switch self {
    case .insetGrouped: return UIListContentConfiguration.cell()
    case .sidebar: return UIListContentConfiguration.sidebarCell()
    }
  }

  func headerConfiguration() -> UIListContentConfiguration {
    switch self {
    case .insetGrouped: return UIListContentConfiguration.groupedHeader()
    case .sidebar: return UIListContentConfiguration.sidebarHeader()
    }
  }

  func accessories() -> [UICellAccessory] {
    switch self {
    case .insetGrouped: return [.disclosureIndicator()]
    case .sidebar: return []
    }
  }
}
