//
//  UpdateGroupViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/1/21.
//

import UIKit

class UpdateGroupViewController: UIViewController {
    
    var teachers = [Teacher]()
    
    var selectedGroup: Group!

    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    @IBOutlet weak var drivingCategorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var lessonsTimeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var teachersTableView: UITableView!
    @IBOutlet weak var teachersTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var teachersSuperViewHeight: NSLayoutConstraint!
    var selectedTeacherIndex = 0
    
    lazy var startLessonsDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        datePicker.datePickerMode = UIDatePicker.Mode.date

        return datePicker
    }()
    
    lazy var endLessonsDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        datePicker.datePickerMode = UIDatePicker.Mode.date

        return datePicker
    }()

}

// MARK: - ViewController overrides

extension UpdateGroupViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.shared.fetchTeacher { fetchedTeachers in
            self.teachers = fetchedTeachers
            self.teachersTableViewHeight.constant = CGFloat(self.teachers.count) * self.teachersTableView.rowHeight + 10
            self.teachersSuperViewHeight.constant = self.teachersTableViewHeight.constant + 20
            self.fillGroupInfo()
            self.teachersTableView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Изменить группу"
        view.backgroundColor = UIColor.viewBackground
        
        fillGroupInfo()
        setupTeachersTableView()
        setupSegmentedControls()
        setupTextFields()
        setupTapGesture()
        setupBarButtonItems()
    }
    
}

// MARK: - Private interface

private extension UpdateGroupViewController {
    
    func fillGroupInfo() {
        groupNameTextField.text = selectedGroup.name
        switch selectedGroup.categoryId {
        case 1: drivingCategorySegmentedControl.selectedSegmentIndex = 0
        case 2: drivingCategorySegmentedControl.selectedSegmentIndex = 1
        case 3: drivingCategorySegmentedControl.selectedSegmentIndex = 2
        default: print("Error")
        }
        
        switch selectedGroup.lessonsTimeId {
        case 1: lessonsTimeSegmentedControl.selectedSegmentIndex = 0
        case 2: lessonsTimeSegmentedControl.selectedSegmentIndex = 1
        case 3: lessonsTimeSegmentedControl.selectedSegmentIndex = 2
        default: print("Error")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let endOfDate = String.Index(encodedOffset: 9)
        
        let lessonsStartStringDate = String(selectedGroup.lessonsStartDate[...endOfDate])
        let lessonsStartDate = dateFormatter.date(from: lessonsStartStringDate)!
        startLessonsDatePicker.date = lessonsStartDate
        startDateTextField.text = dateFormatter.string(from: lessonsStartDate)
        
        let lessonsEndStringDate = String(selectedGroup.lessonsEndDate[...endOfDate])
        let lessonsEndDate = dateFormatter.date(from: lessonsEndStringDate)!
        endLessonsDatePicker.date = lessonsEndDate
        endDateTextField.text = dateFormatter.string(from: lessonsEndDate)
        
        for index in teachers.indices {
            if selectedGroup.teacherId == teachers[index].teacherId {
                selectedTeacherIndex = index
                break
            }
        }
        
    }
    
    func setupTeachersTableView() {
        teachersTableView.delegate = self
        teachersTableView.dataSource = self
        teachersTableView.register(TeacherTableViewCell.nib(), forCellReuseIdentifier: TeacherTableViewCell.reuseIdentifier)
        teachersTableView.rowHeight = 75
        teachersTableView.isScrollEnabled = false
        teachersTableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        teachersTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func setupSegmentedControls() {
        drivingCategorySegmentedControl.selectedSegmentTintColor = .lightGreenSea
        drivingCategorySegmentedControl.layer.borderWidth = 1
        drivingCategorySegmentedControl.layer.borderColor = UIColor.darkGray.cgColor
        
        lessonsTimeSegmentedControl.selectedSegmentTintColor = .lightGreenSea
        lessonsTimeSegmentedControl.layer.borderWidth = 1
        lessonsTimeSegmentedControl.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func setupTextFields() {
        let startDateToolbar = UIToolbar()
        startDateToolbar.sizeToFit()
        let startDateDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveStartDate))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        startDateToolbar.setItems([flexSpace, startDateDoneButton], animated: true)
        
        startDateTextField.inputView = startLessonsDatePicker
        startDateTextField.inputAccessoryView = startDateToolbar
        
        let endDateToolbar = UIToolbar()
        endDateToolbar.sizeToFit()
        let endDateDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveEndDate))
        endDateToolbar.setItems([flexSpace, endDateDoneButton], animated: true)
        
        startDateTextField.inputView = startLessonsDatePicker
        startDateTextField.inputAccessoryView = startDateToolbar
        
        endDateTextField.inputView = endLessonsDatePicker
        endDateTextField.inputAccessoryView = endDateToolbar
        
        groupNameTextField.delegate = self
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
    }
    
    func setupBarButtonItems() {
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
        let deleteGroupItem = UIBarButtonItem(title: "Удалить", style: .plain, target: self, action: #selector(deleteGroupHandler))
        deleteGroupItem.tintColor = .systemRed
        navigationItem.rightBarButtonItems = [saveItem, deleteGroupItem]
    }
    
    @objc func saveStartDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        startDateTextField.text = formatter.string(from: startLessonsDatePicker.date)
        
        view.endEditing(true)
    }
    
    @objc func saveEndDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        endDateTextField.text = formatter.string(from: endLessonsDatePicker.date)
        
        view.endEditing(true)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func deleteGroupHandler() {
        navigationController?.popToRootViewController(animated: true)
        NetworkManager.shared.deleteGroup(withId: selectedGroup.groupId)
    }
    
    @objc func saveButtonHandler() {
        let successAlertView = SPAlertView(title: "Группа успешно обновлена в базе данных", preset: .done)
        let failureAlertView = SPAlertView(title: "Не удалось обновить группу", message: "Вы заполнили не все поля", preset: .error)
        
        guard let groupName = groupNameTextField.text, groupName != "" else {
            failureAlertView.present()
            return
        }
        
        guard let startDateString = startDateTextField.text, startDateString != "" else {
            failureAlertView.present()
            return
        }
        
        guard let endDateString = endDateTextField.text, endDateString != "" else {
            failureAlertView.present()
            return
        }
        
        let selectedCategoryId = drivingCategorySegmentedControl.selectedSegmentIndex + 1
        let selectedlessonsTimeId = lessonsTimeSegmentedControl.selectedSegmentIndex + 1
        let selectedTeacherId = teachers[selectedTeacherIndex].teacherId
        
        let groupToPost = Group(groupId: selectedGroup.groupId, name: groupName, lessonsStartDate: startDateString, lessonsEndDate: endDateString, categoryId: selectedCategoryId, teacherId: selectedTeacherId, lessonsTimeId: selectedlessonsTimeId)
        NetworkManager.shared.updateGroup(groupToPost)
        
        
        successAlertView.present()
    }

}

extension UpdateGroupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeacherTableViewCell.reuseIdentifier, for: indexPath) as! TeacherTableViewCell
        
        let teacher = teachers[indexPath.row]
        cell.setup(withTeacher: teacher)
        
        if indexPath.row == selectedTeacherIndex {
            cell.accessoryType = .checkmark
            cell.tintColor = .lightGreenSea
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTeacherIndex = indexPath.row
        tableView.reloadData()
    }
    
}

// MARK: - UITextFieldDelegate

extension UpdateGroupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UIGestureRecognizerDelegate

extension UpdateGroupViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view!.isDescendant(of: teachersTableView) {
            return false
        }
        return true
    }
}
