//
//  CreateExamViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/5/21.
//

import UIKit

class CreateExamViewController: UIViewController {

    
    @IBOutlet weak var examDateTextField: UITextField!
    
    @IBOutlet weak var examInternalExternalSegmentedControl: UISegmentedControl!
    @IBOutlet weak var examTheoryPracticeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var groupsCollectionView: UICollectionView!
    let groupsCollectionViewInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    var selectedGroupIndex = 0
    
    lazy var examDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        datePicker.datePickerMode = UIDatePicker.Mode.date

        return datePicker
    }()
    
    var student0 = Student(firstName: "Максим", lastName: "Сащеко", patronymic: "Сащеко", passportNumber: "МР3718032", phoneNumber: "+375 (29) 358-17-24", instructorName: "Малашкевич Денисааа")
    var student1 = Student(firstName: "Артем", lastName: "Сащеко", patronymic: "Сащеко", passportNumber: "МР3718032", phoneNumber: "+375 (29) 358-17-24", instructorName: "Скурат Денис")
    var student2 = Student(firstName: "Максим", lastName: "Малашкевич", patronymic: "Сащеко", passportNumber: "МР3718032", phoneNumber: "+375 (29) 358-17-24", instructorName: "Скурат Денис")

    lazy var group = Group(name: "Группа-14", category: .AutomaticB, dayPart: .evening, startLessonsDate: "14.01.2021", endLesonnsDate: "18.02.2022", students: [student0, student1, student2,student0, student1, student2,student0, student1, student2, student0, student1, student2,])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить экзамен"
        
        configureGroupsCollectionView()
        configureSegmentedControls()
        configureTextFields()
        setupBarButtonItems()
    }
    
    private func configureGroupsCollectionView() {
        groupsCollectionView.showsHorizontalScrollIndicator = false
        groupsCollectionView.delegate = self
        groupsCollectionView.dataSource = self
        groupsCollectionView.register(GroupCell.nib(), forCellWithReuseIdentifier: GroupCell.reuseIdentifier)
    }
    
    private func configureSegmentedControls() {
        examInternalExternalSegmentedControl.selectedSegmentTintColor = .lightGreenSea
        examInternalExternalSegmentedControl.layer.borderWidth = 1
        examInternalExternalSegmentedControl.layer.borderColor = UIColor.darkGray.cgColor

        examTheoryPracticeSegmentedControl.selectedSegmentTintColor = .lightGreenSea
        examTheoryPracticeSegmentedControl.layer.borderWidth = 1
        examTheoryPracticeSegmentedControl.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    private func configureTextFields() {
        let examDateToolbar = UIToolbar()
        examDateToolbar.sizeToFit()
        let examDateDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveExamDate))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        examDateToolbar.setItems([flexSpace, examDateDoneButton], animated: true)
        
        examDateTextField.inputView = examDatePicker
        examDateTextField.inputAccessoryView = examDateToolbar
    }
    
    @objc private func saveExamDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        examDateTextField.text = formatter.string(from: examDatePicker.date)
        
        view.endEditing(true)
    }
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
    }
    
    @objc private func saveButtonHandler() {
        let alertView = SPAlertView(title: "Экзамен успешно добавлен в базу данных", preset: .done)
        alertView.present()

    }

}

extension CreateExamViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCell.reuseIdentifier, for: indexPath) as! GroupCell
    
        cell.setup(withGroup: group)
        
        // Check for selection
        if indexPath.item == selectedGroupIndex {
            cell.layer.borderWidth = 3
            cell.layer.borderColor = UIColor.systemRed.cgColor
        } else {
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.darkGray.cgColor
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedGroupIndex = indexPath.item
        groupsCollectionView.reloadData()
        groupsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
}

extension CreateExamViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = groupsCollectionView.frame.width * 0.8
        let itemHeight = groupsCollectionView.frame.height - groupsCollectionViewInsets.top * 2
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return groupsCollectionViewInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return groupsCollectionViewInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return groupsCollectionViewInsets.left
    }
}
