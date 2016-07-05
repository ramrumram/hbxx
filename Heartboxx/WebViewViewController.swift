//
//  DashboardViewController.swift
//  api
//
//  Created by dev on 3/25/16.
//  Copyright © 2016 Salon Objectives. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var webView: WKWebView!
    var browserURL = String()
    @IBOutlet weak var ViewDashboard: UIView!
    
    
    override func loadView() {
        super.loadView()
        
        
        /* Create our preferences on how the web page should be loaded */
        let preferences = WKPreferences()
        
        /* Create a configuration for our preferences */
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        
        
        self.webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.navigationDelegate = self
        
        self.view = self.webView!
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
     
      
        self.performSelectorOnMainThread(#selector(WebViewViewController.openBrowserView), withObject: nil, waitUntilDone: true)
        
        
        // Do any additional setup after loading the view, typically from a nib.
        //border and corner for login form
        
            
        
        
        // loginWithKeychain()
    }
    
    
  
    
    
    func openBrowserView() {
        
        
        
        
        
        
        // viewContainer.bringSubviewToFront(viewLoginForm)
        
        
        let requestURL = NSURL(string:browserURL)
        
        let request = NSMutableURLRequest(URL: requestURL!)
        
        
        request.HTTPMethod = "GET"
        
        
        
        
        // if let theWebView = webView{
        /* Load a web page into our web view */
        self.webView!.loadRequest(request)
        //  self.webView?.UIDelegate = self
        self.webView!.navigationDelegate = self
        
        
        ViewDashboard.addSubview(self.webView!)
        
        
        
        //------------right  swipe gestures in view--------------//
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(WebViewViewController.rightSwiped))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        //-----------left swipe gestures in view--------------//
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(WebViewViewController.leftSwiped))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
    }
    
    
    
    /* Start the network activity indicator when the web view is loading */
    func webView(webView: WKWebView,didStartProvisionalNavigation navigation: WKNavigation){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
    }
    
    /* Stop the network activity indicator when the loading finishes */
    func webView(webView: WKWebView,didFinishNavigation navigation: WKNavigation){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        
        
   
        
    }
 
    
    func webViewDidStartLoad(webView
        : UIWebView) {
        
        
        
        
    }
    //MARK: swipe gestures
    func rightSwiped()
    {
        
        if(webView.canGoBack){
            
            webView.goBack()
        }
        
    }
    
    func leftSwiped()
    {
        if (webView.canGoForward){
            
            webView.goForward()
        }
        
        
    }
    
}
