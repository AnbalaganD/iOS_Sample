//
//  ViewController.swift
//  PhotoGallery
//
//  Created by Admin on 03/10/18.
//  Copyright © 2018 Anbu. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    private var imageManager: PHImageManager?
    private var photoList: PHFetchResult<PHAsset>?
    private let itemSpacing:CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: any UIViewControllerTransitionCoordinator
    ) {
        photoCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func initialSetup() {
        imageManager = PHImageManager()
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            if status == PHAuthorizationStatus.authorized {
                DispatchQueue.main.async {
                    self.getAllPhotos()
                }
            }
        }
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
    }
    
    private func getAllPhotos() {
        photoList = PHAsset.fetchAssets(with: .image, options: nil)
        photoCollectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageViewCell.Identifier,
            for: indexPath
        ) as! ImageViewCell

        imageManager?.requestImage(
            for: photoList![indexPath.row],
            targetSize: CGSize(width:160, height:160),
            contentMode: PHImageContentMode.aspectFit,
            options: nil
        ) {[weak cell] image, info in
            DispatchQueue.main.async {
                cell?.setupData(image: image)
            }
        }
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let itemPerRow: CGFloat = UIDevice.current.orientation.isLandscape ? 7 : 4
        let padding = itemPerRow > 2 ? (itemPerRow - 1) * itemSpacing : 0
        let widthPerItem = (collectionView.frame.size.width - padding) / itemPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        shouldShowMenuForItemAt indexPath: IndexPath
    ) -> Bool {
        return true
    }
}
