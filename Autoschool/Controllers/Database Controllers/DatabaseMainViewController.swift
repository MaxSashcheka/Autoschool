//
//  DatabaseMainViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/1/21.
//

import UIKit

struct ViewControllerRepresentation {
    let tableViewName: String
    let identifier: String
}

class DatabaseMainViewController: UIViewController {
    
    let dataSource = [
        0: ViewControllerRepresentation(tableViewName: "Добавить группу", identifier: "CreateGroupViewController"),
        1: ViewControllerRepresentation(tableViewName: "Добавить ученика", identifier: "CreateStudentViewController"),
        2: ViewControllerRepresentation(tableViewName: "Добавить инструктора", identifier: "CreateInstruсtorViewController"),
        3: ViewControllerRepresentation(tableViewName: "Добавить машину", identifier: "CreateCarViewController"),
        4: ViewControllerRepresentation(tableViewName: "Добавить экзамен", identifier: "CreateExamViewController")
    ]
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        
        tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.isScrollEnabled = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)

        
        setupNavigation()
    }

    private func setupNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "База данных"
        let largeTitleAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        navigationController?.navigationBar.largeTitleTextAttributes = largeTitleAttributes
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.backward")!
        navigationController?.navigationBar.tintColor = .black
    }

}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension DatabaseMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controllerIdentifier = dataSource[indexPath.row]?.identifier ?? ""
        let viewController = UIStoryboard(name: "Database", bundle: nil).instantiateViewController(identifier: controllerIdentifier)
//        present(viewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.textLabel?.text = dataSource[indexPath.row]?.tableViewName
        return cell
    }
    
    
}
