//
//  StudentProfileViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 11/27/21.
//

import UIKit

class StudentProfileViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(GroupTableViewCell.nib(), forCellReuseIdentifier: GroupTableViewCell.reuseIdentifier)
        tableView.register(StudentTableViewCell.nib(), forCellReuseIdentifier: StudentTableViewCell.reuseIdentifier)
        tableView.register(TeacherTableViewCell.nib(), forCellReuseIdentifier: TeacherTableViewCell.reuseIdentifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
//        tableView.contentInsetAdjustmentBehavior = .never
//        tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
//
        return tableView
    }()
    
    var group: Group!
    var selectedStudent: Student!
    var students = [Student]()
    var teachers = [Teacher]()
    var instructors = [Instructor]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.shared.fetchStudents(withGroupId: selectedStudent.groupId) { fetchedStudents in
            self.students = fetchedStudents
            self.tableView.reloadData()
        }
        NetworkManager.shared.fetchTeachers(forGroup: group) { fetchedTeacher in
            self.teachers = fetchedTeacher
            self.tableView.reloadData()
        }
        NetworkManager.shared.fetchInstructors { fetchedInstructors in
            self.instructors = fetchedInstructors
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        navigationItem.hidesBackButton = true
        
        title = "\(selectedStudent.lastName) \(selectedStudent.firstName)"
        view.backgroundColor = UIColor.viewBackground

        setupBarButtonItems()
    }

    private func setupBarButtonItems() {
        let exitBarButtonItem = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(exitHandler))
        exitBarButtonItem.tintColor = .systemRed
        navigationItem.rightBarButtonItem = exitBarButtonItem

    }
    
    @objc private func exitHandler() {
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension StudentProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 25 {
            tableView.contentInsetAdjustmentBehavior = .always
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Информация о группе"
        } else if section == 1 {
            return "Преподаватель"
        } else {
            return "Ученики"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return teachers.count
        } else {
            return students.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.reuseIdentifier, for: indexPath) as! GroupTableViewCell
            
            cell.setup(withGroup: group)
            
            return cell

        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TeacherTableViewCell.reuseIdentifier, for: indexPath) as! TeacherTableViewCell
    
            let teacher = teachers[indexPath.row]
            cell.setup(withTeacher: teacher)
            cell.accessoryType = .none
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: StudentTableViewCell.reuseIdentifier, for: indexPath) as! StudentTableViewCell
            
            let student = students[indexPath.row]
            for instructor in instructors {
                if student.instructorId == instructor.instructorId {
                    cell.setup(withStudent: student, andInstructor: instructor)
                }
            }
            
            if student.studentId == selectedStudent.studentId {
                cell.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
