//
//  CreateExamViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/5/21.
//

import UIKit

class CreateExamViewController: UIViewController {
    
    var groups = [Group]()
    var teachers = [Teacher]()

    @IBOutlet weak var examDateTextField: UITextField!
    
    @IBOutlet weak var examInternalExternalSegmentedControl: UISegmentedControl!
    @IBOutlet weak var examTheoryPracticeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var groupsCollectionView: UICollectionView!
    let groupsCollectionViewInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    var selectedGroupIndex = 0
    
    lazy var examDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        datePicker.datePickerMode = UIDatePicker.Mode.date

        return datePicker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить экзамен"
        view.backgroundColor = UIColor.viewBackground

        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        
        configureGroupsCollectionView()
        configureSegmentedControls()
        configureTextFields()
        setupBarButtonItems()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NetworkManager.shared.fetchGroups { fetchedGroups in
            self.groups = fetchedGroups
            self.groupsCollectionView.reloadData()
        }
        NetworkManager.shared.fetchTeacher { fetchedTeachers in
            self.teachers = fetchedTeachers
            self.groupsCollectionView.reloadData()
        }
    }
    
    private func configureGroupsCollectionView() {
        groupsCollectionView.showsHorizontalScrollIndicator = false
        groupsCollectionView.delegate = self
        groupsCollectionView.dataSource = self
        groupsCollectionView.register(GroupCollectionViewCell.nib(), forCellWithReuseIdentifier: GroupCollectionViewCell.reuseIdentifier)
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
        formatter.dateFormat = "yyyy.MM.dd"
        examDateTextField.text = formatter.string(from: examDatePicker.date)
        
        view.endEditing(true)
    }
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
    }
    
    @objc private func saveButtonHandler() {
        let successAlertView = SPAlertView(title: "Экзамен успешно добавлен в базу данных", preset: .done)
        let failureAlertView = SPAlertView(title: "Не удалось добавить экзамен в базу данных", message: "Вы заполнили не все поля", preset: .error)
        
        guard let examDateString = examDateTextField.text, examDateString != "" else {
            failureAlertView.present()
            return
        }
        
        let selectedGroupId = groups[selectedGroupIndex].groupId
        var selectedExamTypeId = 1
        if examInternalExternalSegmentedControl.selectedSegmentIndex == 0 {
            if examTheoryPracticeSegmentedControl.selectedSegmentIndex == 0 {
                selectedExamTypeId = 1
            } else {
                selectedExamTypeId = 2
            }
        } else {
            if examTheoryPracticeSegmentedControl.selectedSegmentIndex == 0 {
                selectedExamTypeId = 3
            } else {
                selectedExamTypeId = 4
            }
        }
        let exam = Exam(examId: 0, date: examDateString, examTypeId: selectedExamTypeId, examType: ExamType(), groupId: selectedGroupId)
        NetworkManager.shared.postExam(exam)
        successAlertView.present()

    }

}

extension CreateExamViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCollectionViewCell.reuseIdentifier, for: indexPath) as! GroupCollectionViewCell
    
//        let group = groups[indexPath.item]
//        for teacher in teachers {
//            if group.teacherId == teacher.teacherId {
//                
//            }
//        }
//        cell.setup(withGroup: group)
        
        cell.layer.borderColor = UIColor.red.cgColor
        if indexPath.item == selectedGroupIndex {
            cell.layer.borderWidth = 1
        } else {
            cell.layer.borderWidth = 0
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
//        let itemWidth = groupsCollectionView.frame.width - groupsCollectionViewInsets.left * 2
//        let itemHeight = itemWidth / 2
        let itemWidth = groupsCollectionView.frame.width * 0.8
        let itemHeight = groupsCollectionView.frame.height - 20
        
        
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

extension CreateExamViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreateExamViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view!.isDescendant(of: groupsCollectionView) {
            return false
        }
        return true
    }
}

