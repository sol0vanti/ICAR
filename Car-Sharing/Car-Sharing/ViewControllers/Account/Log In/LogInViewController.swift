import UIKit

class LogInViewController: UIViewController {
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        let signUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    @IBAction func logInButtonClicked(_ sender: UIButton) {
        let ac = UIAlertController(title: "привет Генна", message: "привет", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Привет саша", style: .default))
        present(ac, animated: true)
    }
}
