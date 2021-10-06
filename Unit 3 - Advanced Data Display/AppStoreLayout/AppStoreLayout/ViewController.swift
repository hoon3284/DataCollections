// command shift 영어 o : open quickly

import UIKit

class ViewController: UIViewController {
        
    // MARK: Section Definitions
    enum Section: Hashable {
        case promoted
        case standard(String)
        case categories
    }

    @IBOutlet var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Collection View Setup
        collectionView.collectionViewLayout = createLayout()
        // 보여주기 위해서는 cell을 collectionView에 등록해야하고 datasource가 셀을 반환하도록 해야한다.
        collectionView.register(PromotedAppCollectionViewCell.self, forCellWithReuseIdentifier: PromotedAppCollectionViewCell.reuseIdentifier)
        collectionView.register(StandardAppCollectionViewCell.self, forCellWithReuseIdentifier: StandardAppCollectionViewCell.reuseIdentifier)
        // dataSource가 생성되기 전에 등록해야한다.
        
        
        configureDataSource()
    }
    
    func createLayout() -> UICollectionViewLayout {
//        fatalError("TODO: Create Layout") 원래 코드.
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            // 이 UICollectionViewCompositionalLayout의 initializer는 sectionProvider를 사용한다.
            // sectionProvider는 sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment를 매개변수로 받고
            // NSCollectionLayoutSection?을 반환하는 클로져이다.
            
            let section = self.sections[sectionIndex]
            switch section {
            case .promoted:
                // MARK: Promoted Section Layout
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(1) // 이런식으로 정사각형을 표현할 수 있다.
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.92),
                    heightDimension: .estimated(300)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                // 여기서 centered는 page가 화면에 가운데 정렬하도록 설정한다.
                // .groupPaging을 사용한다면 page가 왼쪽으로 정렬된다.
                // 이외에도 다른 방법이 있다. 도큐멘트 확인 바람.
                
                return section
                
            case .standard:
                // MARK: Standard Section Layout
                let itemSzie = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(1/3)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSzie)
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 0,
                    leading: 4,
                    bottom: 0,
                    trailing: 4
                )
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.92),
                    heightDimension: .estimated(250)
                )
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitem: item,
                    count: 3
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                
                return section
            default:
                return nil
            }
        }
        return layout
    }
    
    func configureDataSource() {
//        fatalError("TODO: Create Data Source") 원래 코드.
        
        // MARK: Data Source Initialization
        dataSource = .init(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) in
            let section = self.sections[indexPath.section]
            switch section {
            case .promoted:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromotedAppCollectionViewCell.reuseIdentifier, for: indexPath) as! PromotedAppCollectionViewCell
                cell.configureCell(item.app!)
                
                return cell
                
            case .standard:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StandardAppCollectionViewCell.reuseIdentifier, for: indexPath) as! StandardAppCollectionViewCell
                let isThirdItem = (indexPath.row + 1).isMultiple(of: 3)
                cell.configureCell(item.app!, hideBottomLine: isThirdItem)
                
                return cell
            default:
                fatalError("Not yet implemented.")
            }
        })
        
        // MARK: Snapshot Definition
        // "// MARK:" 이 코멘트는 jump bar와 minimap에서 확인할 수 있게하고 빠르게 점프할 수 있게 한다.
        // Jump bar는 탭창 밑에 클릭해서 넘어가는 부분이고 minimap은 오른쪽에 미니맵이다.
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.promoted])
        snapshot.appendItems(Item.promotedApps, toSection: .promoted)
        
        let popularSection = Section.standard("Popular this week")
        let essentialSection = Section.standard("Essential picks")
        
        snapshot.appendSections([popularSection, essentialSection])
        snapshot.appendItems(Item.popularApps, toSection: popularSection)
        snapshot.appendItems(Item.essentialApps, toSection: essentialSection)
        
        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }
}

