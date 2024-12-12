//
//  WelcomeVC.swift
//  AnteCardStreakKings
//
//  Created by AnteCardStreakKings on 2024/12/12.
//


import UIKit
import Reachability
import Adjust

class AnteCardWelcomeVC: UIViewController, AdjustDelegate {

    //MARK: - Declare IBOutlets
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    //MARK: - Declare Variables
    var reachability: Reachability!
    
    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        imgLogo.layer.cornerRadius = (UIScreen.main.bounds.height * 0.6) / 2
        imgLogo.layer.borderWidth = 2
        imgLogo.layer.borderColor = UIColor(named: "appColor_white")?.cgColor
        
        self.activityView.hidesWhenStopped = true
        rdrDealLoadAdsData()
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
        
        let url = URL(string: "https://open.dafw\(self.hostUrl())/postDeviceDatasForADS")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "appModel": UIDevice.current.model,
            "appKey": "c1b2523d6ec743b1908db4d2a681507e",
            "appPackageId": Bundle.main.bundleIdentifier ?? "",
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? ""
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to serialize JSON:", error)
            self.activityView.stopAnimating()
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Request error:", error ?? "Unknown error")
                    self.activityView.stopAnimating()
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if let resDic = jsonResponse as? [String: Any] {
                        let dictionary: [String: Any]? = resDic["data"] as? Dictionary
                        if let dataDic = dictionary, let data = dataDic["jsonObject"] as? [String: String] {
                            if let adjustTK = data["adjustTK"] {
                                self.initAdjustConfig(token: adjustTK)
                            }
                            
                            if let adsUrl = data["adsUrl"] {
                                self.showAdView(adsUrl)
                            }
                            return
                        }
                    }
                    print("Response JSON:", jsonResponse)
                    self.activityView.stopAnimating()
                } catch {
                    print("Failed to parse JSON:", error)
                    self.activityView.stopAnimating()
                }
            }
        }

        task.resume()
    }
    
    private func initAdjustConfig(token: String) {
        let environment = ADJEnvironmentProduction
        let myAdjustConfig = ADJConfig(
               appToken: token,
               environment: environment)
        myAdjustConfig?.delegate = self
        myAdjustConfig?.logLevel = ADJLogLevelVerbose
        Adjust.appDidLaunch(myAdjustConfig)
        Adjust.trackSubsessionStart()
    }
    
    func adjustEventTrackingSucceeded(_ eventSuccessResponseData: ADJEventSuccess?) {
        print("adjust Event Tracking Succeeded")
    }
    
    func adjustEventTrackingFailed(_ eventFailureResponseData: ADJEventFailure?) {
        print("adjust Event Tracking Failed")
    }
    
    func adjustAttributionChanged(_ attribution: ADJAttribution?) {
        print("adid\(attribution?.adid ?? "")")
    }
    
}
