
import UIKit

class StoreItemCollectionViewController: UICollectionViewController {
    
//    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
//    삭제하지만 기억해야할 건 viewDidLoad에서 view.frame.width를 사용하는데 이 값이 계속 0으로 찍힌다.
//    내 결론은 xcode13으로 바뀌면서 생긴 버그인것으로 생각되는데 혹시 나중에 또 이런 일이 있다면 보러오도록.
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(StoreItemCollectionViewSectionHeader.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: StoreItemCollectionViewSectionHeader.reuseIdentifier)
    }
    
    func configureCollctionViewLayout(for searchScope: SearchScope) {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 8, leading: 5, bottom: 8, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: searchScope.groupWidthDimension,
            heightDimension: .absolute(166)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: searchScope.groupItemCount)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = searchScope.orthogonalScrollingBehavior
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(28))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "Header", alignment: .topLeading)
        
        section.boundarySupplementaryItems = [headerItem]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView.collectionViewLayout = layout
    }
}

extension SearchScope {
    var orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior {
        switch self {
        case .all:
            return .continuousGroupLeadingBoundary
        default:
            return .none
        }
    }
    
    var groupItemCount: Int {
        switch self {
        case .all:
            return 1
        default:
            return 3
        }
    }
    
    var groupWidthDimension: NSCollectionLayoutDimension {
        switch self {
        case .all:
            return .fractionalWidth(1/3)
        default:
            return .fractionalWidth(1.0)
        }
    }
}
