import UIKit

struct Helping {
    static func showError(text: String, label: UILabel){
        label.isHidden = false
        label.text = text
    }
    
    static func checkTextFields(errorLabel: UILabel, nicknameField: UITextField, passwordField: UITextField, confirmationField: UITextField){
        if nicknameField.text!.count <= 2 {
            Helping.showError(text: "Please, enter your nickname, which has to contain more than 2 symbols and try again later", label: errorLabel)
            nicknameField.layer.borderWidth = 1.0
            nicknameField.layer.borderColor = UIColor.systemPink.cgColor
        } else if passwordField.text!.count <= 4 {
            Helping.showError(text: "Your password need to have more that 4 symbols to be secure", label: errorLabel)
            passwordField.layer.borderWidth = 1.0
            passwordField.layer.borderColor = UIColor.systemPink.cgColor
        } else if confirmationField.text != passwordField.text {
            Helping.showError(text: "Your password does not match two times, please try again later", label: errorLabel)
            confirmationField.layer.borderWidth = 1.0
            confirmationField.layer.borderColor = UIColor.systemPink.cgColor
        }
    }
    
    private func hello(){}
    public func hello2(){}
    static func hello3(){}
}
