//
//  ForgotPasswordViewController.swift
//  SobeDesce
//
//  Created by User on 01/02/2024.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var resetPasswordBtn: UIButton!
    @IBOutlet weak var emailTextfield: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextfield.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        let email = self.emailTextfield.text ?? ""
        if !(Validator.isValidEmail(email: email)) {
            //error
            return
        }
        AuthService.shared.resetPassword(email: email) { [weak self] error in
            if let error = error {
               //alert the error
                return
            }
            self?.performSegue(withIdentifier: "signInAfterResetPassword", sender: nil)
        }
    }

}
