import UIKit
import Firebase

class CarSharingDetailViewController: UIViewController {
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var mercedesButton: UIButton!
    @IBOutlet weak var porscheButton: UIButton!
    @IBOutlet weak var ferrariButton: UIButton!
    @IBOutlet weak var bmwButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var brandButtons: [UIButton]!
    
    var selectedCar = "MERCEDES"
    var selectedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        selectedButton = mercedesButton
    }
    
    @IBAction func continueButtonClicked(_ sender: UIButton){
        if modelTextField.text!.count < 2 {
            modelTextField.layer.borderWidth = 1.5
            modelTextField.layer.borderColor = UIColor.systemRed.cgColor
            errorLabel.isHidden = false
            errorLabel.text = "Please, mention the model of the car. Try again later."
        } else {
//            database.collection("cars").addDocument(data: [
//                "brand": brandTextField.placeholder!,
//                "model": modelTextField.text!,
//                "indicator": "on"
//            ]) { (error) in
//                if error != nil {
//                    self.errorLabel.isHidden = false
//                    self.errorLabel.text = "Error: database isn't working now. Please, try again later"
//                } else {
//                    let ac = UIAlertController(title: "Success", message: "You have just succefully added new car", preferredStyle: .alert)
//                    ac.addAction(UIAlertAction(title: "OK", style: .default){_ in
//                        self.navigationController?.popToRootViewController(animated: true)
//                    })
//                    self.present(ac, animated: true)
//                }
//            }
//            let database = Firestore.firestore()
//            database.collection("cars")
//                .whereField("email", isEqualTo: self.userEmail!)
//                .getDocuments() { (querySnapshot, error) in
//                    if error != nil {
//                        let ac = UIAlertController(title: "Error", message: "Can't update database field.", preferredStyle: .alert)
//                        ac.addAction(UIAlertAction(title: "OK", style: .default))
//                        self.present(ac, animated: true)
//                    } else {
//                        let document = querySnapshot!.documents.first
//                        document?.reference.updateData([
//                            "indicator": "on"
//                        ])
//                    }
//            }
        }
    }
    
    @IBAction func brandButtonsClicked(_ button: UIButton){
        if button == mercedesButton {
            selectedButton.isSelected = false
            selectedCar = "MERCEDES"
            selectedButton = mercedesButton
        } else if button == porscheButton {
            selectedButton.isSelected = false
            selectedCar = "PORSCHE"
            selectedButton = porscheButton
        } else if button == ferrariButton {
            selectedButton.isSelected = false
            selectedCar = "FERRARI"
            selectedButton = ferrariButton
        } else if button == bmwButton {
            selectedButton.isSelected = false
            selectedCar = "BMW"
            selectedButton = bmwButton
        }
        brandTextField.placeholder = selectedCar
        button.isSelected = true
    }
}
    
