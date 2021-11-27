//
//  TestViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 11/26/21.
//

import UIKit

class MainLoginViewController: UIViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passportNumberTextField: UITextField!
    @IBOutlet weak var studentLoginButton: UIButton!
    @IBOutlet weak var administratorLoginButton: UIButton!
    
    var administrators = [Administrator]()
    var students = [Student]()
    var groups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "База данных"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        [studentLoginButton, administratorLoginButton].forEach { button in
            button?.layer.cornerRadius = 20
        }
        
        phoneNumberTextField.delegate = self
        passwordTextField.delegate = self
        passportNumberTextField.delegate = self
        
        setupTapGesture()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
        NetworkManager.shared.fetchAdministrators { fetchedAdministrators in
            self.administrators = fetchedAdministrators
        }
        NetworkManager.shared.fetchStudents { fetchedStudents in
            self.students = fetchedStudents
        }
        NetworkManager.shared.fetchGroups { fetchedGroups in
            self.groups = fetchedGroups
        }

        
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    
    @IBAction func studentLogin(_ sender: UIButton) {
        guard let passportNumber = passportNumberTextField.text, passportNumber != "" else { return }
        
        for student in students {
            if student.passportNumber == passportNumber {
                let studentProfileViewController = StudentProfileViewController()
                
                var selectedGroup = Group()
                for group in groups {
                    if student.groupId == group.groupId {
                        selectedGroup = group
                    }
                }
                 
                studentProfileViewController.selectedStudent = student
                studentProfileViewController.group = selectedGroup
                
                navigationController?.pushViewController(studentProfileViewController, animated: true)
            }
        }

    }
    
    @IBAction func administratorLogin(_ sender: UIButton) {
        guard let phoneNumber = phoneNumberTextField.text, phoneNumber != "" else { return }
        guard let password = passwordTextField.text, password != "" else { return }
        
        for administrator in administrators {
            if administrator.phoneNumber == phoneNumber {
                let viewController = UIStoryboard(name: "Database", bundle: nil).instantiateViewController(identifier: "DatabaseMainViewController") as! DatabaseMainViewController
                viewController.administrator = administrator
                self.navigationController?.pushViewController(viewController, animated: true)
                break
            }
        }

        
    }
    
    
}

// MARK: - UITextFieldDelegate

extension MainLoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location > 32 { return false}

        if textField == phoneNumberTextField {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(with: "+XXX (XX) XXX-XX-XX", phone: newString)
            return false
        }
       return true
    }
    
}
