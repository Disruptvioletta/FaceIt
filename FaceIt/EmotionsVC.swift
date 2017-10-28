//
//  EmotionsVC.swift
//  FaceIt
//
//  Created by Illarionova Violetta on 17/03/2017.
//  Copyright © 2017 Disruptvioletta LLC. All rights reserved.
//

import UIKit

class EmotionsVC: UITableViewController, UISplitViewControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.splitViewController?.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationVC = segue.destination
        if let navigationVC = destinationVC as? UINavigationController {
            destinationVC = navigationVC.visibleViewController ?? destinationVC
        }
        if let faceVC = destinationVC  as? FaceViewController,
            let cell = sender as? UITableViewCell,
        let indexPath = tableView.indexPath(for: cell) {
                faceVC.expression = emotionalFaces[indexPath.row].expression
            faceVC.navigationItem.title = emotionalFaces[indexPath.row].name
        } else if destinationVC is ExpressionEditorTableViewController {
            if let popoverPC = segue.destination.popoverPresentationController {
                popoverPC.delegate = self
            }
        }
    }
    
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if primaryViewController.contents == self {
            if secondaryViewController.contents is Blinking_Face_VC {
                return true
            }
        }
        return false
    }
    
    private var  emotionalFaces: [(name: String, expression: FacialExpression)] = [
        ("sad"     , FacialExpression(eyes: .closed, mouth: .frown)),
        ("happy"   , FacialExpression(eyes: .open  , mouth: .smile)),
        ("worried" , FacialExpression(eyes: .open, mouth: .smirk))
    ]
    
    //MARK: TableView data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return emotionalFaces.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "EmotionCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = emotionalFaces[indexPath.row].name
        return cell
    }
    
    
    @IBAction func addEmotionalFace(from segue: UIStoryboardSegue) {
        if let editor = segue.source as? ExpressionEditorTableViewController {
            emotionalFaces.append((editor.name, editor.expression))
            tableView.reloadData()
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        if traitCollection.verticalSizeClass == .compact {
            return .none
        } else if traitCollection.horizontalSizeClass == .compact {
            return .overFullScreen
        } else {
            return .none
        }
    }
}

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
