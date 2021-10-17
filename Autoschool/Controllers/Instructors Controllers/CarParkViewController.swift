//
//  CarParkViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/17/21.
//

import UIKit

class CarParkViewController: UIViewController {
    
    lazy var carsTableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CarTableViewCell.nib(), forCellReuseIdentifier: CarTableViewCell.reuseIdentifier)
        
        tableView.backgroundColor = .clear
        tableView.rowHeight = 80
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        return tableView
    }()
    let carsTableViewCount = 7

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(carsTableView)
        view.backgroundColor = .systemGray5
        title = "Автопарк"
    }
    

}

extension CarParkViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carsTableViewCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CarTableViewCell.reuseIdentifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    
}
