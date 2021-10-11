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
    let groupsCollectionViewInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    var selectedGroupIndex = 0


    @IBOutlet weak var instructorsCollectionView: UICollectionView!
    let instructorsCollectionViewInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
    var selectedInstructorIndex = 0
    
    
    @IBOutlet weak var studentImageCollectionView: UICollectionView!
    let studentsImageCollectionViewInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
    var selectedStudentImageIndex = 0
    
    var student0 = Student(firstName: "Максим", lastName: "Сащеко", patronymic: "Сащеко", passportNumber: "МР3718032", phoneNumber: "+375 (29) 358-17-24", instructorName: "Малашкевич Денисааа")
    var student1 = Student(firstName: "Артем", lastName: "Сащеко", patronymic: "Сащеко", passportNumber: "МР3718032", phoneNumber: "+375 (29) 358-17-24", instructorName: "Скурат Денис")
    var student2 = Student(firstName: "Максим", lastName: "Малашкевич", patronymic: "Сащеко", passportNumber: "МР3718032", phoneNumber: "+375 (29) 358-17-24", instructorName: "Скурат Денис")

    lazy var group = Group(name: "Группа-14", category: .AutomaticB, dayPart: .evening, startLessonsDate: "14.01.2021", endLesonnsDate: "18.02.2022", students: [student0, student1, student2,student0, student1, student2,student0, student1, student2, student0, student1, student2,])
    
    let instructor0 = Instructor(firstName: "Артем", lastName: "Малашкевич", patronymic: "Викторович", phoneNumber: "+375 (29) 358-17-24", drivingExperience: 15)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить ученика"
        
        configureCollectionViews()
    }
    
    private func configureCollectionViews() {
        groupsCollectionView.delegate = self
        groupsCollectionView.dataSource = self
        groupsCollectionView.register(GroupCell.nib(), forCellWithReuseIdentifier: GroupCell.reuseIdentifier)
        
        instructorsCollectionView.delegate = self
        instructorsCollectionView.dataSource = self
        instructorsCollectionView.register(InstructorCell.nib(), forCellWithReuseIdentifier: InstructorCell.reuseIdentifier)
        
        studentImageCollectionView.delegate = self
        studentImageCollectionView.dataSource = self
        studentImageCollectionView.register(ImagePickerCollectionViewCell.nib(), forCellWithReuseIdentifier: ImagePickerCollectionViewCell.reuseIdentifier)
    }
    
}


extension CreateStudentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == groupsCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCell.reuseIdentifier, for: indexPath) as! GroupCell
            cell.setup(withGroup: group)
            
            // Check for selection
            if indexPath.item == selectedGroupIndex {
//                cell.layer.shadowColor = UIColor.lightGreenSea.cgColor
                cell.layer.borderWidth = 3
                cell.layer.borderColor = UIColor.lightGreenSea.cgColor
            } else {
//                cell.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
                cell.layer.borderWidth = 2
                cell.layer.borderColor = UIColor.darkGray.cgColor
            }
            
            return cell
        } else if collectionView == instructorsCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InstructorCell.reuseIdentifier, for: indexPath) as! InstructorCell
            cell.setup(withInstructor: instructor0)

            // Check for selection
            if indexPath.item == selectedInstructorIndex {
                cell.layer.borderWidth = 3
                cell.layer.borderColor = UIColor.lightGreenSea.cgColor
            } else {
                cell.layer.borderWidth = 2
                cell.layer.borderColor = UIColor.darkGray.cgColor
            }
            
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePickerCollectionViewCell.reuseIdentifier, for: indexPath) as! ImagePickerCollectionViewCell
            cell.setup(withStudent: student0)
            
            // Check for selection
            if indexPath.item == selectedStudentImageIndex {
//                cell.layer.shadowColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.65).cgColor
                cell.layer.borderWidth = 3
                cell.layer.borderColor = UIColor.lightGreenSea.cgColor

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
        } else if collectionView == instructorsCollectionView {
            selectedInstructorIndex = indexPath.item
            instructorsCollectionView.reloadData()
            instructorsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            selectedStudentImageIndex = indexPath.item
            studentImageCollectionView.reloadData()
            studentImageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
}

extension CreateStudentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == groupsCollectionView {
            let itemWidth = groupsCollectionView.frame.width * 0.8
            let itemHeight = groupsCollectionView.frame.height - groupsCollectionViewInsets.top * 2
            
            return CGSize(width: itemWidth, height: itemHeight)
        } else if collectionView == instructorsCollectionView {
            let itemWidth = instructorsCollectionView.frame.width - instructorsCollectionViewInsets.left * 6
            let itemHeight = itemWidth * 1.2
    
            return CGSize(width: itemWidth, height: itemHeight)
        } else {
            let itemWidth = studentImageCollectionView.frame.width - instructorsCollectionViewInsets.left * 6
            let itemHeight = itemWidth * 1.2
            
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == groupsCollectionView {
            return groupsCollectionViewInsets
        } else if collectionView == instructorsCollectionView {
            return instructorsCollectionViewInsets
        } else {
            return studentsImageCollectionViewInsets
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == groupsCollectionView {
            return groupsCollectionViewInsets.left
        } else if collectionView == instructorsCollectionView {
            return instructorsCollectionViewInsets.left
        } else {
            return studentsImageCollectionViewInsets.left
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == groupsCollectionView {
            return groupsCollectionViewInsets.left
        } else if collectionView == instructorsCollectionView{
            return instructorsCollectionViewInsets.left
        } else {
            return studentsImageCollectionViewInsets.left
        }
    }
}
