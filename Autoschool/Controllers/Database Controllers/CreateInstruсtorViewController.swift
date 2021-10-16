//
//  CreateInstruktorViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/1/21.
//

import UIKit

class CreateInstruсtorViewController: UIViewController {

    var studentExample = Student(firstName: "Максим", lastName: "Сащеко", patronymic: "Сащеко", passportNumber: "МР3718032", phoneNumber: "+375 (29) 358-17-24", instructorName: "Малашкевич Денисааа")

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить инструктора"
        
        setupBarButtonItems()
    }
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
    }
    
    @objc private func saveButtonHandler() {
        
    }
    
    

}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

//extension CreateInstruсtorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 8
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePickerCollectionViewCell.reuseIdentifier, for: indexPath) as! ImagePickerCollectionViewCell
//        cell.setup(withStudent: studentExample)
//
//        if indexPath.item == selectedInstructorImageIndex {
//            cell.layer.shadowColor = UIColor.lightGreenSea.cgColor
//        } else {
//            cell.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//        }
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedInstructorImageIndex = indexPath.item
//        collectionView.reloadData()
//        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//    }
//
//}
//
//// MARK: - UICollectionViewDelegateFlowLayout
//
//extension CreateInstruсtorViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemWidth = instructorImageCollectionView.frame.width - instructorImageCollectionViewInsets.left * 6
//        let itemHeight = itemWidth * 1.2
//
//        return CGSize(width: itemWidth, height: itemHeight)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return instructorImageCollectionViewInsets
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return instructorImageCollectionViewInsets.left
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return instructorImageCollectionViewInsets.left
//    }
//}
