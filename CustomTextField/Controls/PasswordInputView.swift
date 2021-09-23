//  Created on 23/09/2021.

import UIKit

class PasswordInputView: AppInputView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        self.textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let errorsMessage = validPasswordWithMessage(textField.text)
        if errorsMessage == nil {
            self.hideError()
        } else {
            self.showError(message: errorsMessage)
        }
    }
    
    enum PasswordValidationError {
        case emptyInput
        case numberLimitMismatch
        case noSpecialCharacter
        case capicalLetterAndNumber
    }
    
    func validPasswordWithMessage(_ password: String?) ->  NSAttributedString? {
        
        let errors = self.validPassword(password)
        if errors.count <= 0 {
            let validatedMessage: NSMutableAttributedString = NSMutableAttributedString()
//            validatedMessage.append(NSAttributedString(string: "✅ Valid password\n"))
            validatedMessage.append(NSAttributedString(string: "✅ Between 8 - 16 characters\n"))
            validatedMessage.append(NSAttributedString(string: "✅ At least 1 special character (!#$%^_@)\n"))
            validatedMessage.append(NSAttributedString(string: "✅ Must contain combination of Upper case,lower case,special character and a numeric digit(**Aa@1**)\n"))
            return validatedMessage
            
        } else {
            let errorMessage: NSMutableAttributedString = NSMutableAttributedString()
            
            if errors.contains(.emptyInput) {
//                errorMessage.append(NSAttributedString(string: "❌ Enter password\n"))
                errorMessage.append(NSAttributedString(string: "⏺ Between 8 - 16 characters\n"))
                errorMessage.append(NSAttributedString(string: "⏺ At least 1 special character (!#$%^_@)\n"))
                errorMessage.append(NSAttributedString(string: "⏺ Must contain combination of Upper case,lower case,special character and a numeric digit(**Aa@1**)\n"))
            } else {
                if errors.contains(.numberLimitMismatch) == false {
                    errorMessage.append(NSAttributedString(string: "✅ Between 8 - 16 characters\n"))
                } else {
                    errorMessage.append(NSAttributedString(string: "❌ Between 8 - 16 characters\n"))
                }
                
                if errors.contains(.noSpecialCharacter) == false {
                    errorMessage.append(NSAttributedString(string: "✅ At least 1 special character (!#$%^_@)\n"))
                } else {
                    errorMessage.append(NSAttributedString(string: "❌ At least 1 special character (!#$%^_@)\n"))
                }
                
                if errors.contains(.capicalLetterAndNumber) == false {
                    errorMessage.append(NSAttributedString(string: "✅ Must contain combination of Upper case,lower case,special character and a numeric digit(**Aa@1**)\n"))
                } else {
                    errorMessage.append(NSAttributedString(string: "❌ Must contain combination of Upper case,lower case,special character and a numeric digit(**Aa@1**)\n"))
                }
            }
            return errorMessage
        }
    }
    
    func validPassword(_ password: String?) -> [PasswordValidationError] {
        
        guard let passwordString = password,
              passwordString.isEmpty == false else {
            
            return [.emptyInput]
        }
        
        var errorsArray: [PasswordValidationError] = []
        
        let charactorLimitRegEx  = ".{8,16}$"
        if NSPredicate(format:"SELF MATCHES %@", charactorLimitRegEx).evaluate(with: passwordString) == false {
            errorsArray.append(.numberLimitMismatch)
        }
        
        let specialCharacterRegEx  = ".*[!#$%*_@]+.*"
        if NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx).evaluate(with: passwordString) == false {
            errorsArray.append(.noSpecialCharacter)
        }
        
        let capitalSmallDigitLetterRegEx  = "(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).*"
        if NSPredicate(format:"SELF MATCHES %@", capitalSmallDigitLetterRegEx).evaluate(with: passwordString) == false {
            errorsArray.append(.capicalLetterAndNumber)
        }
        
        return errorsArray
    }
}
