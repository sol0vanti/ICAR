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
        navigationController?.navigationBar.tintColor = .systemCyan
    }
    @IBAction func logInButtonClicked(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        Helping.checkTextFields(errorLabel: errorLabel, nicknameField: nicknameTextField, passwordField: passwordTextField, confirmationField: confirmationTextField)
        let ac = UIAlertController(title: "Success", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default){_ in
            let destVC = self.storyboard?.instantiateViewController(withIdentifier: "CarSharingViewController") as? CarSharingViewController
            self.navigationController?.pushViewController(destVC!, animated: true)
        })
        present(ac, animated: true)
    }
}
