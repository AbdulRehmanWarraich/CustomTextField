//  Created on 23/09/2021.

import UIKit

class ViewController: UIViewController {

    @IBOutlet var textField: AppTextField!
    @IBOutlet var appInputView: AppInputView!
    @IBOutlet var passwordInputView: PasswordInputView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func textFieldValid(_ sender: UIButton) {
        textField.isValidInput = !textField.isValidInput
        _ = textField.resignFirstResponder()
    }
    
    @IBAction func inputViewValidate(_ sender: UITextField) {
        appInputView.isValidInput = !appInputView.isValidInput
        if appInputView.isValidInput == false {
            let messageString = NSAttributedString(string: "✅ 1) Put your error message here \n✅ 2) Put your error message here \n❌ 3) Put your error message here")
            appInputView.showError(message: messageString)
        } else {
            appInputView.hideError()
        }
    }

}
