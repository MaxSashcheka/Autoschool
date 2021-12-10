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
    
    var internalExternalRepresentation: InternalExternalOption = .all {
        willSet {
            switch newValue {
            case .all:  navigationItem.title = "Все экзамены"
            case .autoschool:  navigationItem.title = "Внутренние экзамены"
            case .gai:  navigationItem.title = "Экзамены в гаи"
            }
        }
    }
    
    var selectedGroupId = 0
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NavigationCollectionTableViewCell.nib(), forCellReuseIdentifier: NavigationCollectionTableViewCell.reuseIdentifier)
        tableView.register(ExamsCollectionTableViewCell.nib(), forCellReuseIdentifier: ExamsCollectionTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        
        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.shared.fetchExams { fetchedExams in
            self.exams = fetchedExams.sorted { firstExam, secondExam -> Bool in
                return firstExam.examId < secondExam.examId
            }
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
        navigationItem.title = "Все экзамены"
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
    
    func examsForInternalExternal() -> [Exam] {
        switch internalExternalRepresentation {
        case .all:
            return exams
        case .autoschool:
            var matchedExams = [Exam]()
            for exam in exams {
                if exam.examTypeId == 1 || exam.examTypeId == 2 {
                    matchedExams.append(exam)
                }
            }
            return matchedExams
        case .gai:
            var matchedExams = [Exam]()
            for exam in exams {
                if exam.examTypeId == 3 || exam.examTypeId == 4 {
                    matchedExams.append(exam)
                }
            }
            return matchedExams
        }
    }
    
    func examsForSelected(groupId: Int) -> [Exam] {
        if groupId == 0 {
            return examsForInternalExternal()
        }
        var matchedGroupExams = [Exam]()
        let exams = examsForInternalExternal()
        for exam in exams {
            if exam.groupId == groupId {
                matchedGroupExams.append(exam)
            }
        }
        return matchedGroupExams
    }

    
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension ExamsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NavigationCollectionTableViewCell.reuseIdentifier, for: indexPath) as! NavigationCollectionTableViewCell
            
            cell.setup(withGroups: groups, internalExternalOption: internalExternalRepresentation)
            cell.internalExternalDelegate = self
            cell.groupPickerDelegate = self
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ExamsCollectionTableViewCell.reuseIdentifier, for: indexPath) as! ExamsCollectionTableViewCell
            
            let matchedExams = examsForSelected(groupId: selectedGroupId)
            cell.setup(withExams: matchedExams, groups: groups)
            cell.delegate = self
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 145
        } else {
            let matchedExams = examsForSelected(groupId: selectedGroupId)

            return CGFloat(matchedExams.count) * 162.608 + CGFloat((matchedExams.count + 1) * 20)
        }
    }
    
}

extension ExamsViewController: InternalExternalRepresentationDelegate {
    func changeRepresentation(forOption option: InternalExternalOption) {
        internalExternalRepresentation = option
        tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
    }
}

extension ExamsViewController: GroupPickerDelegate {
    func changeSelected(groupId: Int) {
        selectedGroupId = groupId
        tableView.reloadData()
    }
}

extension ExamsViewController: ExamDetailDelegate {
    
    func pushUpdateExamController(withExam exam: Exam) {
        let updateExamViewController = UIStoryboard(name: "Exams", bundle: nil).instantiateViewController(identifier: "UpdateExamViewController") as! UpdateExamViewController
        
        updateExamViewController.selectedExam = exam
        
        self.navigationController?.pushViewController(updateExamViewController, animated: true)
    }
    
    
}

