//  Created on 23/09/2021.

import UIKit

class AppInputView: UIView {
    //MARK:- Properties
    var stackView =  UIStackView()
    var textField = AppTextField(frame: CGRect.zero)
    let errorLabelContentView = UIView()
    var errorLabel = UILabel()
    
    //MARK:- Error label properties
    @IBInspectable var errorFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            self.errorLabel.font =  self.errorFont
        }
    }
    
    @IBInspectable var errorColor: UIColor = UIColor.red {
        didSet {
            self.errorLabel.textColor = errorColor
        }
    }
    
    @IBInspectable var errorMessage: NSAttributedString? = nil {
        didSet {
            self.errorLabel.attributedText = self.isValidInput ?  nil : errorMessage
        }
    }
    
    //MARK:- Floating placeholder properties
    @IBInspectable var floatingPlaceholder: String? = nil {
        didSet {
            self.textField.floatingPlaceholder = floatingPlaceholder
        }
    }
    
    @IBInspectable var floatingPlaceholderColor: UIColor = UIColor.black {
        didSet {
            self.textField.floatingPlaceholderColor = floatingPlaceholderColor
        }
    }
    
    @IBInspectable var floatingPlaceholderBackgroundColor: UIColor = UIColor.clear {
        didSet {
            self.textField.floatingPlaceholderBackgroundColor = self.floatingPlaceholderBackgroundColor
        }
    }
    
    @IBInspectable var floatingPlaceholderFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            self.textField.floatingPlaceholderFont =  self.floatingPlaceholderFont
        }
    }
    
    var isValidInput: Bool = true {
        didSet {
            self.textField.isValidInput = isValidInput
            self.errorLabel.attributedText = self.isValidInput ?  nil : self.errorMessage
        }
    }
    
    //MARK:- inits
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    //MARK:- Helper Functions
    private func setup() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        self.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        
        textField.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 44)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textField.floatingPlaceholderFont =  floatingPlaceholderFont
        textField.floatingPlaceholderBackgroundColor = floatingPlaceholderBackgroundColor
        textField.floatingPlaceholderColor = floatingPlaceholderColor
        textField.floatingPlaceholder = floatingPlaceholder
        
        errorLabelContentView.translatesAutoresizingMaskIntoConstraints = false
        
        
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(errorLabelContentView)
        
        errorLabel.attributedText = self.isValidInput ?  nil : self.errorMessage
        errorLabel.font = errorFont
        errorLabel.textColor = errorColor
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.numberOfLines = 0
        errorLabelContentView.addSubview(errorLabel)
        errorLabel.leftAnchor.constraint(equalTo: errorLabelContentView.leftAnchor, constant: textField.padding.left).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: errorLabelContentView.rightAnchor, constant: textField.padding.right).isActive = true
        errorLabel.topAnchor.constraint(equalTo: errorLabelContentView.topAnchor).isActive = true
        errorLabel.bottomAnchor.constraint(equalTo: errorLabelContentView.bottomAnchor).isActive = true
        
    }
    
    func showError(message: String?) {
        
        self.errorMessage = NSAttributedString(string: message ?? "")
        self.isValidInput = false
    }
    func showError(message: NSAttributedString?) {
        
        self.errorMessage = message
        self.isValidInput = false
    }
    
    func hideError() {
        self.isValidInput = true
    }
}
