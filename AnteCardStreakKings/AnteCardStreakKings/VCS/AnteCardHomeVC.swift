//
//  AnteCardHomeVC.swift
//  AnteCardStreakKings
//
//  Created by jin fu on 2024/12/12.
//

import UIKit

class AnteCardHomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func shareAction(_ sender: Any) {
        let textToShare = "AnteCard StreakKings is your one-stop destination for exciting card games and learning experiences. "
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
