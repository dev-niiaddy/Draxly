//
//  MainTableViewController.swift
//  Draxly
//
//  Created by Godwin Addy on 6/7/20.
//  Copyright © 2020 Godwin Addy. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var checklistItems = [ChecklistItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationController?.navigationBar.prefersLargeTitles = true
    
        // add items to checklist
        checklistItems.append(
            ChecklistItem(text: "Walk the dog", checked: true))
        checklistItems.append(ChecklistItem(text: "Brush my teeth"))
        checklistItems.append(
            ChecklistItem(text: "Learn iOS Development", checked: true))
        checklistItems.append(ChecklistItem(text: "Soccer Practice"))
        checklistItems.append(ChecklistItem(text: "Eat ice cream"))
        
        
        
        // loop to quickly generate items for testing
//        for i in 0..<100 {
//            checklistItems.append(
//                ChecklistItem(text: "Eat ice cream \(i + 1)")
//            )
//        }
        
        
        print("Documents folder is \(documentsDirectory())")
        print("Documents folder is \(dataFilePath())")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklistItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checklistItem", for: indexPath)
        
        let item = checklistItems[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let item = checklistItems[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        checklistItems.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        saveChecklistItems()
    }
    
    // MARK: - Prepare UI with Data
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        
        let label = cell.viewWithTag(1000) as! UILabel
        
        label.text = item.text
        
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        
        let checkmarkLabel = cell.viewWithTag(1001) as! UILabel
        
        checkmarkLabel.text = item.checked ? "✓" : ""
    }
    
    // MARK: - Helper
    
    func addItem(_ item: ChecklistItem) {
        let newRowIndex = checklistItems.count
        checklistItems.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklist.plist")
    }
    
    func saveChecklistItems() {
        let encoder = PropertyListEncoder()
        
        do {
            
            let data = try encoder.encode(checklistItems)
            
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
            
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    func loadChecklistItems() {
        let file = dataFilePath()
        
        if let data = try? Data(contentsOf: file) {
            
            let decoder = PropertyListDecoder()
            
            do {
                checklistItems = try decoder.decode([ChecklistItem].self,
                                                    from: data)
            } catch {
                print("Error decoding array: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - ItemDetailViewController Delegates
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailView) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailView, didFinishAdding item: ChecklistItem) {
        addItem(item)
        navigationController?.popViewController(animated: true)
        
        saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailView, didFinishEditing item: ChecklistItem) {
        
        if let index = checklistItems.firstIndex(of: item) {
            
            let indexPath = IndexPath(row: index, section: 0)
            
            if let cell =  tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        
        navigationController?.popViewController(animated: true)
        
        saveChecklistItems()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            
            let controller = segue.destination as! ItemDetailView
            controller.delegate = self
            
        } else if segue.identifier == "EditItem" {
            
            let controller = segue.destination as! ItemDetailView
            controller.delegate = self
            
            if let indexPath  = tableView.indexPath(
                for: sender as! UITableViewCell) {
                
                controller.itemToEdit = checklistItems[indexPath.row]
            }
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
