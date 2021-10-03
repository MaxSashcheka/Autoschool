//
//  DatabaseMainViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/1/21.
//

import UIKit

class DatabaseMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    
    @IBAction func pushCreateGroupController(_ sender: Any) {
        let createGroupViewController = UIStoryboard(name: "Database", bundle: nil).instantiateViewController(identifier: "CreateGroupViewController") as! CreateGroupViewController
        
            
        self.navigationController?.pushViewController(createGroupViewController, animated: true)
    }
    
    
    @IBAction func pushCreateStudentController(_ sender: Any) {
        let createStudentViewController = UIStoryboard(name: "Database", bundle: nil).instantiateViewController(identifier: "CreateStudentViewController") as! CreateStudentViewController
        
            
        self.navigationController?.pushViewController(createStudentViewController, animated: true)
    }
    
    
    @IBAction func pushCreateInstructorController(_ sender: Any) {
        let createInstructorViewController = UIStoryboard(name: "Database", bundle: nil).instantiateViewController(identifier: "CreateInstruсtorViewController") as! CreateInstruсtorViewController
        
            
        self.navigationController?.pushViewController(createInstructorViewController, animated: true)
    }
    
    
    @IBAction func pushCreateCarController(_ sender: Any) {
        
    }
    
    
    @IBAction func pushCreateExamController(_ sender: Any) {
        
    }
    

}
