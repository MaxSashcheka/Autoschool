//
//  TeachersViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 11/5/21.
//

import UIKit

class TeachersViewController: UIViewController {
    
    var teachers = [Teacher]()
    
    lazy var teachersTableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TeacherTableViewCell.nib(), forCellReuseIdentifier: TeacherTableViewCell.reuseIdentifier)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 75
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.shared.fetchTeacher { fetchedTeachers in
            self.teachers = fetchedTeachers
            self.teachersTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(teachersTableView)
        title = "Преподаватели теории"
        view.backgroundColor = UIColor.viewBackground
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)

    }
    
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension TeachersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeacherTableViewCell.reuseIdentifier, for: indexPath) as! TeacherTableViewCell
        
        let teacher = teachers[indexPath.row]
        cell.setup(withTeacher: teacher)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            let teacherId = teachers[indexPath.row].teacherId
            NetworkManager.shared.deleteTeacher(withId: teacherId) { isError in
                if isError {
                    let myMessage = "Прежде чем удалить преподавателя, необходимо убрать его как преподавателя в его группах"
                    let myAlert = UIAlertController(title: myMessage, message: nil, preferredStyle: UIAlertController.Style.alert)
                    myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(myAlert, animated: true, completion: nil)
                } else {
                    self.teachers.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let updateTeacherVC = UIStoryboard(name: "Instructors", bundle: nil).instantiateViewController(identifier: "UpdateTeacherViewController") as! UpdateTeacherViewController
        
        let teacher = teachers[indexPath.row]
        updateTeacherVC.selectedTeacher = teacher
        
        self.navigationController?.pushViewController(updateTeacherVC, animated: true)
    }

}
