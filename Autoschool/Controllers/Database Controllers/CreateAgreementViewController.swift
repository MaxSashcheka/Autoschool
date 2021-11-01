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
    
    @IBOutlet weak var signingDateTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var administratorsTableView: UITableView!
    var selectedAdministratorIndex = 0
    
    @IBOutlet weak var studentsTableView: UITableView!
    var selectedStudentIndex = 0

    @IBOutlet weak var workersSuperViewHeight: NSLayoutConstraint!
    @IBOutlet weak var studentsSuperViewHeight: NSLayoutConstraint!
    @IBOutlet weak var workersTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var studentsTableViewHeight: NSLayoutConstraint!
    
    lazy var signingDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        datePicker.datePickerMode = UIDatePicker.Mode.date

        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить договор"
        
        configureWorkersTableView()
        configureStudentsTableView()
        configureTextFields()

        setupBarButtonItems()
    }

    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
    }
    
    private func configureWorkersTableView() {
        administratorsTableView.delegate = self
        administratorsTableView.dataSource = self
        administratorsTableView.register(AdministratorTableViewCell.nib(), forCellReuseIdentifier: AdministratorTableViewCell.reuseIdentifier)
        administratorsTableView.rowHeight = 80
        administratorsTableView.isScrollEnabled = false
        
        administratorsTableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        workersTableViewHeight.constant = CGFloat(administrators.count) * administratorsTableView.rowHeight + 10
        workersSuperViewHeight.constant = workersTableViewHeight.constant + 40
    }
    
    private func configureStudentsTableView() {
        studentsTableView.delegate = self
        studentsTableView.dataSource = self
        studentsTableView.register(StudentTableViewCell.nib(), forCellReuseIdentifier: StudentTableViewCell.reuseIdentifier)
        studentsTableView.rowHeight = 100
        studentsTableView.isScrollEnabled = false

        studentsTableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        studentsTableViewHeight.constant = CGFloat(students.count) * studentsTableView.rowHeight + 10
        studentsSuperViewHeight.constant = studentsTableViewHeight.constant + 40
    }
    
    private func configureTextFields() {
        let signingDateToolBar = UIToolbar()
        signingDateToolBar.sizeToFit()
        let signingDateDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSigningDate))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        signingDateToolBar.setItems([flexSpace, signingDateDoneButton], animated: true)
        
        signingDateTextField.inputView = signingDatePicker
        signingDateTextField.inputAccessoryView = signingDateToolBar
    }
    
    @objc private func saveSigningDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        signingDateTextField.text = formatter.string(from: signingDatePicker.date)
        
        view.endEditing(true)
    }
    
    @objc private func saveButtonHandler() {
        let successAlertView = SPAlertView(title: "Договор успешно добавлен в базу данных", preset: .done)
        let failureAlertView = SPAlertView(title: "Не удалось добавить договор в базу данных", message: "Вы заполнили не все поля", preset: .error)
        
        guard let signingDate = signingDateTextField.text, signingDate != "" else {
            failureAlertView.present()
            return
        }
        
        guard let amount = amountTextField.text, amount != "" else {
            failureAlertView.present()
            return
        }
        
        successAlertView.present()
    }

}

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
            let cell = tableView.dequeueReusableCell(withIdentifier: AdministratorTableViewCell.reuseIdentifier, for: indexPath)
            
            if indexPath.row == selectedAdministratorIndex {
                cell.accessoryType = .checkmark
                cell.tintColor = .lightGreenSea
            } else {
                cell.accessoryType = .none
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: StudentTableViewCell.reuseIdentifier, for: indexPath)

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
