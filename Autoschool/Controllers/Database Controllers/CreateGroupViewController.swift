//
//  CreateGroupViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/1/21.
//

import UIKit

class CreateGroupViewController: UIViewController {
    
    var teachers = [Teacher]()

    @IBOutlet weak var groupNameLabel: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    @IBOutlet weak var drivingCategorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var classesTimeSegmentedControl: UISegmentedControl!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить группу"
        view.backgroundColor = UIColor.viewBackground
        
        groupNameLabel.delegate = self
    
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        
        configureTeachersTableView()
        configureSegmentedControls()
        configureTextFields()
        setupBarButtonItems()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NetworkManager.shared.fetchTeacher { fetchedTeachers in
            self.teachers = fetchedTeachers
            self.teachersTableView.reloadData()
            self.teachersTableViewHeight.constant = CGFloat(self.teachers.count) * self.teachersTableView.rowHeight + 10
            self.teachersSuperViewHeight.constant = self.teachersTableViewHeight.constant + 20

        }
    }
    
    private func configureTeachersTableView() {
        teachersTableView.delegate = self
        teachersTableView.dataSource = self
        teachersTableView.register(TeacherTableViewCell.nib(), forCellReuseIdentifier: TeacherTableViewCell.reuseIdentifier)
        teachersTableView.rowHeight = 76
        teachersTableView.isScrollEnabled = false
        teachersTableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
    }
    
    private func configureSegmentedControls() {
        drivingCategorySegmentedControl.selectedSegmentTintColor = .lightGreenSea
        drivingCategorySegmentedControl.layer.borderWidth = 1
        drivingCategorySegmentedControl.layer.borderColor = UIColor.darkGray.cgColor

        
        classesTimeSegmentedControl.selectedSegmentTintColor = .lightGreenSea
        classesTimeSegmentedControl.layer.borderWidth = 1
        classesTimeSegmentedControl.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    private func configureTextFields() {
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
    }
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
    }
    
    @objc func saveStartDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        startDateTextField.text = formatter.string(from: startLessonsDatePicker.date)
        
        view.endEditing(true)
    }
    
    @objc func saveEndDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        endDateTextField.text = formatter.string(from: endLessonsDatePicker.date)
        
        view.endEditing(true)
    }
    
    @objc private func saveButtonHandler() {
        let successAlertView = SPAlertView(title: "Группа успешно добавлена в базу данных", preset: .done)
        let failureAlertView = SPAlertView(title: "Не удалось добавить группу в базу данных", message: "Вы заполнили не все поля", preset: .error)
        
        guard let groupName = groupNameLabel.text, groupName != "" else {
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
        let selectedlessonsTimeId = classesTimeSegmentedControl.selectedSegmentIndex + 1
        let selectedTeacherId = teachers[selectedTeacherIndex].teacherId
        
        let groupToPost = Group(groupId: 0, name: groupName, lessonsStartDate: startDateString, lessonsEndDate: endDateString, categoryId: selectedCategoryId, teacherId: selectedTeacherId, lessonsTimeId: selectedlessonsTimeId)
        NetworkManager.shared.postGroup(groupToPost)
        
        
        successAlertView.present()
    }
    

}

extension CreateGroupViewController: UITableViewDelegate, UITableViewDataSource {
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

extension CreateGroupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreateGroupViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view!.isDescendant(of: teachersTableView) {
            return false
        }
        return true
    }
}
