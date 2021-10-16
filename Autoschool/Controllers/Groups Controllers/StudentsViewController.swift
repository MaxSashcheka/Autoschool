//
//  StudentsViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/15/21.
//

import UIKit

class StudentsViewController: UIViewController {

    @IBOutlet weak var studentsTableView: UITableView!
    
    var group: Group!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = group.name
        
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        studentsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)

    }

    private func configureTableView() {
        studentsTableView.delegate = self
        studentsTableView.dataSource = self
        studentsTableView.register(StudentTableViewCell.nib(), forCellReuseIdentifier: StudentTableViewCell.reuseIdentifier)
        studentsTableView.register(TeacherTableViewCell.nib(), forCellReuseIdentifier: TeacherTableViewCell.reuseIdentifier)
        studentsTableView.contentInset = UIEdgeInsets(top: -25, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension StudentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Преподаватель группы"
        } else {
            return "Ученики"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return group.students.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TeacherTableViewCell.reuseIdentifier, for: indexPath) as! TeacherTableViewCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: StudentTableViewCell.reuseIdentifier, for: indexPath) as! StudentTableViewCell
            let student = group.students[indexPath.row]
            cell.setup(withStudent: student)
            
            return cell
        }
        
    }
    
}
