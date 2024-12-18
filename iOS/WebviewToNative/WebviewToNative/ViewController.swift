//
//  ViewController.swift
//  WebviewToNative
//
//  Created by Kotaro Arimura on 2024/12/18.
//

import UIKit
@preconcurrency import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
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
        
        if navigationAction.request.url?.absoluteString.contains("google") == true {
            decisionHandler(.allow)
        } else {
            decisionHandler(.cancel)
            NSLog("navigation canceled")
        }
    }
}



