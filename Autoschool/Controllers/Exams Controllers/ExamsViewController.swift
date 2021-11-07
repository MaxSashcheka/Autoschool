//
//  ExamsViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/3/21.
//

import UIKit

class ExamsViewController: UIViewController {
    
    var exams = [Exam]()
    var groups = [Group]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TypePickerCollectionTableViewCell.nib(), forCellReuseIdentifier: TypePickerCollectionTableViewCell.reuseIdentifier)
        tableView.register(ExamsCollectionTableViewCell.nib(), forCellReuseIdentifier: ExamsCollectionTableViewCell.reuseIdentifier)
        
        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.shared.fetchExams { fetchedExams in
            self.exams = fetchedExams
            self.tableView.reloadData()
        }
        NetworkManager.shared.fetchGroups { fetchedGroups in
            self.groups = fetchedGroups
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor = UIColor.viewBackground

        setupNavigation()
    }
    
    func setupNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Экзамены"
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
    
//    @IBAction func changeDisplayedExams(_ sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex {
//        case 0:
//            NetworkManager.shared.fetchExams { fetchedExams in
//                self.exams = fetchedExams
//                self.tableView.reloadData()
//            }
//        case 1:
//            NetworkManager.shared.fetchExams { fetchedExams in
//                var arrayOfMatchedExams = [Exam]()
//                for exam in fetchedExams {
//                    if exam.examTypeId == 1 || exam.examTypeId == 2 {
//                        arrayOfMatchedExams.append(exam)
//                    }
//                }
//                self.exams = arrayOfMatchedExams
//                self.tableView.reloadData()
//            }
//        case 2:
//            NetworkManager.shared.fetchExams { fetchedExams in
//                var arrayOfMatchedExams = [Exam]()
//                for exam in fetchedExams {
//                    if exam.examTypeId == 3 || exam.examTypeId == 4 {
//                        arrayOfMatchedExams.append(exam)
//                    }
//                }
//                self.exams = arrayOfMatchedExams
//                self.tableView.reloadData()
//            }
//        default:
//            print("Error")
//        }
//    }
    
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension ExamsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TypePickerCollectionTableViewCell.reuseIdentifier, for: indexPath) as! TypePickerCollectionTableViewCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ExamsCollectionTableViewCell.reuseIdentifier, for: indexPath) as! ExamsCollectionTableViewCell
            cell.setup(withExams: exams, groups: groups)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        } else {
            return CGFloat(exams.count) * 162.608 + CGFloat((exams.count + 1) * 20)
        }
    }
    
}
