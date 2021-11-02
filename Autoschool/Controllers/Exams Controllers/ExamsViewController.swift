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
    
    @IBOutlet weak var examTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var examsCollectionView: UICollectionView!
    let examsCollectionViewInsets = UIEdgeInsets(top: 20, left: 25, bottom: 20, right: 25)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureExamsCollectionView()
        configureSegmentedControl()
        setupNavigation()
    }
    
    private func configureExamsCollectionView() {
        examsCollectionView.delegate = self
        examsCollectionView.dataSource = self
        examsCollectionView.register(ExamCollectionViewCell.nib(), forCellWithReuseIdentifier: ExamCollectionViewCell.reuseIdentifier)
        examsCollectionView.backgroundColor = .clear
    }
    
    private func configureSegmentedControl() {
        examTypeSegmentedControl.selectedSegmentTintColor = .lightGreenSea
        examTypeSegmentedControl.layer.borderWidth = 1
        examTypeSegmentedControl.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NetworkManager.shared.fetchExams { fetchedExams in
            self.exams = fetchedExams
            self.examsCollectionView.reloadData()
        }
        NetworkManager.shared.fetchGroups { fetchedGroups in
            self.groups = fetchedGroups
            self.examsCollectionView.reloadData()
        }
    }
    
    private func setupNavigation() {
        
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
    
    
    @IBAction func changeDisplayedExams(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            NetworkManager.shared.fetchExams { fetchedExams in
                self.exams = fetchedExams
                self.examsCollectionView.reloadData()
            }
        case 1:
            NetworkManager.shared.fetchExams { fetchedExams in
                var arrayOfMatchedExams = [Exam]()
                for exam in fetchedExams {
                    if exam.examTypeId == 1 || exam.examTypeId == 2 {
                        arrayOfMatchedExams.append(exam)
                    }
                }
                self.exams = arrayOfMatchedExams
                self.examsCollectionView.reloadData()
            }
        case 2:
            NetworkManager.shared.fetchExams { fetchedExams in
                var arrayOfMatchedExams = [Exam]()
                for exam in fetchedExams {
                    if exam.examTypeId == 3 || exam.examTypeId == 4 {
                        arrayOfMatchedExams.append(exam)
                    }
                }
                self.exams = arrayOfMatchedExams
                self.examsCollectionView.reloadData()
            }
        default:
            print("Error")
        }
        examsCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredVertically, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension ExamsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExamCollectionViewCell.reuseIdentifier, for: indexPath) as! ExamCollectionViewCell
        
        let exam = exams[indexPath.row]
        for group in groups {
            if exam.groupId == group.groupId {
                cell.setup(withExam: exam, andGroup: group)
            }
        }
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ExamsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = collectionView.frame.width - examsCollectionViewInsets.left * 2
        let itemHeight = itemWidth / 2.3
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return examsCollectionViewInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return examsCollectionViewInsets.bottom
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let viewController = UIStoryboard(name: "Groups", bundle: nil).instantiateViewController(identifier: "StudentsViewController") as! StudentsViewController
//        let selectedExam = exams[indexPath.item]
//        viewController.group = selectedGroup
//
//        self.navigationController?.pushViewController(viewController, animated: true)
//    }
}

