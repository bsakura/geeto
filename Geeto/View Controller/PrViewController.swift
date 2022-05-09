//
//  PrViewController.swift
//  Geeto
//
//  Created by Byan Sakura on 29/04/22.
//

import UIKit

class PrViewController: UITableViewController {
    var project: Project!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        title = project.name
        
    }
    
    // MARK: - Navigation Segue Setup
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddPr" {
            let destinationViewController = segue.destination as! PrDetailViewController
            destinationViewController.delegate = self
        }

        if segue.identifier == "EditPr" {
            let destinationViewController = segue.destination as! PrDetailViewController
            destinationViewController.delegate = self

            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                destinationViewController.itemToEdit = project.items[indexPath.row]
            }
        }
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return project.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrItems", for: indexPath)
        let item = project.items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = project.items[indexPath.row]
            
            item.completed.toggle()
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    // Delete Item
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        project.items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    
    }
    
    // MARK: - Cell Configuration Methods
    private func configureCheckmark(for cell: UITableViewCell, with item: PrItems) {
        let checkmark = cell.viewWithTag(101) as! UILabel
        
        checkmark.text = item.completed ? "✔️" : ""
        if checkmark.text == "✔️" {
            item.deleteReminder()
        }
    }
    
    private func configureText(for cell: UITableViewCell, with item: PrItems) {
        let label = cell.viewWithTag(100) as! UILabel
        label.text = item.text
    }
}

extension PrViewController: PrDetailViewControllerDelegate {
    func prDetailViewControllerDidCancel(_ controller: PrDetailViewController) {
        navigationController?.popViewController(animated: true)

    }
    
    func prDetailViewController(_ controller: PrDetailViewController, didFinishAdding item: PrItems) {
        project.items.append(item)
        
        let indexPath = IndexPath(row: project.items.count - 1, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
        
    }
    
    func prDetailViewController(_ controller: PrDetailViewController, didFinishEditing item: PrItems) {

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        navigationController?.popViewController(animated: true)
    }
}
