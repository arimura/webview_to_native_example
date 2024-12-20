//
//  ViewController.swift
//  WebviewToNative
//
//  Created by Kotaro Arimura on 2024/12/18.
//

import UIKit
@preconcurrency import WebKit
import FluctSDK

class ViewController: UIViewController, WKNavigationDelegate, FSSRewardedVideoDelegate {
    
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the WKWebView
        webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set navigation delegate to self
        webView.navigationDelegate = self
        
        // Add the webView to the view hierarchy
        view.addSubview(webView)
        
        // Set up constraints to make the webView fill the entire view
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Optionally, load a webpage
        if let url = URL(string: "https://www.google.com/") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        NSLog("url: \(navigationAction.request.url?.absoluteString ?? "")")
        
        if navigationAction.request.url?.absoluteString.contains("corp.fluct.jp") == true {
            decisionHandler(.cancel)
            NSLog("navigation canceled")
            
            FSSRewardedVideo.shared.delegate = self
            FSSRewardedVideo.shared.load(withGroupId: "1000172151", unitId: "1000275015")
        } else {
            decisionHandler(.allow)
        }
    }
    
    func rewardedVideoDidLoad(forGroupID groupId: String, unitId: String) {
        print("rewarded video ad did load")
        if FSSRewardedVideo.shared.hasAdAvailable(forGroupId: "1000172151", unitId: "1000275015") {
            // 動画リワード広告の表示
            FSSRewardedVideo.shared.presentAd(forGroupId: "1000172151", unitId: "1000275015", from: self)
        }
    }
    
    func rewardedVideoShouldReward(forGroupID groupId: String, unitId: String) {
        print("should rewarded for app user")
    }
    
    func rewardedVideoDidFailToLoad(forGroupId groupId: String, unitId: String, error: Error) {
        // refs: error code list are FSSRewardedVideoError.h
        print("rewarded video ad load failed. Because \(error)")
    }
    
    func rewardedVideoWillAppear(forGroupId groupId: String, unitId: String) {
        print("rewarded video ad will appear")
    }
    
    func rewardedVideoDidAppear(forGroupId groupId: String, unitId: String) {
        print("rewarded video ad did appear")
    }
    
    func rewardedVideoWillDisappear(forGroupId groupId: String, unitId: String) {
        print("rewarded video ad will disappear")
    }
    
    func rewardedVideoDidDisappear(forGroupId groupId: String, unitId: String) {
        print("rewarded video ad did disappear")
    }
    
    func rewardedVideoDidFailToPlay(forGroupId groupId: String, unitId: String, error: Error) {
        // refs: error code list are FSSRewardedVideoError.h
        print("rewarded video ad play failed. Because \(error)")
    }
}
