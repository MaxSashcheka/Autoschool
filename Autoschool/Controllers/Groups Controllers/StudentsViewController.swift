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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Группа \(group.name)"
        view.backgroundColor = UIColor.viewBackground

        
        studentsTableView.contentInsetAdjustmentBehavior = .never
        studentsTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NetworkManager.shared.fetchStudents(withGroupId: group.groupId) { fetchedStudents in
            self.students = fetchedStudents
            self.studentsTableView.reloadData()
        }
        NetworkManager.shared.fetchTeacher(forGroupId: group.groupId) { fetchedTeacher in
            self.teachers = fetchedTeacher
            self.studentsTableView.reloadData()
        }
        NetworkManager.shared.fetchInstructors { fetchedInstructors in
            self.instructors = fetchedInstructors
            self.studentsTableView.reloadData()
        }
        
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
            
            let student = students[indexPath.row]
            for instructor in instructors {
                if student.instructorId == instructor.instructorId {
                    cell.setup(withStudent: student, andInstructor: instructor)

                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = UIStoryboard(name: "Database", bundle: nil).instantiateViewController(identifier: "CreateStudentViewController")

//        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
