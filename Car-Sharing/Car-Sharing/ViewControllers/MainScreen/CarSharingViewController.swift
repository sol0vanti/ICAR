import UIKit
import Firebase

class CarSharingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var table: UITableView!
    var requests: [Request]!
    var indexPath: IndexPath!
    var userEmail: String?
    
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
    
    @objc func reloadBarButtonPressed(){
        getData()
        table.reloadData()
    }
    
    func getData(){
        let db = Firestore.firestore()
        db.collection("cars").getDocuments { snapshot, error in
            if error != nil {
                print(String(describing: error))
            } else {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.requests = snapshot.documents.map { d in
                            Request(id: d.documentID, email: d["email"] as? String ?? "test@Test.com", brand: d["brand"] as? [String] ?? ["brand"], model: d["model"] as? [String] ?? ["model"], indicator: d["indicator"] as? [String] ?? ["off"])
                        }
                        self.table.reloadData()
                    }
                }
            }
        }
    }
    
    @objc func addBarButtonPressed(){
        let carSharingDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "CarSharingDetailViewController") as? CarSharingDetailViewController
        self.navigationController?.pushViewController(carSharingDetailViewController!, animated: true)
    }
    
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
                if let err = err {
                    let ac = UIAlertController(title: "Error", message: "Can't load cars data.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                } else {
                    cell.name.text = "\(request.brand[indexPath.row]) \(request.model[indexPath.row])"
                    if request.brand[indexPath.row] == "MERCEDES" {
                        cell.logo.image = UIImage(named: "MERCEDES")
                    } else if request.brand[indexPath.row] == "BMW" {
                        cell.logo.image = UIImage(named: "BMW")
                    } else if request.brand[indexPath.row] == "PORSCHE" {
                        cell.logo.image = UIImage(named: "PORSCHE")
                    } else if request.brand[indexPath.row] == "FERRARI" {
                        cell.logo.image = UIImage(named: "FERRARI")
                    } else {
                        cell.logo.image = nil
                    }
                    if request.indicator[indexPath.row] == "on" {
                        cell.indicator.backgroundColor = .systemGreen
                    } else if request.indicator[indexPath.row] == "off" {
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
        
        let ac = UIAlertController(title: "Choose", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Borrow / Return", style: .default){_ in
            if request.indicator[indexPath.row] == "on" {
                let ac = UIAlertController(title: "Confirmation", message: "Are you sure that you want to borrow?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "No", style: .destructive))
                ac.addAction(UIAlertAction(title: "Сonfirm", style: .default) {_ in
                    let database = Firestore.firestore()
                    database.collection("cars")
                        .whereField("email", isEqualTo: self.userEmail!)
                        .getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                let ac = UIAlertController(title: "Error", message: "Can't update database field.", preferredStyle: .alert)
                                ac.addAction(UIAlertAction(title: "OK", style: .default))
                                self.present(ac, animated: true)
                            } else {
                                let document = querySnapshot!.documents.first
                                document?.reference.updateData([
                                    "indicator": "off"
                                ])
                            }
                        }
                    self.table.reloadData()
                })
                self.present(ac, animated: true)
            } else if request.indicator[indexPath.row] == "off" {
                let ac = UIAlertController(title: "Confirmation", message: "Are you sure that you want to return?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "No", style: .destructive))
                ac.addAction(UIAlertAction(title: "Сonfirm", style: .default) {_ in
                    let database = Firestore.firestore()
                    database.collection("cars")
                        .whereField("email", isEqualTo: self.userEmail!)
                        .getDocuments() { (querySnapshot, error) in
                            if error != nil {
                                let ac = UIAlertController(title: "Error", message: "Can't update database field.", preferredStyle: .alert)
                                ac.addAction(UIAlertAction(title: "OK", style: .default))
                                self.present(ac, animated: true)
                            } else {
                                let document = querySnapshot!.documents.first
                                document?.reference.updateData([
                                    "indicator": "on"
                                ])
                            }
                        }
                    self.table.reloadData()
                })
                self.present(ac, animated: true)
            }
        })
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive){_ in
            
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
