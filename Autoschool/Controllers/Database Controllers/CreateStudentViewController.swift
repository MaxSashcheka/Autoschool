//
//  CreateStudentViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/1/21.
//

import UIKit

class CreateStudentViewController: UIViewController {
    
    var groups = [Group]()
    var instructors = [Instructor]()

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

extension CreateStudentViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.shared.fetchGroups { fetchedGroups in
            self.groups = fetchedGroups
            self.groupsCollectionView.reloadData()
        }
        NetworkManager.shared.fetchInstructors { fetchedInstructors in
            self.instructors = fetchedInstructors
            self.instructorsTableView.reloadData()
            self.instructorsTableViewHeight.constant = CGFloat(self.instructors.count) * self.instructorsTableView.rowHeight + 25
            self.instructorsTableViewSuperViewHeight.constant = self.instructorsTableViewHeight.constant + 25
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Добавить ученика"
        view.backgroundColor = UIColor.viewBackground
        
        setupCollectionViews()
        setupInstructorsTableView()
        setupTapGesture()
        setupTextFields()
        setupBarButtonItems()
    }
}

// MARK: - Private interface

private extension CreateStudentViewController {
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func saveButtonHandler() {
        let successAlertView = SPAlertView(title: "Ученик успешно добавлен в базу данных", preset: .done)
        let failureAlertView = SPAlertView(title: "Не удалось добавить ученика в базу данных", message: "Вы заполнили не все поля", preset: .error)
        
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
        
        let selectedGroup = groups[selectedGroupIndex]
        let selectedInstructor = instructors[selectedInstructorIndex]
        
        let student = Student(studentId: 0, firstName: firstName, lastName: lastName, middleName: middleName, passportNumber: passportNumber, phoneNumber: phoneNumber, instructorId: selectedInstructor.instructorId, groupId: selectedGroup.groupId)
        NetworkManager.shared.postStudent(student)
        
        successAlertView.present()
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

extension CreateStudentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCollectionViewCell.reuseIdentifier, for: indexPath) as! GroupCollectionViewCell
        
        let group = groups[indexPath.item]
        cell.setup(withGroup: group)
        
        
        if indexPath.item == selectedGroupIndex {
            cell.layer.shadowColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.6).cgColor
        } else {
            cell.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35).cgColor
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

extension CreateStudentViewController: UICollectionViewDelegateFlowLayout {
    
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

extension CreateStudentViewController: UITableViewDelegate, UITableViewDataSource {
    
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

extension CreateStudentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTextField {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(with: "+ XXX (XX) XXX-XX-XX", phone: newString)
            return false
        }
       return true
    }
}

// MARK: - UIGestureRecognizerDelegate

extension CreateStudentViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view!.isDescendant(of: groupsCollectionView) || touch.view!.isDescendant(of: instructorsTableView) {
            return false
        }
        return true
    }
}
