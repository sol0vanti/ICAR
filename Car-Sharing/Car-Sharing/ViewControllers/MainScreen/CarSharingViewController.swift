import UIKit
import Firebase

class CarSharingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var table: UITableView!
    var requests: [Request]!
    var indexPath: IndexPath!
    var userEmail: String?
    
    // ----------------------------- VIEW DID LOAD --------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(addBarButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "repeat"), style: .plain, target: self, action: #selector(reloadBarButtonPressed))
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        table.dataSource = self
        table.delegate = self
    }
    
    // ----------------------------- FUNCTIONS -----------------------------
    
    @objc func reloadBarButtonPressed(){
        getData()
    }
    
    func getData(){
        let database = Firestore.firestore()
        database.collection("cars").whereField("email", isEqualTo: self.userEmail!).getDocuments() { (snapshot, error) in
            if error != nil {
                print(String(describing: error))
            } else {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.requests = snapshot.documents.map { d in
                            return Request(id: d.documentID, email: d["email"] as? String ?? "gg@test.com", brand: d["brand"] as? String ?? "brand", model: d["model"] as? String ?? "model", indicator: d["indicator"] as? String ?? "off")
                        
                        }
                        self.table.reloadData() 
                    }
                }
            }
        }
    }
    
    @objc func addBarButtonPressed(){
        let carSharingDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "CarSharingDetailViewController") as? CarSharingDetailViewController
        carSharingDetailViewController?.userEmail = userEmail
        self.navigationController?.pushViewController(carSharingDetailViewController!, animated: true)
    }
    
    // ----------------------------- TABLE VIEW -----------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if requests == nil {
            return 0
        } else {
            return requests.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let request = requests[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CarSharingTableViewCell
        cell.indicator.layer.cornerRadius = 10;
        cell.indicator.layer.masksToBounds = true;
        let database = Firestore.firestore()
        database.collection("cars")
            .whereField("email", isEqualTo: userEmail!)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    let ac = UIAlertController(title: "Error", message: "Can't load cars data.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                } else {
                    cell.name.text = "\(request.brand) \(request.model)"
                    if request.brand == "MERCEDES" {
                        cell.logo.image = UIImage(named: "MERCEDES")
                    } else if request.brand == "BMW" {
                        cell.logo.image = UIImage(named: "BMW")
                    } else if request.brand == "PORSCHE" {
                        cell.logo.image = UIImage(named: "PORSCHE")
                    } else if request.brand == "FERRARI" {
                        cell.logo.image = UIImage(named: "FERRARI")
                    } else {
                        cell.logo.image = nil
                    }
                    if request.indicator == "on" {
                        cell.indicator.backgroundColor = .systemGreen
                    } else if request.indicator == "off" {
                        cell.indicator.backgroundColor = .systemRed
                    } else {
                        cell.indicator.backgroundColor = .systemYellow
                    }
                }
            }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = requests[indexPath.row]
        print(request.id)
        let ac = UIAlertController(title: "Choose", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Borrow / Return", style: .default){_ in
            if request.indicator == "on" {
                let ac = UIAlertController(title: "Confirmation", message: "Are you sure that you want to borrow?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "No", style: .destructive))
                ac.addAction(UIAlertAction(title: "Сonfirm", style: .default) {_ in
                    let database = Firestore.firestore()
                    let docRef = database.collection("cars").document(request.id)
                    docRef.updateData([
                        "indicator": "off"
                    ], completion: {_ in
                        self.getData()
                    })
                })
                self.present(ac, animated: true)
            } else if request.indicator == "off" {
                let ac = UIAlertController(title: "Confirmation", message: "Are you sure that you want to return?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "No", style: .destructive))
                ac.addAction(UIAlertAction(title: "Сonfirm", style: .default) {_ in
                    let database = Firestore.firestore()
                    let docRef = database.collection("cars").document(request.id)
                    docRef.updateData([
                        "indicator": "on"
                    ], completion: {_ in
                        self.getData()
                    })
                })
                self.present(ac, animated: true)
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let request = requests[indexPath.row]
        if editingStyle == .delete {
            tableView.beginUpdates()
            let database = Firestore.firestore()
            database.collection("cars").document(request.id).delete() { error in
                if error != nil {
                    let ac = UIAlertController(title: "Error", message: "You can not delete document from firestore", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                } else {
                    self.requests.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            tableView.endUpdates()
        }
    }
}
