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
    let image: UIImage?
}

class DatabaseMainViewController: UIViewController {
    
    let controllersRepresentationModel = [
        0: ViewControllerRepresentation(tableViewName: "Добавить администратора", identifier: "CreateWorkerViewController", image: UIImage(systemName: "person")),
        1: ViewControllerRepresentation(tableViewName: "Добавить ученика", identifier: "CreateStudentViewController", image: UIImage(systemName: "studentdesk")),
        2: ViewControllerRepresentation(tableViewName: "Добавить договор", identifier: "CreateAgreementViewController", image: UIImage(systemName: "doc.text")),
        3: ViewControllerRepresentation(tableViewName: "Добавить инструктора", identifier: "CreateInstruсtorViewController", image: UIImage(systemName: "person.crop.rectangle")),
        4: ViewControllerRepresentation(tableViewName: "Добавить машину", identifier: "CreateCarViewController", image: UIImage(systemName: "car")),
        5: ViewControllerRepresentation(tableViewName: "Добавить группу", identifier: "CreateGroupViewController", image: UIImage(systemName: "person.3")),
        6: ViewControllerRepresentation(tableViewName: "Добавить преподователя теории", identifier: "CreateTeacherViewController", image: UIImage(systemName: "person")),
        7: ViewControllerRepresentation(tableViewName: "Добавить экзамен", identifier: "CreateExamViewController", image: UIImage(systemName: "graduationcap")),
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

        SPAlertView.appearance().duration = 1
        SPAlertView.appearance().cornerRadius = 30
        
        setupNavigation()
    }

    private func setupNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "База данных"
        let largeTitleAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 27, weight: .bold),
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
        let controllerIdentifier = controllersRepresentationModel[indexPath.row]?.identifier ?? ""
        let viewController = UIStoryboard(name: "Database", bundle: nil).instantiateViewController(identifier: controllerIdentifier)
//        present(viewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controllersRepresentationModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        let vcRepresentator = controllersRepresentationModel[indexPath.row]
        cell.textLabel?.text = vcRepresentator?.tableViewName
        cell.imageView?.image = vcRepresentator?.image
        cell.imageView?.tintColor = .black

        return cell
    }
    
    
}
