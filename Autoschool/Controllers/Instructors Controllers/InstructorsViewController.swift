//
//  InstructorsViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/3/21.
//

import UIKit

struct Model {
    var image: UIImage?
    var title: String
}

class InstructorsViewController: UIViewController {
    
    var instructors = [Instructor]()
    var models = [
        Model(image: UIImage(systemName: "car.2.fill"), title: "Автопарк"),
        Model(image: UIImage(systemName: "person.crop.rectangle"), title: "Удостоверения"),
        Model(image: UIImage(systemName: "person.3"), title: "Преподаватели")
    ]

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CollectionTableViewCell.nib(), forCellReuseIdentifier: CollectionTableViewCell.reuseIdentifier)
        tableView.register(InsturctorsListTableViewCell.nib(), forCellReuseIdentifier: InsturctorsListTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NetworkManager.shared.fetchInstructors { fetchedInstructors in
            self.instructors = fetchedInstructors
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.reuseIdentifier, for: indexPath) as! CollectionTableViewCell
            cell.setup(withModels: models)
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: InsturctorsListTableViewCell.reuseIdentifier, for: indexPath) as! InsturctorsListTableViewCell
            cell.setup(withInstructors: instructors)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 195
        } else {
            return CGFloat(instructors.count * 90) + 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - PushInstructorDetailControllerDelegate

extension InstructorsViewController: PushInstructorDetailControllerDelegate {
    func pushController(instructor: Instructor) {
        let instructorDetailViewController = InstructorDetailViewController()
        instructorDetailViewController.instructor = instructor
        navigationController?.pushViewController(instructorDetailViewController, animated: true)
    }
}

// MARK: - PushAutoschoolInfoDetailControllerDelegate

extension InstructorsViewController: PushAutoschoolInfoDetailControllerDelegate {
    func pushController(forCase autoschoolInfoCase: AutoschoolInfo) {
        switch autoschoolInfoCase {
        case .carPark:
            let carParkViewController = CarParkViewController()
            navigationController?.pushViewController(carParkViewController, animated: true)
        case .driverLicenses:
            let driverLicensesViewController = DriverLicensesViewController()
            navigationController?.pushViewController(driverLicensesViewController, animated: true)
        case .teachers:
            let teachersViewController = TeachersViewController()
            navigationController?.pushViewController(teachersViewController, animated: true)
        default: print("Error")
            
        }
    }
    
    
}
