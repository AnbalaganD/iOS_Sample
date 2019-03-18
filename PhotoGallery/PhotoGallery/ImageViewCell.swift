//
//  ImageViewCell.swift
//  PhotoGallery
//
//  Created by Admin on 05/10/18.
//  Copyright © 2018 Anbu. All rights reserved.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    
    static let Identifier = "ImageViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupData(image: UIImage?) {
        imageView.image = image
    }
}
