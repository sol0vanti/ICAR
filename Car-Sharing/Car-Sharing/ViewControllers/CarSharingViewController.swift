import UIKit
import Firebase

class CarSharingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var table: UITableView!
    
    private let brands: [String] = ["AUDI", "BMW", "FERRARI", "MERCEDES", "PORSCHE"]
    private var cars: [String] = ["PORSCHE  918 Spyder", "PORSCHE 911 GT3", "PORSCHE 911 GT3 SPORT"]
    private var indicators: [String] = ["on", "off", "on"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(barButtonItemPressed))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        table.dataSource = self
        table.delegate = self
    }
    
    @objc func barButtonItemPressed(){
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CarSharingTableViewCell
        cell.indicator.layer.cornerRadius = 10;
        cell.indicator.layer.masksToBounds = true;
        cell.name.text = cars[indexPath.row]
        if indicators[indexPath.row] == "on" {
            cell.indicator.backgroundColor = .systemGreen
        } else if indicators[indexPath.row] == "off" {
            cell.indicator.backgroundColor = .systemRed
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.indicators[indexPath.row] == "on" {
            let ac = UIAlertController(title: "Confirmation", message: "Are you sure that you want to borrow \(cars[indexPath.row])?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "No", style: .destructive))
            ac.addAction(UIAlertAction(title: "Сonfirm", style: .default) {_ in
                self.indicators[indexPath.row] = "off"
                self.table.reloadData()
            })
            present(ac, animated: true)
        } else if self.indicators[indexPath.row] == "off" {
            let ac = UIAlertController(title: "Confirmation", message: "Are you sure that you want to return \(cars[indexPath.row])?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "No", style: .destructive))
            ac.addAction(UIAlertAction(title: "Сonfirm", style: .default) {_ in
                self.indicators[indexPath.row] = "on"
                self.table.reloadData()
            })
            present(ac, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
