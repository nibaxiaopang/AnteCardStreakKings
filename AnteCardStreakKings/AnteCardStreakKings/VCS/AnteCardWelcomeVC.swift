//
//  WelcomeVC.swift
//  AnteCardStreakKings
//
//  Created by AnteCardStreakKings on 2024/12/12.
//


import UIKit
import Reachability
import AdjustSdk

class AnteCardWelcomeVC: UIViewController {

    //MARK: - Declare IBOutlets
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    //MARK: - Declare Variables
    var reachability: Reachability!
    var adid: String?
    var adsUr: String?
    
    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        imgLogo.layer.cornerRadius = (UIScreen.main.bounds.height * 0.6) / 2
        imgLogo.layer.borderWidth = 2
        imgLogo.layer.borderColor = UIColor(named: "appColor_white")?.cgColor
        
        
        Adjust.adid { adid in
            DispatchQueue.main.async {
                self.adid = adid
                self.configAdsData()
            }
        }
        
        self.activityView.hidesWhenStopped = true
        rdrDealLoadAdsData()
    }
    
    private func configAdsData() {
        if let adid = self.adid, !adid.isEmpty, let adsUr = self.adsUr, !adsUr.isEmpty {
            showAdView("\(adsUr)\(adid)")
        }
    }
    
    private func rdrDealLoadAdsData() {
        
        if !self.needLoadAdsData() {
            return
        }
        
        do {
            reachability = try Reachability()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        if reachability.connection == .unavailable {
            reachability.whenReachable = { reachability in
                self.reachability.stopNotifier()
                self.loadAdsData()
            }
            reachability.whenUnreachable = { _ in
            }
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        } else {
            self.loadAdsData()
        }
    }
    
    private func loadAdsData() {
        self.activityView.startAnimating()
        if let url = URL(string: "https://system.gb\(self.hostUrl())/vn-admin/api/v1/dict-items?dictCode=epiboly_app&name=com.AnteCard.StreakKings&queryMode=list") {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                    self.activityView.stopAnimating()
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        print("req success")
                    } else {
                        print("HTTP CODE: \(httpResponse.statusCode)")
                    }
                }
                
                if let data = data {
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print("JSON: \(jsonResponse)")
                            DispatchQueue.main.async {
                                self.activityView.stopAnimating()
                                
                                let dataArr: [[String: Any]]? = jsonResponse["data"] as? [[String: Any]]
                                if let dataArr = dataArr {
                                    let dic: [String: Any] = dataArr.first ?? Dictionary()
                                    let value: String = dic["value"] as? String ?? ""
                                    let finDic = self.convertToDictionary(from: value)
                                    let adsData = finDic
                                    
                                    if adsData == nil {
                                        return
                                    }
                                    
                                    let adsurl = adsData!["toUrl"] as? String
                                    if adsurl == nil {
                                        return
                                    }
                                    
                                    if adsurl!.isEmpty {
                                        return
                                    }
                                    
                                    let restrictedRegions: [String] = adsData!["allowArea"] as? [String] ?? Array.init()
                                    if restrictedRegions.count > 0 {
                                        if let currentRegion = Locale.current.regionCode?.lowercased() {
                                            if restrictedRegions.contains(currentRegion) {
                                                self.adsUr = adsurl!
                                                self.configAdsData()
                                            }
                                        }
                                    } else {
                                        self.adsUr = adsurl!
                                        self.configAdsData()
                                    }
                                }
                            }
                        }
                    } catch let parsingError {
                        print("error: \(parsingError.localizedDescription)")
                        DispatchQueue.main.async {
                            self.activityView.stopAnimating()
                        }
                    }
                }
            }

            task.resume()
        }
    }
    
    private func convertToDictionary(from jsonString: String) -> [String: Any]? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            return nil
        }
        do {
            if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                return jsonDict
            }
        } catch let error {
            print("JSON error: \(error.localizedDescription)")
        }
        
        return nil
    }
    
}
