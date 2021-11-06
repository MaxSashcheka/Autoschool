//
//  CarParkViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/17/21.
//

import UIKit

class CarParkViewController: UIViewController {
    
    var cars = [Car]()
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(carsTableView)
        title = "Автопарк"
            
        view.backgroundColor = UIColor.viewBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NetworkManager.shared.fetchCars { fetchedCars in
            self.cars = fetchedCars
            self.carsTableView.reloadData()
        }
    }

}

extension CarParkViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CarTableViewCell.reuseIdentifier, for: indexPath) as! CarTableViewCell
        
        let car = cars[indexPath.row]
        cell.setup(withCar: car)
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            let carId = cars[indexPath.row].carId
            NetworkManager.shared.deleteCar(withId: carId)
            cars.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let updateCarVC = UIStoryboard(name: "Instructors", bundle: nil).instantiateViewController(identifier: "UpdateCarViewController")
        self.navigationController?.pushViewController(updateCarVC, animated: true)
    }
    
}
