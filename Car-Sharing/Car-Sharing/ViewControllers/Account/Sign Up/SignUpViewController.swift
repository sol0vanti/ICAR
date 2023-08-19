import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmationTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBAction func logInButtonClicked(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
    }
    
    func showError(_ text: String){
        errorLabel.isHidden = false
        errorLabel.text = text
    }
}
