//
//  PrDetailViewController.swift
//  Geeto
//
//  Created by Byan Sakura on 29/04/22.
//

import UIKit

class PrDetailViewController: UITableViewController {
    
  
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var doneBarButton: UIBarButtonItem!
    @IBOutlet var textField: UITextField!

    @IBOutlet weak var setReminderToggle: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: PrDetailViewControllerDelegate?
    
    var itemToEdit: PrItems?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
            datePicker.date = item.dueDate
        }
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    @IBAction func setReminderToggled() {
        textField.resignFirstResponder()
        
        if setReminderToggle.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(
                options: [.alert, .sound]) { _, _ in
                    // pass
                }

        }
    }
    
    @IBAction func cancel() {
        delegate?.prDetailViewControllerDidCancel(self)
    }
    
  
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            item.requireReminder = setReminderToggle.isOn
            item.dueDate = datePicker.date
            item.setReminder()
            
            delegate?.prDetailViewController(self, didFinishEditing: item)
        } else {
            let item = PrItems(text: textField.text!)
            item.requireReminder = setReminderToggle.isOn
            item.dueDate = datePicker.date
            item.setReminder()
            delegate?.prDetailViewController(self, didFinishAdding: item)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
    

// MARK: - Textfield Delegate Methods

extension PrDetailViewController: UITextFieldDelegate {
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

protocol PrDetailViewControllerDelegate: AnyObject {
    func prDetailViewControllerDidCancel(_ controller: PrDetailViewController)
    
    func prDetailViewController(_ controller: PrDetailViewController, didFinishAdding item: PrItems)
    
    func prDetailViewController(_ controller: PrDetailViewController, didFinishEditing item: PrItems)
}

