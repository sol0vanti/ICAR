import UIKit

struct Helping {
    static func showError(text: String, label: UILabel, textFields: [UITextField]){
        label.isHidden = false
        label.text = text
        for textField in textFields {
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor.systemPink.cgColor
        }
    }
    
    static func checkTextFields(errorLabel: UILabel, nicknameField: UITextField, passwordField: UITextField, confirmationField: UITextField? = nil) -> String? {
        if nicknameField.text!.count <= 2 {
            return "Please, enter your nickname, which has to contain more than 2 symbols and try again later"
        } else if passwordField.text!.count <= 4 {
            return "Your password need to have more that 4 symbols to be secure"
        }
        
        guard confirmationField != nil else { return nil }
        
        if confirmationField?.text != passwordField.text {
            return "Your password does not match two times, please try again later"
        }
        
        return nil
    }
}
