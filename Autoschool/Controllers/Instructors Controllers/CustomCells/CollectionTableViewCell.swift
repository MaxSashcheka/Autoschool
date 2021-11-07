//
//  CollectionTableViewCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 11/7/21.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CollectionTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    var models = [Model]()

    @IBOutlet weak var itemsCollectionView: UICollectionView!
    let itemsCollectionViewInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        itemsCollectionView.register(ItemCollectionViewCell.nib(), forCellWithReuseIdentifier: ItemCollectionViewCell.reuseIdentifier)
        backgroundColor = .clear
    }
    
    func setup(withModels models: [Model]) {
        self.models = models
    }

}

//if indexPath.row == 0 {
//    let carParkViewController = CarParkViewController()
//    navigationController?.pushViewController(carParkViewController, animated: true)
//} else if indexPath.row == 1 {
//    let driverLicensesViewController = DriverLicensesViewController()
//    navigationController?.pushViewController(driverLicensesViewController, animated: true)
//} else {
//    let teachersViewController = TeachersViewController()
//    navigationController?.pushViewController(teachersViewController, animated: true)
//}

extension CollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.reuseIdentifier, for: indexPath) as! ItemCollectionViewCell
        
        let model = models[indexPath.row]
        cell.setup(withModel: model)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
    }
    
}

extension CollectionTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 185)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return itemsCollectionViewInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemsCollectionViewInsets.left

    }
}
