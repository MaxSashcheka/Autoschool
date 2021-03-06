//
//  UpdateStudentViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/1/21.
//

import UIKit

class UpdateStudentViewController: UIViewController {
    
    var groups = [Group]()
    var instructors = [Instructor]()
    
    var selectedStudent: Student!

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var middleNameTextField: UITextField!
    
    @IBOutlet weak var passportNumberTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var groupsCollectionView: UICollectionView!
    let groupsCollectionViewInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    var selectedGroupIndex = 0

    @IBOutlet weak var instructorsTableView: UITableView!
    @IBOutlet weak var instructorsTableViewSuperViewHeight: NSLayoutConstraint!
    @IBOutlet weak var instructorsTableViewHeight: NSLayoutConstraint!
    var selectedInstructorIndex = 0
    
}

// MARK: - ViewController overrides

extension UpdateStudentViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.shared.fetchGroups { fetchedGroups in
            self.groups = fetchedGroups
            self.fillStudentInfo()
            self.groupsCollectionView.reloadData()
        }
        NetworkManager.shared.fetchInstructors { fetchedInstructors in
            self.instructors = fetchedInstructors
            self.instructorsTableViewHeight.constant = CGFloat(self.instructors.count) * self.instructorsTableView.rowHeight + 25
            self.instructorsTableViewSuperViewHeight.constant = self.instructorsTableViewHeight.constant + 25
            self.fillStudentInfo()
            self.instructorsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Изменить ученика"
        view.backgroundColor = UIColor.viewBackground
        
        setupCollectionViews()
        setupInstructorsTableView()
        setupTapGesture()
        setupTextFields()
        setupBarButtonItems()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        groupsCollectionView.scrollToItem(at: IndexPath(item: selectedGroupIndex, section: 0), at: [.centeredVertically, .centeredHorizontally], animated: false)
    }
}

// MARK: - Private interface

private extension UpdateStudentViewController {
    
    func fillStudentInfo() {
        firstNameTextField.text = selectedStudent.firstName
        lastNameTextField.text = selectedStudent.lastName
        middleNameTextField.text = selectedStudent.middleName
        passportNumberTextField.text = selectedStudent.passportNumber
        phoneNumberTextField.text = selectedStudent.phoneNumber
        
        
        for index in groups.indices {
            if selectedStudent.groupId == groups[index].groupId {
                selectedGroupIndex = index
                break
            }
        }        
        for index in instructors.indices {
            if selectedStudent.instructorId == instructors[index].instructorId {
                selectedInstructorIndex = index
                break
            }
        }
        
    }
    
    func setupCollectionViews() {
        groupsCollectionView.delegate = self
        groupsCollectionView.dataSource = self
        groupsCollectionView.register(GroupCollectionViewCell.nib(), forCellWithReuseIdentifier: GroupCollectionViewCell.reuseIdentifier)
    }
    
    func setupInstructorsTableView() {
        instructorsTableView.delegate = self
        instructorsTableView.dataSource = self
        instructorsTableView.register(InstructorTableViewCell.nib(), forCellReuseIdentifier: InstructorTableViewCell.reuseIdentifier)
        instructorsTableView.rowHeight = 90
        instructorsTableView.isScrollEnabled = false
        instructorsTableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        instructorsTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
    }
    
    func setupTextFields() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        middleNameTextField.delegate = self
        passportNumberTextField.delegate = self
        phoneNumberTextField.delegate = self
    }
    
    func setupBarButtonItems() {
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
        let deleteStudentItem = UIBarButtonItem(title: "Удалить", style: .plain, target: self, action: #selector(deleteStudentHandler))
        deleteStudentItem.tintColor = .systemRed
        navigationItem.rightBarButtonItems = [saveItem, deleteStudentItem]
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func deleteStudentHandler() {
        NetworkManager.shared.deleteStudent(withId: selectedStudent.studentId)
        navigationController?.popViewController(animated: true)

    }
    
    @objc func saveButtonHandler() {
        
        let failureAlertView = SPAlertView(title: "Не удалось обновить ученика в базе данных", message: "Вы заполнили не все поля", preset: .error)
        
        guard let firstName = firstNameTextField.text, firstName != "" else {
            failureAlertView.present()
            return
        }

        guard let lastName = lastNameTextField.text, lastName != "" else {
            failureAlertView.present()
            return
        }

        guard let middleName = middleNameTextField.text, middleName != "" else {
            failureAlertView.present()
            return
        }

        guard let phoneNumber = phoneNumberTextField.text, phoneNumber != "" else {
            failureAlertView.present()
            return
        }

        guard let passportNumber = passportNumberTextField.text, passportNumber != "" else {
            failureAlertView.present()
            return
        }
        
        if phoneNumber.count < 19 {
            let myMessage = "Номер телефона имеет неправильный формат (недостаточно символов)"
            let myAlert = UIAlertController(title: myMessage, message: nil, preferredStyle: UIAlertController.Style.alert)
            myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(myAlert, animated: true, completion: nil)
            
            return
        }
        
        if passportNumber.count < 9 {
            let myMessage = "Номер телефона имеет неправильный формат (недостаточно символов)"
            let myAlert = UIAlertController(title: myMessage, message: nil, preferredStyle: UIAlertController.Style.alert)
            myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(myAlert, animated: true, completion: nil)
            
            return
        }
        
        let selectedGroup = groups[selectedGroupIndex]
        let selectedInstructor = instructors[selectedInstructorIndex]
        
        let student = Student(studentId: selectedStudent.studentId, firstName: firstName, lastName: lastName, middleName: middleName, passportNumber: passportNumber, phoneNumber: phoneNumber, instructorId: selectedInstructor.instructorId, groupId: selectedGroup.groupId)
        NetworkManager.shared.updateStudent(student)
        navigationController?.popViewController(animated: true)

    }
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex

        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension UpdateStudentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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

extension UpdateStudentViewController: UICollectionViewDelegateFlowLayout {
    
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

// MARK: - UITableViewDelegate & UITableViewDataSource

extension UpdateStudentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Выберите инструктора"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InstructorTableViewCell.reuseIdentifier, for: indexPath) as! InstructorTableViewCell
        
        let instructor = instructors[indexPath.row]
        cell.setup(withInstructor: instructor)
        
        if indexPath.row == selectedInstructorIndex {
            cell.accessoryType = .checkmark
            cell.tintColor = .lightGreenSea
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedInstructorIndex = indexPath.row
        tableView.reloadData()
    }
    
}

// MARK: - UITextFieldDelegate

extension UpdateStudentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTextField {
            if textField == passportNumberTextField {
                if range.location > 8 { return false }
            }
            if range.location > 32 { return false}

            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(with: "+XXX (XX) XXX-XX-XX", phone: newString)
            return false
        }
       return true
    }
}

// MARK: - UIGestureRecognizerDelegate

extension UpdateStudentViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view!.isDescendant(of: groupsCollectionView) || touch.view!.isDescendant(of: instructorsTableView) {
            return false
        }
        return true
    }
}
