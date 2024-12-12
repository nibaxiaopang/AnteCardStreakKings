//
//  SolitaireGameVC.swift
//  AnteCardStreakKings
//
//  Created by jin fu on 2024/12/12.
//


import UIKit

class AnteCardSolitaireGameVC: UIViewController {
    
    //MARK: - Declare IBOutlets
    @IBOutlet weak var undoBarButtonItem: UIButton!
    @IBOutlet weak var redoBarButtonItem: UIButton!
    @IBOutlet weak var solitaireView: AnteCardSolitaireView!
    
    //MARK: - Declare Variables
    
    
    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //        if let undoManager = undoManager { // never true?
        //            undoBarButtonItem.enabled = undoManager.canUndo
        //            redoBarButtonItem.enabled = undoManager.canRedo
        //        }
        
        undoBarButtonItem.isEnabled = false
        redoBarButtonItem.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(AnteCardSolitaireGameVC.undoManagerCheckpoint(_:)), name: NSNotification.Name.NSUndoManagerCheckpoint, object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Functions
    @objc func undoManagerCheckpoint(_ notification : Notification) {
        if let undoManager = undoManager {
            undoBarButtonItem.isEnabled = undoManager.canUndo
            redoBarButtonItem.isEnabled = undoManager.canRedo
        }
    }
    
    
    //MARK: - Declare IBAction
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func redeal(_ sender: UIButton) {
        let alert = UIAlertController(title: "New Game?", message: "Redeal cards?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Redeal", style: .destructive, handler: {
            [unowned self] action in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.solitaire.freshGame()
            self.solitaireView.collectAllCardsInStock()
            self.solitaireView.layoutCards()
            self.undoManager?.removeAllActions() // does *not* trigger NSUndoManagerCheckpointNotification
            self.undoBarButtonItem.isEnabled = false
            self.redoBarButtonItem.isEnabled = false
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func undo(_ sender: UIButton) {
        undoManager?.undo()
    }
    
    @IBAction func redo(_ sender: UIButton) {
        undoManager?.redo()
    }
    
}
