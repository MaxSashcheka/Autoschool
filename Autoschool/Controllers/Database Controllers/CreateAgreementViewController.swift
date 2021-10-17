//
//  CreateAgreementViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/17/21.
//

import UIKit

class CreateAgreementViewController: UIViewController {
    
    
    @IBOutlet weak var workersTableView: UITableView!
    let workersTableViewCellsCount = 5
    @IBOutlet weak var studentsTableView: UITableView!
    let studentsTableViewCellsCount = 3

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
        workersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "workersTableView")
        workersTableView.rowHeight = 40
        workersTableView.isScrollEnabled = false
        
        workersTableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        workersTableViewHeight.constant = CGFloat(workersTableViewCellsCount) * workersTableView.rowHeight + 10
        workersSuperViewHeight.constant = workersTableViewHeight.constant + 40
    }
    
    private func configureStudentsTableView() {
        studentsTableView.delegate = self
        studentsTableView.dataSource = self
        studentsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "studentsTableView")
        studentsTableView.rowHeight = 40
        studentsTableView.isScrollEnabled = false

        studentsTableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        studentsTableViewHeight.constant = CGFloat(studentsTableViewCellsCount) * studentsTableView.rowHeight + 10
        studentsSuperViewHeight.constant = studentsTableViewHeight.constant + 40
    }

    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
    }
    
    @objc private func saveButtonHandler() {
        let alertView = SPAlertView(title: "Договор успешно добавлен в базу данных", preset: .done)
        alertView.present()

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
            let cell = tableView.dequeueReusableCell(withIdentifier: "workersTableView", for: indexPath)
            cell.textLabel?.text = "Сащеко Максим Администратор"
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "studentsTableView", for: indexPath)
            cell.textLabel?.text = "Сащеко Максим учащийся"
            
            return cell
        }
        
    }
    
    
}
