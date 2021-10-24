//
//  UICollectionViewDiffableDataSource+ViewModel.swift
//  Habits
//
//  Created by wickedRun on 2021/10/20.
//

import UIKit

extension UICollectionViewDiffableDataSource {
    func applySnapshotUsing(sectionIDs: [SectionIdentifierType], itemsBySection: [SectionIdentifierType: [ItemIdentifierType]], sectionsRetainedIfEmpty: Set<SectionIdentifierType> = Set<SectionIdentifierType>()) {
        applySnapshotUsing(sectionIDs: sectionIDs, itemsBySection: itemsBySection, animatingDifferences: true, sectionsRetainedIfEmpty: sectionsRetainedIfEmpty)
    }
    
    func applySnapshotUsing(sectionIDs: [SectionIdentifierType], itemsBySection: [SectionIdentifierType: [ItemIdentifierType]], animatingDifferences: Bool, sectionsRetainedIfEmpty: Set<SectionIdentifierType> = Set<SectionIdentifierType>()) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()
        
        for sectionID in sectionIDs {
            guard let sectionItems = itemsBySection[sectionID], sectionItems.count > 0 || sectionsRetainedIfEmpty.contains(sectionID) else {
                continue
            }
            
            snapshot.appendSections([sectionID])
            snapshot.appendItems(sectionItems, toSection: sectionID)
            // reload해주는 이유는 값은 바꼈으나, dataSource가 가지고 있는 cell들의 text들은 그대로라서 강제로 reload해주어 text들을 혹은 순서들을 새로고침함.
            snapshot.reloadItems(sectionItems)
        }
        
        self.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
