//  Created on 23/09/2021.

import UIKit

class AppTextField: UITextField {
    
    //MARK:- Properties
    private lazy var floatingLabel = UILabel(frame: CGRect.zero)
    private var floatingLabelTopConstraint: NSLayoutConstraint?
    private var floatingLabelCenterConstraint: NSLayoutConstraint?
    
    private var button = UIButton(type: .custom)
    private var imageView = UIImageView(frame: CGRect.zero)
    
    private let borderLine = CALayer()
    let padding = UIEdgeInsets(top: 4, left: 12, bottom: -10, right: -12)
    
    //MARK:- Border properties
    @IBInspectable  var borderColor: UIColor = UIColor.lightGray
    
    @IBInspectable  var borderSelectedColor: UIColor = UIColor.black
    
    @IBInspectable  var borderErrorColor: UIColor = UIColor.red
    
    @IBInspectable var bottomBoaderHeight: CGFloat = 1.0
    
    var isValidInput: Bool = true {
        didSet {
            self.borderLine.backgroundColor = (isValidInput) ? borderColor.cgColor : borderErrorColor.cgColor
        }
    }
    
    //MARK:- Floating placeholder properties
    @IBInspectable var floatingPlaceholder: String? = nil {
        didSet {
            self.floatingLabel.text = floatingPlaceholder
        }
    }
    
    @IBInspectable var floatingPlaceholderColor: UIColor = UIColor.black {
        didSet {
            self.floatingLabel.textColor = floatingPlaceholderColor
        }
    }
    
    @IBInspectable var floatingPlaceholderBackgroundColor: UIColor = UIColor.clear {
        didSet {
            self.floatingLabel.backgroundColor = self.floatingPlaceholderBackgroundColor
        }
    }
    
    @IBInspectable var floatingPlaceholderFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            self.floatingLabel.font =  self.floatingPlaceholderFont
        }
    }
    
    //MARK:- inits
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    //MARK:- Helper Functions
    func setup() {
        self.addTarget(self, action: #selector(self.textFiledEditingDidBegin), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.textFieldEditingDidEnd), for: .editingDidEnd)
        setupFloatingPlaceholder()
        setupBorderLayer()
    }
    private func setupFloatingPlaceholder() {
        
        self.floatingPlaceholder = (self.floatingPlaceholder != nil) ? self.floatingPlaceholder : placeholder
        
        self.floatingLabel.textColor = self.floatingPlaceholderColor
        self.floatingLabel.font = self.floatingPlaceholderFont
        self.floatingLabel.text = self.floatingPlaceholder
        self.floatingLabel.backgroundColor = self.floatingPlaceholderBackgroundColor
        self.floatingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.floatingLabel.clipsToBounds = true
        self.floatingLabel.frame = CGRect.zero
        
        self.floatingLabel.textAlignment = .left
        self.addSubview(self.floatingLabel)
        
        floatingLabelTopConstraint =  self.floatingLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding.top)
        floatingLabelTopConstraint?.isActive = false
        
        floatingLabelCenterConstraint = self.floatingLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        floatingLabelCenterConstraint?.isActive = true
        
        self.floatingLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: padding.left).isActive = true
        self.floatingLabel.rightAnchor.constraint(greaterThanOrEqualTo: self.rightAnchor, constant: padding.right).isActive = true
        self.floatingLabel.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.placeholder = ""
    }
    
    private func setupBorderLayer() {
        borderStyle = .none
        borderLine.frame = CGRect(x: 0, y: frame.size.height - bottomBoaderHeight, width: bounds.size.width, height: bottomBoaderHeight)
        layer.masksToBounds = true
        borderLine.backgroundColor = borderColor.cgColor
        layer.addSublayer(borderLine)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderLine.frame = CGRect(x: 0, y: frame.size.height - bottomBoaderHeight, width: bounds.size.width, height: bottomBoaderHeight)
    }
    
    //MARK: First responder handling
    @objc private func textFiledEditingDidBegin() {
        
        self.borderLine.backgroundColor = (self.isValidInput) ? self.borderSelectedColor.cgColor : self.borderErrorColor.cgColor
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            
            self.floatingLabelCenterConstraint?.isActive = false
            self.floatingLabelTopConstraint?.isActive = true
            self.bringSubviewToFront(self.floatingLabel)
            
            UIView.animate(withDuration: 0.15, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: { [weak self] in
                guard let self = self else {return}
                //  self.floatingLabel.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                //  self.floatingLabel.transform = self.floatingLabel.transform.scaledBy(x: 0.8, y: 0.8)
                self.floatingLabel.font = self.floatingPlaceholderFont.withSize(self.floatingPlaceholderFont.pointSize - 2)
                self.layoutIfNeeded()
                
            }, completion: nil)
        }
    }
    
    @objc private func textFieldEditingDidEnd() {
        self.borderLine.backgroundColor = (self.isValidInput) ?  self.borderColor.cgColor : self.borderErrorColor.cgColor
        
        if self.text == "" {
            self.floatingLabelTopConstraint?.isActive = false
            self.floatingLabelCenterConstraint?.isActive = true
            self.bringSubviewToFront(self.floatingLabel)
            
            UIView.animate(withDuration: 0.15, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: { [weak self] in
                guard let self = self else {return}
                self.floatingLabel.font = self.floatingPlaceholderFont
                //self.floatingLabel.transform = CGAffineTransform.identity
                self.layoutIfNeeded()
                
            }, completion: nil)
        }
    }
}
