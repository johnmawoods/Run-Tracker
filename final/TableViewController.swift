//
//  TableViewController.swift
//  final
//
//  Created by John Woods on 11/14/21.
//

import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet var myTable: UITableView!
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var m:Model?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m = Model(context: managedObjectContext)
        myTable.delegate = self
        myTable.dataSource = self
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (m?.fetchRecord())!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TableViewCell
        cell.layer.borderWidth = 1.0
        
        let runItem = m?.fetchResults[indexPath.row]
        cell.dateLabel.text = runItem?.timeStamp
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell.EditingStyle { return UITableViewCell.EditingStyle.delete }
  
    // implement delete function
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            m?.deleteElement(item: indexPath.row)
            myTable.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedIndex: IndexPath = self.myTable.indexPath(for: sender as! UITableViewCell)!
        
        let runObj = m?.fetchResults[selectedIndex.row]
        print(m?.fetchResults)
        print(runObj)
        
        let destin = segue.destination as! DetailViewController
        
        if(segue.identifier == "toDetail"){
            
            print(runObj!.timeStamp)
            print(runObj!.distance)
            print(runObj!.duration)
            
            destin.dateVC = runObj!.timeStamp
            destin.distanceVC = runObj!.distance
            destin.timeVC = runObj!.duration
            destin.imageVC = runObj!.picture
            
        }
    }


// end brace
}
