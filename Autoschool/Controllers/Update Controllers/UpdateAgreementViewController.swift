//
//  UpdateAgreementViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/17/21.
//

import UIKit

class UpdateAgreementViewController: UIViewController {
    
    var students = [Student]()
    var administrators = [Administrator]()
    var instructors = [Instructor]()
    var agreements = [Agreement]()
    
    var selectedAgreement: Agreement!
    
    @IBOutlet weak var signingDateTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var administratorsTableView: UITableView!
    var selectedAdministratorIndex = 0
    
    @IBOutlet weak var studentsTableView: UITableView!
    var selectedStudentIndex = 0

    @IBOutlet weak var administratosSuperViewHeight: NSLayoutConstraint!
    @IBOutlet weak var studentsSuperViewHeight: NSLayoutConstraint!
    @IBOutlet weak var administratorsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var studentsTableViewHeight: NSLayoutConstraint!
    
    lazy var signingDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        datePicker.datePickerMode = UIDatePicker.Mode.date

        return datePicker
    }()

}

// MARK: - ViewController overrides

extension UpdateAgreementViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.shared.fetchAgreements { fetchedAgreements in
            self.agreements = fetchedAgreements
        }
        NetworkManager.shared.fetchInstructors { fetchedInstructors in
            self.instructors = fetchedInstructors
        }
        NetworkManager.shared.fetchAdministrators { fetchedAdministrators in
            self.administrators = fetchedAdministrators
            self.administratorsTableViewHeight.constant = CGFloat(self.administrators.count) * self.administratorsTableView.rowHeight + 10
            self.administratosSuperViewHeight.constant = self.administratorsTableViewHeight.constant + 30
            self.fillAgreementInfo()
            self.administratorsTableView.reloadData()
            
        }
        NetworkManager.shared.fetchStudents { fetchedStudents in
            var studentsWithoutAgreement = [Student]()
            for student in fetchedStudents {
                var isNonRepeated = true
                for agreement in self.agreements {
                    if agreement.studentId == student.studentId, agreement.agreementId != self.selectedAgreement.agreementId {
                        isNonRepeated = false
                        break
                    }
                }
                if isNonRepeated {
                    studentsWithoutAgreement.append(student)
                }
            }
            self.students = studentsWithoutAgreement
            self.fillAgreementInfo()
            self.studentsTableViewHeight.constant = CGFloat(self.students.count) * self.studentsTableView.rowHeight
            self.studentsSuperViewHeight.constant = self.studentsTableViewHeight.constant + 40
            self.studentsTableView.reloadData()

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Изменить договор"
        view.backgroundColor = UIColor.viewBackground
        
        setupAdministratorsTableView()
        setupStudentsTableView()
        setupTextFields()
        setupTapGesture()
        setupBarButtonItems()
    }
    
}

// MARK: - Private interface

private extension UpdateAgreementViewController {
    
    func fillAgreementInfo() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let endOfDate = String.Index(encodedOffset: 9)
        let stringDate = String(selectedAgreement.signingDate[...endOfDate])
        let date = dateFormatter.date(from: stringDate)!
        signingDatePicker.date = date
        
        signingDateTextField.text = dateFormatter.string(from: date)
        amountTextField.text = String(selectedAgreement.amount)
        
        for index in administrators.indices {
            if selectedAgreement.administratorId == administrators[index].administratorId {
                selectedAdministratorIndex = index
                break
            }
        }
        for index in students.indices {
            if selectedAgreement.studentId == students[index].studentId {
                selectedStudentIndex = index
                break
            }
        }

    }
    
    func setupAdministratorsTableView() {
        administratorsTableView.delegate = self
        administratorsTableView.dataSource = self
        administratorsTableView.register(AdministratorTableViewCell.nib(), forCellReuseIdentifier: AdministratorTableViewCell.reuseIdentifier)
        administratorsTableView.rowHeight = 80
        administratorsTableView.isScrollEnabled = false
        administratorsTableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        administratorsTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    }
    
    func setupStudentsTableView() {
        studentsTableView.delegate = self
        studentsTableView.dataSource = self
        studentsTableView.register(StudentTableViewCell.nib(), forCellReuseIdentifier: StudentTableViewCell.reuseIdentifier)
        studentsTableView.rowHeight = 90
        studentsTableView.isScrollEnabled = false
        studentsTableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        studentsTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    }
    
    func setupTextFields() {
        let signingDateToolBar = UIToolbar()
        signingDateToolBar.sizeToFit()
        let signingDateDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSigningDate))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        signingDateToolBar.setItems([flexSpace, signingDateDoneButton], animated: true)
        
        signingDateTextField.inputView = signingDatePicker
        signingDateTextField.inputAccessoryView = signingDateToolBar
        
        amountTextField.delegate = self
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
    }
    
    func setupBarButtonItems() {
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
        let deleteAgreementItem = UIBarButtonItem(title: "Удалить", style: .plain, target: self, action: #selector(deleteAgreementHandler))
        deleteAgreementItem.tintColor = .systemRed
        navigationItem.rightBarButtonItems = [saveItem, deleteAgreementItem]
    }
    
    @objc func saveSigningDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        signingDateTextField.text = formatter.string(from: signingDatePicker.date)
        
        view.endEditing(true)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func deleteAgreementHandler() {
        
    }
    
    @objc func saveButtonHandler() {
        let successAlertView = SPAlertView(title: "Договор успешно обновлен в базе данных", preset: .done)
        let failureAlertView = SPAlertView(title: "Не удалось обновить договор в базе данных", message: "Вы заполнили не все поля", preset: .error)
        
        guard let signingDate = signingDateTextField.text, signingDate != "" else {
            failureAlertView.present()
            return
        }
        
        guard let amount = amountTextField.text, amount != "" else {
            failureAlertView.present()
            return
        }
        
        let selectedAdministratorId = administrators[selectedAdministratorIndex].administratorId
        let selectedStudentId = students[selectedStudentIndex].studentId
        let agreement = Agreement(agreementId: selectedAgreement.agreementId, amount: Int(amount) ?? 0, signingDate: signingDate, administratorId: selectedAdministratorId, studentId: selectedStudentId)
        NetworkManager.shared.updateAgreement(agreement)
        
        successAlertView.present()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension UpdateAgreementViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == administratorsTableView {
            return administrators.count
        } else {
            return students.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == administratorsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: AdministratorTableViewCell.reuseIdentifier, for: indexPath) as! AdministratorTableViewCell
            
            let administrator = administrators[indexPath.row]
            cell.setup(withAdministrator: administrator)
            cell.fullNameLabel.numberOfLines = 1
            
            if indexPath.row == selectedAdministratorIndex {
                cell.accessoryType = .checkmark
                cell.tintColor = .lightGreenSea
            } else {
                cell.accessoryType = .none
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: StudentTableViewCell.reuseIdentifier, for: indexPath) as! StudentTableViewCell
            
            let student = students[indexPath.row]
            for instructor in instructors {
                if student.instructorId == instructor.instructorId {
                    cell.setup(withStudent: student, andInstructor: instructor)
                }
            }

            if indexPath.row == selectedStudentIndex {
                cell.accessoryType = .checkmark
                cell.tintColor = .lightGreenSea
            } else {
                cell.accessoryType = .none
            }

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == administratorsTableView {
            selectedAdministratorIndex = indexPath.row
        } else {
            selectedStudentIndex = indexPath.row
        }
        tableView.reloadData()
    }
}

// MARK: - UITextFieldDelegate

extension UpdateAgreementViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UIGestureRecognizerDelegate

extension UpdateAgreementViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view!.isDescendant(of: studentsTableView) || touch.view!.isDescendant(of: administratorsTableView) {
            return false
        }
        return true
    }
}
