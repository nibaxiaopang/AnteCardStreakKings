//
//  CardsRulesVC.swift
//  AnteCardStreakKings
//
//  Created by jin fu on 2024/12/12.
//


import UIKit

class AnteCardsRulesVC: UIViewController {

    //MARK: - Declare IBOutlets
    @IBOutlet weak var rulesCollectionView: UICollectionView!
    
    //MARK: - Declare Variables
    let pokerHandRankings = [
        "Royal Flush",
        "Straight Flush",
        "Four of a Kind",
        "Full House",
        "Flush",
        "Straight",
        "Three of a Kind",
        "Two Pair",
        "Pair",
        "High Card"
    ]
    
    var currentIndex: Int = 0
    
    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }
    
    //MARK: - Functions
    func setUpCollectionView() {
        self.rulesCollectionView.dataSource = self
        self.rulesCollectionView.delegate = self
        self.rulesCollectionView.register(UINib(nibName: "CardsRulesCVC", bundle: nil), forCellWithReuseIdentifier: "CardsRulesCVC")
    }
    
    func scrollToIndex(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        rulesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    //MARK: - Declare IBActions
    @IBAction func btnLeftScrollCollectionView(_ sender: Any) {
        if currentIndex > 0 {
            currentIndex -= 1
            scrollToIndex(index: currentIndex)
        }
    }
    
    @IBAction func btnRightScrollCollectionView(_ sender: Any) {
        if currentIndex < pokerHandRankings.count - 1 {
            currentIndex += 1
            scrollToIndex(index: currentIndex)
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - Datasource and Delegate Methods
extension AnteCardsRulesVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokerHandRankings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardsRulesCVC", for: indexPath) as? CardsRulesCVC else { return UICollectionViewCell() }
        cell.imgView.image = UIImage(named: pokerHandRankings[indexPath.item])
        cell.lbl.text = pokerHandRankings[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentIndex = indexPath.item
    }
}
