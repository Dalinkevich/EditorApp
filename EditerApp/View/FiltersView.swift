//
//  FiltersView.swift
//  EditerApp
//
//  Created by Роман далинкевич on 23.12.2021.
//

import Foundation
import UIKit

class FiltersView: UIView {
    
    //MARK: Outlets:
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var assetStore: AssetStoreProtocol?
    
    private var filters = FiltersFabric.getFilters()

    private lazy var previewImages = [UIImage?](repeating: UIImage(), count: filters.count)
    
    //MARK: Setup function
    func setup(with assetStore: AssetStoreProtocol) {
        self.assetStore = assetStore
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //MARK: Update function
    func update() {
        guard let assetStore = assetStore else { return }
        previewImages = assetStore.getPreviewImages(filters: filters)
        collectionView.reloadData()
    }
}

//MARK: CollectionViewDelegate
extension FiltersView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? FilterCell {
            cell.nameLabel.textColor = .red
        }
        assetStore?.apply(filter: filters[indexPath.item])
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? FilterCell {
            cell.nameLabel.textColor = .white
        }
    }
}

//MARK: CollectionViewDataSource
extension FiltersView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath)
        if let cell = cell as? FilterCell {
            cell.previewImage = previewImages[indexPath.item]
            cell.name = filters[indexPath.item].name
        }
        return cell
    }
}



