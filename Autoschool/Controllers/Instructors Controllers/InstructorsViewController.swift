//
//  InstructorsViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/3/21.
//

import UIKit

class InstructorsViewController: UIViewController {
    
    var instructors = [Instructor]()
    
    lazy var instructorsTableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InstructorTableViewCell.nib(), forCellReuseIdentifier: InstructorTableViewCell.reuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NetworkManager.shared.fetchInstructors { fetchedInstructors in
            self.instructors = fetchedInstructors
            self.instructorsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(instructorsTableView)
        view.backgroundColor = UIColor.viewBackground
        
        setupNavigation()
    }
    
    private func setupNavigation() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Инструкторы"
        let largeTitleAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        navigationController?.navigationBar.largeTitleTextAttributes = largeTitleAttributes
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.backward")!
        navigationController?.navigationBar.tintColor = .lightGreenSea
    }

}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension InstructorsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return instructors.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            
            cell.accessoryType = .disclosureIndicator
            cell.tintColor = .lightGreenSea
            
            if indexPath.row == 0 {
                cell.imageView?.image = UIImage(systemName: "car.2.fill")
                cell.textLabel?.text = "Автопарк автошколы"
            } else if indexPath.row == 1 {
                cell.imageView?.image = UIImage(systemName: "person.crop.rectangle")
                cell.textLabel?.text = "Водительские удостоверения"
            } else {
                cell.imageView?.image = UIImage(systemName: "person.3")
                cell.textLabel?.text = "Преподаватели теории"
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: InstructorTableViewCell.reuseIdentifier, for: indexPath) as! InstructorTableViewCell
            
            let instructor = instructors[indexPath.row]
            cell.setup(withInstructor: instructor)
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let carParkViewController = CarParkViewController()
                navigationController?.pushViewController(carParkViewController, animated: true)
            } else if indexPath.row == 1 {
                let driverLicensesViewController = DriverLicensesViewController()
                navigationController?.pushViewController(driverLicensesViewController, animated: true)
            } else {
                let teachersViewController = TeachersViewController()
                navigationController?.pushViewController(teachersViewController, animated: true)
            }
            
        } else {
            let instructorDetailViewController = InstructorDetailViewController()
            let selectedInstructor = instructors[indexPath.row]
            instructorDetailViewController.instructor = selectedInstructor
            navigationController?.pushViewController(instructorDetailViewController, animated: true)
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
            
            let instructorId = instructors[indexPath.row].instructorId
            NetworkManager.shared.deleteInstructor(withId: instructorId)
            instructors.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }
    
}
