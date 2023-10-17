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
//    var titleArray = [String]()
//    var idArray = [UUID]()
//    
//    var chosenTitle = ""
//    var chosenTitleId: UUID?
    
    var results = [NSManagedObject]()
    var chosenObject: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClick))

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newPlace"), object: nil)
    }
    
     @objc func getData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        request.returnsObjectsAsFaults = false
        
        do {
            results = try context.fetch(request) as! [NSManagedObject]
            
            if results.count > 0 {
                
                    self.tableView.reloadData()
                }
                
            }
         catch {
            print("error")
        }
    }
    
    @objc func addButtonClick() {
        chosenObject = nil
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = results[indexPath.row].value(forKey: "title") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenObject = results[indexPath.row]
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.selectedObject = chosenObject
            
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
//            
//            let idString = idArray[indexPath.row].uuidString
//            
//            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
//            fetchRequest.returnsObjectsAsFaults = false
            
            
                
            context.delete(results[indexPath.row])
            self.results.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
            
            do {
                try context.save()
            } catch {
                print("error")
            }
        }
    }
}
    

    


