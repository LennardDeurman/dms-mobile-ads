

import UIKit

class DMSAdsAdPresentationController: UIViewController, UIScrollViewDelegate {

    public var urlString:String!
    public var contentView:UIView?
    
    private var topView:UIView!
    private var bottomView:UIView!
    private var webViewController:DMSAdsWebViewController!
    private var webViewScrollView:UIScrollView!
    private var topViewHeight:CGFloat = 400.00;
    private var draggingStarted = false;
    
    private var playerView:DMSAdsPlayerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.topViewHeight = self.view.bounds.height / 2; //default height is half the screen
        self.view.backgroundColor = UIColor.white;
        
        self.topView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.topViewHeight));
        
        self.edgesForExtendedLayout = []
        
        
        
        
        let image = UIImage(named: "mmads_close_ic");
        let barButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(closeCurrentViewController))
       
        
        if let contentViewValue = self.contentView as? DMSAdsCarouselScrollView {
            self.topViewHeight = 280;
            barButtonItem.tintColor = contentViewValue.style.navigationBarCloseButtonTintColor ?? UIColor.gray;
            self.navigationController?.navigationBar.barTintColor = contentViewValue.style.navigationBarColor ?? UIColor.white;
        
            self.navigationItem.leftBarButtonItem = barButtonItem;
            let items = contentViewValue.items;
            let newScrollView = DMSAdsCarouselScrollView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.topViewHeight));
            newScrollView.initWithExistingItems(items: items, activeIndex: contentViewValue.activeIndex, carouselItemWidth: self.topViewHeight, rootViewController: self);
            self.topView = newScrollView;
        }
        
        
        
        self.bottomView = UIView(frame: CGRect(x: 0, y: self.topView.frame.maxY, width: self.view.bounds.width, height: self.view.bounds.height))
        
        
        self.view.addSubview(self.topView);
        self.view.addSubview(self.bottomView);
        
        self.bottomView.isUserInteractionEnabled = true;
        self.bottomView.backgroundColor = UIColor.lightGray;
        
        self.webViewController = DMSAdsWebViewController();
        self.webViewController.urlString = self.urlString;
        addChildViewController(self.webViewController)
        self.webViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.bottomView.addSubview(self.webViewController.view);
        self.webViewController.didMove(toParentViewController: self);
    
        self.webViewScrollView = self.webViewController.scrollView;
        
        self.webViewScrollView.delegate = self;
        
        self.webViewScrollView.isScrollEnabled = true;
        if #available(iOS 11.0, *) {
            self.webViewScrollView.contentInsetAdjustmentBehavior = .never
        }
        
        
        setupViews();
        
        
        
    }
    
    func showUrl(url:String) {
        self.webViewController.showUrl(url:url);
    }
    
    func setupViews(){
        if let contentViewValue = self.contentView {
            if let senderPlayerView = contentViewValue as? DMSAdsPlayerView {
                
                self.playerView = DMSAdsPlayerView();
                self.playerView!.initWithExistingView(sender: senderPlayerView, topView: self.topView, presentingViewController: self);
                
            }
        }
    }
    

    @objc func closeCurrentViewController() {
        self.navigationController?.dismiss(animated: false, completion: nil)
    }

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        
        self.topView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.topViewHeight > self.view.bounds.height ? self.view.bounds.height : self.topViewHeight);
        self.bottomView.frame = CGRect(x: 0, y: self.topView.frame.maxY, width: self.view.bounds.width, height: self.view.bounds.height)
        self.webViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.webViewController.activityIndicator?.center = CGPoint(x: self.view.bounds.width / 2, y: (self.view.bounds.height - self.topView.frame.height) / 2)
        self.playerView?.adjustForViewMode();

    }
    

    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.draggingStarted = true;

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.draggingStarted {
            let y = self.webViewScrollView.contentOffset.y;
            var newY = self.bottomView.frame.minY - y;
            
            
            if self.playerView?.status != .ended {
                
                if (newY >= self.topView.frame.maxY) {
                    if self.playerView?.status == .paused {
                        self.playerView?.play();
                    }
                    
                } else {
                    self.playerView?.pause();
                }
                
            }
            
            if (newY > self.topView.frame.maxY) {
                newY = self.topView.frame.maxY;
            }
            
        
            
            
            if (newY < 0) {
                newY = 0;
            }
            self.bottomView.frame = CGRect(x: 0, y: newY, width: self.view.bounds.width, height: self.view.bounds.height);
            if newY > 0 {
                
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false);
                
                
            }
        }

    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    



}
