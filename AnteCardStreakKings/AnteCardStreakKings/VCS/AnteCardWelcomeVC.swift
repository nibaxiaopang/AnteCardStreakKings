//
//  WelcomeVC.swift
//  AnteCardStreakKings
//
//  Created by jin fu on 2024/12/12.
//


import UIKit

class AnteCardWelcomeVC: UIViewController {

    //MARK: - Declare IBOutlets
    @IBOutlet weak var imgLogo: UIImageView!
    
    
    //MARK: - Declare Variables
    
    
    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        imgLogo.layer.cornerRadius = (UIScreen.main.bounds.height * 0.6) / 2
        imgLogo.layer.borderWidth = 2
        imgLogo.layer.borderColor = UIColor(named: "appColor_white")?.cgColor
    }
    
    
}
