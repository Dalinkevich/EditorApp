//
//  FilterCell.swift
//  EditerApp
//
//  Created by Роман далинкевич on 22.12.2021.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    //MARK: Outlets:
    @IBOutlet var previewImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    var previewImage: UIImage? {
        didSet {
            previewImageView.image = previewImage
        }
    }
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
}
