//
//  UpdateExamViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/5/21.
//

import UIKit

class UpdateExamViewController: UIViewController {
    
    var groups = [Group]()
    var teachers = [Teacher]()
    
    var selectedExam: Exam!

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
    
}

// MARK: - ViewController overrides

extension UpdateExamViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.shared.fetchGroups { fetchedGroups in
            self.groups = fetchedGroups
            self.fillExamInfo()

            self.groupsCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Изменить экзамен"
        view.backgroundColor = UIColor.viewBackground

        setupGroupsCollectionView()
        setupSegmentedControls()
        setupTextFields()
        setupTapGesture()
        setupBarButtonItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        groupsCollectionView.scrollToItem(at: IndexPath(item: selectedGroupIndex, section: 0), at: [.centeredVertically, .centeredHorizontally], animated: false)
//        groupsCollectionView.contentOffset = .init(x: CGFloat(selectedGroupIndex) * groupsCollectionView.frame.width * 0.8, y: 0)
    }
    
}

// MARK: - Private interface

private extension UpdateExamViewController {
    
    func fillExamInfo() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let endOfDate = String.Index(encodedOffset: 9)
        let stringDate = String(selectedExam.date[...endOfDate])
        let date = dateFormatter.date(from: stringDate)!
        examDatePicker.date = date
        examDateTextField.text = dateFormatter.string(from: date)
        
        for index in groups.indices {
            if selectedExam.groupId == groups[index].groupId {
                selectedGroupIndex = index
                break
            }
        }
        
        switch selectedExam.examTypeId {
        case 1:
            examInternalExternalSegmentedControl.selectedSegmentIndex = 0
            examTheoryPracticeSegmentedControl.selectedSegmentIndex = 0
        case 2:
            examInternalExternalSegmentedControl.selectedSegmentIndex = 0
            examTheoryPracticeSegmentedControl.selectedSegmentIndex = 1
        case 3:
            examInternalExternalSegmentedControl.selectedSegmentIndex = 1
            examTheoryPracticeSegmentedControl.selectedSegmentIndex = 0
        case 4:
            examInternalExternalSegmentedControl.selectedSegmentIndex = 1
            examTheoryPracticeSegmentedControl.selectedSegmentIndex = 1
        default:
            print("Error")
        }
    }
    
    func setupGroupsCollectionView() {
        groupsCollectionView.showsHorizontalScrollIndicator = false
        groupsCollectionView.delegate = self
        groupsCollectionView.dataSource = self
        groupsCollectionView.register(GroupCollectionViewCell.nib(), forCellWithReuseIdentifier: GroupCollectionViewCell.reuseIdentifier)
    }
    
    func setupSegmentedControls() {
        examInternalExternalSegmentedControl.selectedSegmentTintColor = .lightGreenSea
        examInternalExternalSegmentedControl.layer.borderWidth = 1
        examInternalExternalSegmentedControl.layer.borderColor = UIColor.darkGray.cgColor

        examTheoryPracticeSegmentedControl.selectedSegmentTintColor = .lightGreenSea
        examTheoryPracticeSegmentedControl.layer.borderWidth = 1
        examTheoryPracticeSegmentedControl.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func setupTextFields() {
        let examDateToolbar = UIToolbar()
        examDateToolbar.sizeToFit()
        let examDateDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveExamDate))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        examDateToolbar.setItems([flexSpace, examDateDoneButton], animated: true)
        
        examDateTextField.inputView = examDatePicker
        examDateTextField.inputAccessoryView = examDateToolbar
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
    }
    
    func setupBarButtonItems() {
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
        let deleteExamItem = UIBarButtonItem(title: "Удалить", style: .plain, target: self, action: #selector(deleteExamHandler))
        deleteExamItem.tintColor = .systemRed
        navigationItem.rightBarButtonItems = [saveItem, deleteExamItem]
    }

    @objc func saveExamDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        examDateTextField.text = formatter.string(from: examDatePicker.date)
        
        view.endEditing(true)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func deleteExamHandler() {
        NetworkManager.shared.deleteExam(withId: selectedExam.examId)
        navigationController?.popViewController(animated: true)
    }

    @objc func saveButtonHandler() {
        let successAlertView = SPAlertView(title: "Экзамен успешно обновлен в базе данных", preset: .done)
        let failureAlertView = SPAlertView(title: "Не удалось обновить экзамен в базе данных", message: "Вы заполнили не все поля", preset: .error)
        
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
        let exam = Exam(examId: selectedExam.examId, date: examDateString, examTypeId: selectedExamTypeId, examType: ExamType(), groupId: selectedGroupId)
        NetworkManager.shared.updateExam(exam)
        successAlertView.present()

    }

}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension UpdateExamViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCollectionViewCell.reuseIdentifier, for: indexPath) as! GroupCollectionViewCell
    
        let group = groups[indexPath.item]
        cell.setup(withGroup: group)
        
        if indexPath.item == selectedGroupIndex {
            cell.setSelectedState()
        } else {
            cell.setUnselectedState()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedGroupIndex = indexPath.item
        groupsCollectionView.reloadData()
        groupsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension UpdateExamViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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

// MARK: - UITextFieldDelegate

extension UpdateExamViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location > 32 { return false }
        return true
    }
}

// MARK: - UIGestureRecognizerDelegate

extension UpdateExamViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view!.isDescendant(of: groupsCollectionView) {
            return false
        }
        return true
    }
}

