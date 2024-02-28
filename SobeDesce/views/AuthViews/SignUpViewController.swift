//
//  SignUpViewController.swift
//  SobeDesce
//
//  Created by User on 30/01/2024.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        firstNameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        errorLabel.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let name = firstNameTextField.text ?? ""
        let email = emailTextField.text ??  ""
        let password = passwordTextField.text ?? ""
        
        if !(Validator.isValidEmail(email: email)) || !(Validator.isValidPassword(password: password)) {
            self.errorLabel.text = "Invalid email or password"
            self.errorLabel.isHidden = false
            return
        }
        
        AuthService.shared.registerUser(name: name, email: email, password: password) { [weak self] wasRegistered, error in
            guard let self = self else { return }
            if let error = error {
                self.errorLabel.isHidden = false
                self.errorLabel.text = error.localizedDescription
                return
            }
            //save the name to the users db table
            self.performSegue(withIdentifier: "showHomeAfterAccount", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHomeAfterAccount" {
            segue.destination.navigationItem.hidesBackButton = true
        }
    }
}
