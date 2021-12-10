//
//  CreateAgreementViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/17/21.
//

import UIKit

class CreateAgreementViewController: UIViewController {
    
    var students = [Student]()
    var administrators = [Administrator]()
    var instructors = [Instructor]()
    var agreements = [Agreement]()
    
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

extension CreateAgreementViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.shared.fetchAgreements { fetchedAgreements in
            self.agreements = fetchedAgreements
        }
        NetworkManager.shared.fetchInstructors(completionHandler: { fetchedInstructors in
            self.instructors = fetchedInstructors
        })
        NetworkManager.shared.fetchAdministrators { fetchedAdministrators in
            self.administrators = fetchedAdministrators
            self.administratorsTableView.reloadData()
            self.administratorsTableViewHeight.constant = CGFloat(self.administrators.count) * self.administratorsTableView.rowHeight + 10
            self.administratosSuperViewHeight.constant = self.administratorsTableViewHeight.constant + 30
        }
        NetworkManager.shared.fetchStudents { fetchedStudents in
            var studentsWithoutAgreement = [Student]()
            for student in fetchedStudents {
                var isNonRepeated = true
                for agreement in self.agreements {
                    if agreement.studentId == student.studentId {
                        isNonRepeated = false
                        break
                    }
                }
                if isNonRepeated {
                    studentsWithoutAgreement.append(student)
                }
            }
            self.students = studentsWithoutAgreement
            self.studentsTableView.reloadData()
            self.studentsTableViewHeight.constant = CGFloat(self.students.count) * self.studentsTableView.rowHeight
            self.studentsSuperViewHeight.constant = self.studentsTableViewHeight.constant + 40
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Добавить договор"
        view.backgroundColor = UIColor.viewBackground
        
        setupAdministratorsTableView()
        setupStudentsTableView()
        setupTextFields()
        setupTapGesture()
        setupBarButtonItems()
        
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.backward")!
    }
    
}

// MARK: - Private interface

private extension CreateAgreementViewController {
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
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
    
    @objc func saveButtonHandler() {
        
        if students.isEmpty {
            let myMessage = "Невозможно добавить договор без студента"
            let myAlert = UIAlertController(title: myMessage, message: nil, preferredStyle: UIAlertController.Style.alert)
            myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(myAlert, animated: true, completion: nil)
            return
        }
        
        let failureAlertView = SPAlertView(title: "Не удалось добавить договор в базу данных", message: "Вы заполнили не все поля", preset: .error)
        
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
        let agreement = Agreement(agreementId: 0, amount: Int(amount) ?? 0, signingDate: signingDate, administratorId: selectedAdministratorId, studentId: selectedStudentId)
        NetworkManager.shared.postAgreement(agreement)
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension CreateAgreementViewController: UITableViewDelegate, UITableViewDataSource {
    
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

extension CreateAgreementViewController: UITextFieldDelegate {
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

extension CreateAgreementViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view!.isDescendant(of: studentsTableView) || touch.view!.isDescendant(of: administratorsTableView) {
            return false
        }
        return true
    }
}
