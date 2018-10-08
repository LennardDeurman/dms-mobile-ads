

import UIKit
import WebKit
class DMSAdsWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {


    /* There is a know issue in the WebView autolayout constraints, this causes the log to make warnings */
    
    
    var urlString:String!
    var scrollView:UIScrollView!
    
    private var webView:WKWebView!
    var activityIndicator:UIActivityIndicatorView!
    private var isContentLoaded:Bool = false;
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showUrl(url: self.urlString)
        
        self.webView.translatesAutoresizingMaskIntoConstraints = false;
        self.webView.backgroundColor = UIColor.lightGray;
        self.webView.scrollView.isScrollEnabled = false;
        self.webView.isOpaque = true;
        self.webView.navigationDelegate = self;
    }
    
    func showUrl(url:String) {
        self.urlString = url;
        if let url = URL(string: self.urlString) {
            let urlRequest = URLRequest(url: url)
            self.webView.load(urlRequest);
        }
         self.webView.layer.opacity = 0;
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.scrollView.isScrollEnabled = true;
        self.isContentLoaded = true;
        
        UIView.animate(withDuration: 0.5, animations: {
            self.webView.layer.opacity = 1;
        })
        
    }
    

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if webView.scrollView.isScrollEnabled && (navigationAction.navigationType == .formResubmitted || navigationAction.navigationType == .formSubmitted || navigationAction.navigationType == .linkActivated) {
            if let url = navigationAction.request.url {
                decisionHandler(.cancel)
                UIApplication.shared.openURL(url)
            }
        } else {
            decisionHandler(.allow)
        }
        
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: webConfiguration)
        self.webView.uiDelegate = self
        self.scrollView = self.webView.scrollView;
        let view = UIView(frame: .zero);
        view.backgroundColor = UIColor.lightGray;
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge);
        activityIndicator.startAnimating();
        view.addSubview(self.activityIndicator!);
        view.addSubview(self.webView);
        self.view = view;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        self.webView.frame = self.view.frame;
    }
    


}
