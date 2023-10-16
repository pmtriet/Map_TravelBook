//
//  ListViewController.swift
//  Map_TravelBook
//
//  Created by Fy Spoti on 16/10/2023.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var titleArray = [String]()
    var idArray = [UUID]()
    
    var choosenTitle = ""

    @IBOutlet weak var viewTable: UITableView!
    override func viewDidLoad() {
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewTable.delegate = self
        viewTable.dataSource = self
        getData()
        
    }
    
    
    @objc func addButtonClicked () {
        performSegue(withIdentifier: "toViewController", sender: nil)
    }


    func getData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        
        fetchRequest.returnsObjectsAsFaults = false
        do {
            
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {
                
                self.titleArray.removeAll(keepingCapacity: false)
                self.titleArray.removeAll(keepingCapacity: false)
                
                for result in results as! [NSManagedObject] {
                    if let title = result.value(forKey: "title") as? String {
                        self.titleArray.append(title)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        self.idArray.append(id)
                    }
                        
                }
            }
        } catch {
            print("Errol")
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toViewController" {
            let destinationVC = segue.destination as! ViewController
            
            
            
        }
    }
    
    
    

}
