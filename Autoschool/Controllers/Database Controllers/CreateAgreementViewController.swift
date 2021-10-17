//
//  CreateAgreementViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/17/21.
//

import UIKit

class CreateAgreementViewController: UIViewController {
    
    
    @IBOutlet weak var signingDateTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var workersTableView: UITableView!
    let workersTableViewCellsCount = 5
    var selectedWorkerIndex = 0
    
    @IBOutlet weak var studentsTableView: UITableView!
    let studentsTableViewCellsCount = 3
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

        setupBarButtonItems()
    }
    
    private func configureWorkersTableView() {
        workersTableView.delegate = self
        workersTableView.dataSource = self
        workersTableView.register(WorkerTableViewCell.nib(), forCellReuseIdentifier: WorkerTableViewCell.reuseIdentifier)
        workersTableView.rowHeight = 80
        workersTableView.isScrollEnabled = false
        
        workersTableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        workersTableViewHeight.constant = CGFloat(workersTableViewCellsCount) * workersTableView.rowHeight + 10
        workersSuperViewHeight.constant = workersTableViewHeight.constant + 40
    }
    
    private func configureStudentsTableView() {
        studentsTableView.delegate = self
        studentsTableView.dataSource = self
        studentsTableView.register(StudentTableViewCell.nib(), forCellReuseIdentifier: StudentTableViewCell.reuseIdentifier)
        studentsTableView.rowHeight = 100
        studentsTableView.isScrollEnabled = false

        studentsTableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        studentsTableViewHeight.constant = CGFloat(studentsTableViewCellsCount) * studentsTableView.rowHeight + 10
        studentsSuperViewHeight.constant = studentsTableViewHeight.constant + 40
    }

    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
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
        if tableView == workersTableView {
            return workersTableViewCellsCount
        } else {
            return studentsTableViewCellsCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == workersTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: WorkerTableViewCell.reuseIdentifier, for: indexPath)
            
            if indexPath.row == selectedWorkerIndex {
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
        
        if tableView == workersTableView {
            selectedWorkerIndex = indexPath.row
        } else {
            selectedStudentIndex = indexPath.row
        }
        
        tableView.reloadData()
        
    }
    
    
}
