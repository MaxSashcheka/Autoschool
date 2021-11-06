//
//  AdministrationViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/17/21.
//

import UIKit

class AdministrationViewController: UIViewController {
    
    var administrators = [Administrator]()
    
    lazy var administratorsTableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AdministratorTableViewCell.nib(), forCellReuseIdentifier: AdministratorTableViewCell.reuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.shared.fetchAdministrators { fetchedAdministrators in
            self.administrators = fetchedAdministrators
            self.administratorsTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(administratorsTableView)
        view.backgroundColor = UIColor.viewBackground

        setupNavigation()
    }
    
    
    
    private func setupNavigation() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Администрация"
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

extension AdministrationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return administrators.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            cell.textLabel?.text = "Просмотреть договоры"
            cell.accessoryType = .disclosureIndicator
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: AdministratorTableViewCell.reuseIdentifier, for: indexPath) as! AdministratorTableViewCell

            let administrator = administrators[indexPath.row]
            cell.setup(withAdministrator: administrator)
            
            
            cell.accessoryType = .disclosureIndicator

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let agreementsVC = AgreementsViewController()
            navigationController?.pushViewController(agreementsVC, animated: true)
        } else {
            let updateAdministratorVC = UIStoryboard(name: "Administration", bundle: nil).instantiateViewController(identifier: "UpdateAdministratorViewController")
            self.navigationController?.pushViewController(updateAdministratorVC, animated: true)
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
            
            let administratorId = administrators[indexPath.row].administratorId
            NetworkManager.shared.deleteAdministrator(withId: administratorId)
            administrators.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }
    
    
}
