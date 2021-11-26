//
//  TestViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 11/26/21.
//

import UIKit

class MainLoginViewController: UIViewController {

    @IBOutlet weak var passportNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var studentLoginButton: UIButton!
    @IBOutlet weak var administratorLoginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "База данных"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        [studentLoginButton, administratorLoginButton].forEach { button in
            button?.layer.cornerRadius = 20
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    
    @IBAction func studentLogin(_ sender: UIButton) {
        guard let phoneNumber = phoneNumberTextField.text, phoneNumber != "" else { return }
        print("student")

    }
    
    @IBAction func administratorLogin(_ sender: UIButton) {
        guard let passportNumber = passportNumberTextField.text, passportNumber != "" else { return }
        guard let password = passwordTextField.text, password != "" else { return }
        print("administrator")

        let viewController = UIStoryboard(name: "Database", bundle: nil).instantiateViewController(identifier: "DatabaseMainViewController")

        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
}
