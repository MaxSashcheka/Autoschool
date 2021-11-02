//
//  ExamsViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/3/21.
//

import UIKit

class ExamsViewController: UIViewController {
    
    var exams = [Exam]()
    
    @IBOutlet weak var examsCollectionView: UICollectionView!
    let examsCollectionViewInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureExamsCollectionView()

        setupNavigation()
    }
    
    private func configureExamsCollectionView() {
        examsCollectionView.delegate = self
        examsCollectionView.dataSource = self
        examsCollectionView.register(ExamCollectionViewCell.nib(), forCellWithReuseIdentifier: ExamCollectionViewCell.reuseIdentifier)
        examsCollectionView.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NetworkManager.shared.fetchExams { fetchedExams in
            self.exams = fetchedExams
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

}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension ExamsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExamCollectionViewCell.reuseIdentifier, for: indexPath) as! ExamCollectionViewCell
        
        let exam = exams[indexPath.row]
        cell.setup(withExam: exam)
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ExamsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = collectionView.frame.width - examsCollectionViewInsets.left * 2
        let itemHeight = itemWidth / 2
        
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

