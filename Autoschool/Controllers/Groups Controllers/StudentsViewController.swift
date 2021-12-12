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
    var students = [Student]()
    var teachers = [Teacher]()
    var instructors = [Instructor]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.shared.fetchStudents(withGroupId: group.groupId) { [weak self] fetchedStudents in
            guard let self = self else { return }

            self.students = fetchedStudents
            self.studentsTableView.reloadData()
        }
        NetworkManager.shared.fetchTeachers(forGroup: group) { [weak self] fetchedTeacher in
            guard let self = self else { return }

            self.teachers = fetchedTeacher
            self.studentsTableView.reloadData()
        }
        NetworkManager.shared.fetchInstructors { [weak self] fetchedInstructors in
            guard let self = self else { return }

            self.instructors = fetchedInstructors
            self.studentsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Группа \(group.name)"
        view.backgroundColor = UIColor.viewBackground

        setupStudentsTableView()
        setupBarButtonItems()
    }

    private func setupStudentsTableView() {
        studentsTableView.delegate = self
        studentsTableView.dataSource = self
        studentsTableView.register(StudentTableViewCell.nib(), forCellReuseIdentifier: StudentTableViewCell.reuseIdentifier)
        studentsTableView.register(TeacherTableViewCell.nib(), forCellReuseIdentifier: TeacherTableViewCell.reuseIdentifier)
        studentsTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        
        studentsTableView.contentInsetAdjustmentBehavior = .never
        studentsTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Изменить", style: .plain, target: self, action: #selector(openUpdateGroup))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)

    }
    
    @objc private func openUpdateGroup() {
        let updateGroupVC = UIStoryboard(name: "Groups", bundle: nil).instantiateViewController(identifier: "UpdateGroupViewController") as! UpdateGroupViewController
        updateGroupVC.selectedGroup = group
        updateGroupVC.students = students
        self.navigationController?.pushViewController(updateGroupVC, animated: true)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension StudentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 25 {
            studentsTableView.contentInsetAdjustmentBehavior = .always
        }
    }
    
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
            return teachers.count
        } else {
            return students.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TeacherTableViewCell.reuseIdentifier, for: indexPath) as! TeacherTableViewCell
    
            let teacher = teachers[indexPath.row]
            cell.setup(withTeacher: teacher)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: StudentTableViewCell.reuseIdentifier, for: indexPath) as! StudentTableViewCell
            cell.accessoryType = .disclosureIndicator
            let student = students[indexPath.row]
            for instructor in instructors {
                if student.instructorId == instructor.instructorId {
                    cell.setup(withStudent: student, andInstructor: instructor)

                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 1 {
            return .delete
        }
        return .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            let studentId = students[indexPath.row].studentId
            NetworkManager.shared.deleteStudent(withId: studentId)
            students.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            let updateStudentVC = UIStoryboard(name: "Groups", bundle: nil).instantiateViewController(identifier: "UpdateStudentViewController") as! UpdateStudentViewController
            
            let selectedStudent = students[indexPath.row]
            updateStudentVC.selectedStudent = selectedStudent
            
            self.navigationController?.pushViewController(updateStudentVC, animated: true)
        }
    }
    
}
