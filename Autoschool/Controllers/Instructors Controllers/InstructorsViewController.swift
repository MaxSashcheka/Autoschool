//
//  InstructorsViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/3/21.
//

import UIKit

class InstructorsViewController: UIViewController {
    
    let instructor0 = Instructor(firstName: "Артем", lastName: "Малашкевич", patronymic: "Викторович", phoneNumber: "+375 (29) 358-17-24", drivingExperience: 2)
    let instructor1 = Instructor(firstName: "Сащеко", lastName: "Максим", patronymic: "Андреевич", phoneNumber: "+375 (29) 358-17-24", drivingExperience: 4)
    let instructor2 = Instructor(firstName: "Артем", lastName: "Малашкевич", patronymic: "Андреевич", phoneNumber: "+375 (29) 358-17-24", drivingExperience: 5)
    let instructor3 = Instructor(firstName: "Артем", lastName: "Малашкевич", patronymic: "Андреевич", phoneNumber: "+375 (29) 358-17-24", drivingExperience: 15)
    
    lazy var dataSource = [instructor0, instructor1, instructor2, instructor3]
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InstructorTableViewCell.nib(), forCellReuseIdentifier: InstructorTableViewCell.reuseIdentifier)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)

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
        navigationController?.navigationBar.tintColor = .black
    }

}

extension InstructorsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InstructorTableViewCell.reuseIdentifier, for: indexPath) as! InstructorTableViewCell
        
        return cell
    }
    
    
}
