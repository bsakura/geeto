//
//  NewProjectViewController.swift
//  Geeto
//
//  Created by Byan Sakura on 29/04/22.
//

import UIKit

class ListDetailViewController: UITableViewController {

    @IBOutlet var doneBarButton: UIBarButtonItem!
    @IBOutlet var textField: UITextField!
     
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var listToEdit: Project?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let list = listToEdit {
            title = "Edit Project"
            textField.text = list.name
            doneBarButton.isEnabled = true
        }
            }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    

    
    
    // MARK: - Tableview Delegate methods
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 1 ? indexPath : nil
    }
    
    // MARK: - User Actions
    
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let list = listToEdit {
            list.name = textField.text!
            delegate?.listDetailViewController(self, didFinishEditing: list)
        } else {
            let list = Project(name: textField.text!, items: []
            )
            delegate?.listDetailViewController(self, didFinishAdding: list)
        }
    }
}

// MARK: - ListDetail Delegate Methods
protocol ListDetailViewControllerDelegate: AnyObject {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding list: Project)
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing list: Project)
}

// MARK: - Textfield delegate methods
extension ListDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        
        return true
    }
}
