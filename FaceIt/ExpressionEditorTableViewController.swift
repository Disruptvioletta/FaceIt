//
//  ExpressionEditorTableViewController.swift
//  FaceIt
//
//  Created by Illarionova Violetta on 01/07/2017.
//  Copyright © 2017 Disruptvioletta LLC. All rights reserved.
//

import UIKit

class ExpressionEditorTableViewController: UITableViewController {

 
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: false)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return tableView.bounds.size.width
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var eyeControl: UISegmentedControl!
    
    @IBOutlet var emotionControl: UISegmentedControl!
    
    
    var name: String {
        return nameTextField?.text ?? ""
    }
    
    private var eyeChoices = [FacialExpression.Eyes.open, .closed, .squinting]
    private var emotionChoices = [FacialExpression.Mouth.frown, .smirk, .neutral, .grin, .smile]
    
    var expression: FacialExpression {
        return FacialExpression(
            eyes: eyeChoices[eyeControl?.selectedSegmentIndex ?? 0],
            mouth: emotionChoices[emotionControl?.selectedSegmentIndex ?? 0])
    }
    
    
    @IBAction func updateFace() {
        faceViewController?.expression = expression
    }
    
    private var faceViewController: Blinking_Face_VC?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedFace" {
            faceViewController = segue.destination as? Blinking_Face_VC
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "AddEmotion", name.isEmpty {
            disableDoneButton()
            return false
        } else {
            return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    private func disableDoneButton() {
        let alert = UIAlertController(title: "Warning", message: "Please enter a name", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
            self.nameTextField.text = alert.textFields?.first?.text
            self.performSegue(withIdentifier: "AddEmotion", sender: nil)
        }))
        alert.addTextField(configurationHandler: nil)
        present(alert, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let popoverPresentationController = navigationController?.popoverPresentationController {
            if popoverPresentationController.arrowDirection != .unknown {
                navigationItem.leftBarButtonItem = nil
            }
        }
        var size = tableView.minimumSize(forSection: 0)
        size.height -= tableView.heightForRow(at: IndexPath(row: 1, section: 0))
        size.height += size.width
        preferredContentSize = size
    }
  
}

extension UITableView {
    // warning: this forces a cell to be created for every row in that section
    // thus this only makes sense for smaller tables
    // it also does not account for any section headers or footers
    // it may well have other restrictions too :)
    func minimumSize(forSection section: Int) -> CGSize {
        var width: CGFloat = 0
        var height : CGFloat = 0
        for row in 0..<numberOfRows(inSection: section) {
            let indexPath = IndexPath(row: row, section: section)
            if let cell = cellForRow(at: indexPath) ?? dataSource?.tableView(self, cellForRowAt: indexPath) {
                let cellSize = cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
                width = max(width, cellSize.width)
                height += heightForRow(at: indexPath)
            }
        }
        return CGSize(width: width, height: height)
    }
    
    func heightForRow(at indexPath: IndexPath? = nil) -> CGFloat {
        if indexPath != nil, let height = delegate?.tableView?(self, heightForRowAt: indexPath!) {
            return height
        } else {
            return rowHeight
        }
    }
    
}
