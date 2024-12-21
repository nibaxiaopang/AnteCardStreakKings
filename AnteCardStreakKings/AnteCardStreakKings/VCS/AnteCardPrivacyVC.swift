//
//  AnteCardPrivacyVC.swift
//  AnteCardStreakKings
//
//  Created by AnteCardStreakKings on 2024/12/12.
//

import UIKit
import WebKit

class AnteCardPrivacyVC: UIViewController, WKNavigationDelegate , WKUIDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backLeftBtn: UIButton!
    @IBOutlet weak var bgImageV: UIImageView!
    var webView: WKWebView!
    @objc var urlStr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initSubviews()
        initRequest()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    private func initSubviews() {
        let config = WKWebViewConfiguration.init()
        view.backgroundColor = .black
        webView = WKWebView(frame: view.bounds, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.backgroundColor = .black
        webView.scrollView.backgroundColor = .black
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.isHidden = true
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            webView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])

        activityIndicator.hidesWhenStopped = true
        view.bringSubviewToFront(activityIndicator)
        view.bringSubviewToFront(backLeftBtn)
    }
    
    let privacyUrl = "https://www.termsfeed.com/live/dd5cdece-aa62-459c-952f-a9a285e45927"
    private func initRequest() {
        activityIndicator.startAnimating()
        
        if let urlStr = urlStr {
            backLeftBtn.isHidden = true
            if let url = URL(string: urlStr) {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        } else {
            backLeftBtn.isHidden = false
            if let url = URL(string: privacyUrl) {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }
    }
    
    // WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.webView.isHidden = false
            self.bgImageV.isHidden = true
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("\(error.localizedDescription)")
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.webView.isHidden = false
            self.bgImageV.isHidden = true
        }
    }
    
    // MARK: - WKUIDelegate
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            if let url = navigationAction.request.url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        return nil
    }
    

    @IBAction func btnBackTapped(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
    }

}
