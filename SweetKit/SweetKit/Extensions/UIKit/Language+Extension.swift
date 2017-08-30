import UIKit

public extension UINavigationItem {
    @IBInspectable var language: String {
        set {
            title = newValue.localized()
        }
        get {
            return ""
        }
    }
}

public extension UIBarButtonItem {
    @IBInspectable var language: String {
        set {
            title = newValue.localized()
        }
        get {
            return ""
        }
    }
}

public extension UIView {
    @IBInspectable public var language: String {
        set {
            if newValue != "" {
                setLanguage(language: newValue) }
        }
        get {
            return ""
        }
    }
    
    public func setLanguage(language: String) {
        if let label = self as? UILabel {
            label.text = language.localized()
        }
        //normal
        //heighlighted
        //selected
        //normal:value
        if let button = self as? UIButton {
            let languages = language.components(separatedBy: ";")
            for values in languages {
                let titles = values.components(separatedBy: ":")
                if let key = titles.first, let value = titles.last {
                    if key == "normal" {
                        button.setTitle(value.localized(), for: UIControlState.normal)
                    }
                    if key == "heighlighted" {
                        button.setTitle(value.localized(), for: UIControlState.highlighted)
                    }
                    if key == "selected" {
                        button.setTitle(value.localized(), for: UIControlState.selected)
                    }
                }
            }
            if language.length == 0 {
                button.setTitle(language.localized(), for: UIControlState.normal)
            }
            
        }
    }
    
    @IBInspectable public var placeholaerLanguage: String {
        set {
            if newValue != "" {
                setPlaceholaerLanguage(language: newValue)
            }
        }
        get {
            return ""
        }
    }
    
    public func setPlaceholaerLanguage(language: String) {
        if let textField = self as? UITextField {
            textField.placeholder = language.localized()
        }
    }
    
    @IBInspectable public var buttonDefaultLanguage: String {
        set {
            if newValue != "" {
                setButtonDefaultLanguage(language: newValue)
            }
        }
        get {
            return ""
        }
    }
    
    public func setButtonDefaultLanguage(language: String) {
        if let button = self as? UIButton {
            button.setTitle(language.localized(), for: UIControlState.normal)
        }
    }
    
    @IBInspectable public var buttonHighlightedLanguage: String {
        set {
            if newValue != "" {
                setButtonHighlightedLanguage(language: newValue)
            }
        }
        get {
            return ""
        }
    }
    
    public func setButtonHighlightedLanguage(language: String) {
        if let button = self as? UIButton {
            button.setTitle(language.localized(), for: UIControlState.highlighted)
        }
    }
    
    @IBInspectable public var buttonSelectedLanguage: String {
        set {
            if newValue != "" {
                setButtonSelectedLanguage(language: newValue)
            }
        }
        get {
            return ""
        }
    }
    
    public func setButtonSelectedLanguage(language: String) {
        if let button = self as? UIButton {
            button.setTitle(language.localized(), for: UIControlState.selected)
        }
    }
}
