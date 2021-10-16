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
    

    private func configureTableView() {
        studentsTableView.delegate = self
        studentsTableView.dataSource = self
        studentsTableView.register(StudentTableViewCell.nib(), forCellReuseIdentifier: StudentTableViewCell.reuseIdentifier)
        studentsTableView.setContentOffset(.zero, animated: true)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension StudentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group.students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudentTableViewCell.reuseIdentifier, for: indexPath) as! StudentTableViewCell
        
        let student = group.students[indexPath.row]
        cell.setup(withStudent: student)
        
        return cell
    }
    
}
