//
//  DMPresentationController.swift
//  MMAds
//
//  Created by L.D. Deurman on 17/09/2018.
//  Copyright © 2018 deurman. All rights reserved.
//

import UIKit

class DMPresentationController: UIViewController {

    var webView:UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addHeaderToWebView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        self.webView = UIWebView()
        self.webView.loadRequest(URLRequest(url: URL(string: "https://www.randstad.nl")!))
        self.view = self.webView;
    }
    
    func addHeaderToWebView(){
        // We load the headerView from a Nib
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 400));
        headerView.backgroundColor = UIColor.blue;
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        webView.scrollView.addSubview(headerView)
        
        // the constraints
        let topConstraint = NSLayoutConstraint(item: headerView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: headerView, attribute: .leading, relatedBy: .equal, toItem: webView, attribute: .leading, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: headerView, attribute: .trailing, relatedBy: .equal, toItem: webView, attribute: .trailing, multiplier: 1, constant: 0)
        
        webView.addConstraints([topConstraint])
        webView.addConstraints([leftConstraint, rightConstraint])
    }
    
    // Function called in viewWillLayoutSubviews: to update the scrollview of the webView content inset
    func updateWebViewScrollViewContentInset(){
        webView.scrollView.contentInset = UIEdgeInsetsMake(400, 0, 0, 0)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateWebViewScrollViewContentInset()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
