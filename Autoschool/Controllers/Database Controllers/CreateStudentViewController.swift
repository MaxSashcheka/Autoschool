//
//  CreateStudentViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/1/21.
//

import UIKit

class CreateStudentViewController: UIViewController {

    
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var patronymicTextField: UITextField!
    
    
    @IBOutlet weak var passportNumberTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    
    @IBOutlet weak var groupsCollectionView: UICollectionView!
    let groupsCollectionViewInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var selectedGroupIndex = 0


    @IBOutlet weak var instructorsCollectionView: UICollectionView!
    let instructorsCollectionViewInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var selectedInstructorIndex = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить ученика"

        configureCollectionViews()
    }
    
    private func configureCollectionViews() {
        groupsCollectionView.delegate = self
        groupsCollectionView.dataSource = self
        groupsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        instructorsCollectionView.delegate = self
        instructorsCollectionView.dataSource = self
        instructorsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
    }
    

}


extension CreateStudentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == groupsCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            cell.backgroundColor = .white
            cell.layer.cornerRadius = cell.layer.frame.height / 10
            
            // Check for selection
            if indexPath.item == selectedGroupIndex {
                cell.layer.borderWidth = 3
                cell.layer.borderColor = UIColor.red.cgColor
            } else {
                cell.layer.borderWidth = 2
                cell.layer.borderColor = UIColor.darkGray.cgColor
            }
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            cell.backgroundColor = .white
            cell.layer.cornerRadius = cell.layer.frame.height / 10
            
            // Check for selection
            if indexPath.item == selectedInstructorIndex {
                cell.layer.borderWidth = 3
                cell.layer.borderColor = UIColor.red.cgColor
            } else {
                cell.layer.borderWidth = 2
                cell.layer.borderColor = UIColor.darkGray.cgColor
            }
            
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == groupsCollectionView {
            selectedGroupIndex = indexPath.item
            groupsCollectionView.reloadData()
            groupsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            selectedInstructorIndex = indexPath.item
            instructorsCollectionView.reloadData()
            instructorsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
}

extension CreateStudentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == groupsCollectionView {
            
            let itemWidth = groupsCollectionView.frame.width * 0.7
            let itemHeight = groupsCollectionView.frame.height - groupsCollectionViewInsets.top * 2
            
            return CGSize(width: itemWidth, height: itemHeight)
        } else {
            
            let itemHeight = instructorsCollectionView.frame.height - instructorsCollectionViewInsets.top * 2
            let itemWidth = itemHeight * 0.85
            
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == groupsCollectionView {
            return groupsCollectionViewInsets
        } else {
            return instructorsCollectionViewInsets
        }
    }
    
}
