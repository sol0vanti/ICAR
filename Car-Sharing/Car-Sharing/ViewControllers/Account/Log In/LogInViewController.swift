import UIKit
import FirebaseAuth
import Firebase

class LogInViewController: UIViewController {
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    static var logInError: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        let signUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    @IBAction func logInButtonClicked(_ sender: UIButton) {
        let error = Helping.checkTextFields(errorLabel: errorLabel, nicknameField: emailTextField, passwordField: passwordTextField)
        
        guard error == nil else {
            Helping.showError(text: error!, label: errorLabel, textFields: [emailTextField, passwordTextField])
            return
        }
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                
                let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CarSharingViewController") as! CarSharingViewController
                self.navigationController?.pushViewController(destVC, animated: true)
            }
        }
    }
}
