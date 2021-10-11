//
//  InstructorsViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/3/21.
//

import UIKit

class InstructorsViewController: UIViewController {
    
    @IBOutlet weak var instructorsCollectionView: UICollectionView!
    
    let instructor0 = Instructor(firstName: "Артем", lastName: "Малашкевич", patronymic: "Викторович", phoneNumber: "+375 (29) 358-17-24", drivingExperience: 2)
    let instructor1 = Instructor(firstName: "Сащеко", lastName: "Максим", patronymic: "Андреевич", phoneNumber: "+375 (29) 358-17-24", drivingExperience: 4)
    let instructor2 = Instructor(firstName: "Артем", lastName: "Малашкевич", patronymic: "Андреевич", phoneNumber: "+375 (29) 358-17-24", drivingExperience: 5)
    let instructor3 = Instructor(firstName: "Артем", lastName: "Малашкевич", patronymic: "Андреевич", phoneNumber: "+375 (29) 358-17-24", drivingExperience: 15)
    
    let instructorsCollectionViewInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    
    lazy var dataSource = [instructor0, instructor1, instructor2, instructor3]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        setupNavigation()
    }
    
    private func configureCollectionView() {
        instructorsCollectionView.delegate = self
        instructorsCollectionView.dataSource = self
        instructorsCollectionView.register(InstructorCell.nib(), forCellWithReuseIdentifier: InstructorCell.reuseIdentifier)
    }
    
    private func setupNavigation() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Инструкторы"
        let largeTitleAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        navigationController?.navigationBar.largeTitleTextAttributes = largeTitleAttributes
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.backward")!
        navigationController?.navigationBar.tintColor = .black
    }

}

extension InstructorsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InstructorCell.reuseIdentifier, for: indexPath) as! InstructorCell
        
        let instructor = dataSource[indexPath.item]
        cell.setup(withInstructor: instructor)
        
        return cell
    }
    
    
}

extension InstructorsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.frame.width - instructorsCollectionViewInsets.top * 2
        let itemHeight = itemWidth * 1.2
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return instructorsCollectionViewInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return instructorsCollectionViewInsets.top * 1.5

    }
}

