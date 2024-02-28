//
//  SignInViewController.swift
//  SobeDesce
//
//  Created by User on 29/01/2024.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        let loggedIn = AuthService.shared.checkLoggedIn { result in
            if result { self.performSegue(withIdentifier: "showHomeVC", sender: nil)}
        }
        errorLabel.isHidden = true
        emailTextField.text = ""
        passwordTextField.text = ""
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }

    @objc func keyboardWillChange(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if passwordTextField.isFirstResponder {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.view.frame.origin.y = -keyboardSize.height
                            })
                
            }
        }
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        let email = emailTextField.text ??  ""
        let password = passwordTextField.text ?? ""
        
        if !(Validator.isValidEmail(email: email)) || !(Validator.isValidPassword(password: password)) {
            self.errorLabel.text = "Invalid email or password"
            self.errorLabel.isHidden = false
            return
        }
        AuthService.shared.signIn(email: email, password: password) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                //alert with the error
                self.errorLabel.isHidden = false
                self.errorLabel.text = error.localizedDescription
                return
            }
            self.performSegue(withIdentifier: "showHomeVC", sender: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "showForgotPasswordVC", sender: nil)
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHomeVC" {
            segue.destination.navigationItem.hidesBackButton = true
        }
    }
}
