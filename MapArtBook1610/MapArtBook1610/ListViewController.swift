//
//  ListViewController.swift
//  MapArtBook1610
//
//  Created by Minh Triet Pham on 16/10/2023.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var titleArray = [String]()
    var idArray = [UUID]()
    
    var chosenTitle = ""
    var chosenTitleId: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClick))

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
    }
    
    func getData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                self.idArray.removeAll(keepingCapacity: false)
                self.titleArray.removeAll(keepingCapacity: false)
                
                
                for result in results as! [NSManagedObject] {
                    if let title = result.value(forKey: "title") as? String {
                        self.titleArray.append(title)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        self.idArray.append(id)
                    }
                    self.tableView.reloadData()
                }
                
            }
        } catch {
            print("error")
        }
    }
    
    @objc func addButtonClick() {
        chosenTitle = ""
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenTitle = titleArray[indexPath.row]
        chosenTitleId = idArray[indexPath.row]
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.selectedTitle = chosenTitle
            destinationVC.selectedTitleId = chosenTitleId
        }
    }
    

    

}