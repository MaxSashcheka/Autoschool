//
//  InsturctorsListTableViewCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 11/7/21.
//

import UIKit

class InsturctorsListTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "InsturctorsListTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }

    @IBOutlet weak var instructorsTableView: UITableView!
    
    var instructors = [Instructor]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        instructorsTableView.delegate = self
        instructorsTableView.dataSource = self
        instructorsTableView.register(InstructorTableViewCell.nib(), forCellReuseIdentifier: InstructorTableViewCell.reuseIdentifier)
        instructorsTableView.rowHeight = 90
        instructorsTableView.contentInset = UIEdgeInsets(top: -25, left: 0, bottom: 0, right: 0)
        instructorsTableView.backgroundColor = .clear
        instructorsTableView.isScrollEnabled = false
        
        backgroundColor = .clear
    }
    
    func setup(withInstructors instructors: [Instructor]) {
        self.instructors = instructors
        instructorsTableView.reloadData()
    }
}

extension InsturctorsListTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Инструкторы"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InstructorTableViewCell.reuseIdentifier, for: indexPath) as! InstructorTableViewCell


        let instructor = instructors[indexPath.row]
        cell.setup(withInstructor: instructor)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let instructorDetailViewController = InstructorDetailViewController()
        let selectedInstructor = instructors[indexPath.row]
        instructorDetailViewController.instructor = selectedInstructor
//        navigationController?.pushViewController(instructorDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            let instructorId = instructors[indexPath.row].instructorId
            NetworkManager.shared.deleteInstructor(withId: instructorId)
            instructors.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }
    
    
}
