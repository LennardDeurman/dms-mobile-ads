//
//  DMSAdsBannerView.swift
//  MMAds
//
//  Created by L.D. Deurman on 28/09/2018.
//  Copyright © 2018 deurman. All rights reserved.
//

import UIKit
import GoogleMobileAds

protocol DMSAdsBannerViewDelegate {
    func didFailWithError(bannerView:DMSAdsBannerView, error:NSError);
    func didReceiveAd(bannerView:DMSAdsBannerView);
}

class DMSAdsBannerView: UIView, GADAppEventDelegate, GADBannerViewDelegate, DMSAdsPlayerViewDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private var dfpBannerView:DFPBannerView?
    private var nativeBannerData:NSDictionary?
    
    
    private static let NATIVE_BANNER_AD = "nativeBannerAd";
    private static let RELOAD_AD = "reload";
    private static let PUBLISHER_PROVIDED_ID = "publisher_provided_id";
    
    private static let NATIVE_BANNER_CAROUSEL = 1;
    private static let NATIVE_BANNER_VIDEO = 2;
    
    public var rootViewController:UIViewController!
    public var dfpBannerViewSize:CGSize!
    public var adUnitId:String!
    public var adSize:GADAdSize!
    public var validAdSizes:[NSValue]?
    public var delegate:DMSAdsBannerViewDelegate?
    
    public var nativeSize:CGSize?
    public var mediationClassNames:[String] = [];
    
    private var playerView:DMSAdsPlayerView?
    private var carouselScrollView:DMSAdsCarouselScrollView?
    
    private var isLoaded = false;
    
    
    
    
    init(frame: CGRect, rootViewController:UIViewController, adUnitId:String, adSize:GADAdSize, validAdSizes:[NSValue]?, dfpBannerViewSize:CGSize) {
        super.init(frame: frame);
        
        self.rootViewController = rootViewController;
        self.dfpBannerViewSize = dfpBannerViewSize;
        self.adUnitId = adUnitId;
        self.validAdSizes = validAdSizes;
        self.adSize = adSize
        
        self.layer.masksToBounds = true;
        self.dfpBannerView = DFPBannerView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: self.dfpBannerViewSize));
        self.dfpBannerView?.adUnitID = self.adUnitId;
        self.dfpBannerView?.adSize = self.adSize;
        self.dfpBannerView?.validAdSizes = self.validAdSizes;
        self.dfpBannerView?.appEventDelegate = self;
        self.dfpBannerView?.rootViewController = self.rootViewController;
        self.dfpBannerView?.delegate = self;
        self.addSubview(self.dfpBannerView!);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    public func loadAdWithInfo(customTargeting:[AnyHashable:Any]?, publisherProvidedId:String?) {
        let request = DFPRequest();
        request.customTargeting = customTargeting;
        request.publisherProvidedID = publisherProvidedId;
        loadAd(dfpRequest: request);
    }
    
    public func loadAd(dfpRequest:DFPRequest) {
        self.isLoaded = false;
        self.nativeBannerData = nil;
        self.dfpBannerView?.load(dfpRequest);
    }
    
    public func loadAdWithData(data:[AnyHashable : Any]){
        let publisherProvided = data[DMSAdsBannerView.PUBLISHER_PROVIDED_ID] as? String;
        self.loadAdWithInfo(customTargeting: data, publisherProvidedId: publisherProvided);
    }
    
    public func notifyVisibilityLost() {
        if self.playerView?.status != .paused {
            self.playerView?.pause();
        }
    }
    
    public func notifyVisibilityReceived() {
        if self.playerView?.status != .playing {
            self.playerView?.play();
        }
    }
    
    
    private func getDictionary(string:String) -> NSDictionary? {
        let data = string.data(using: .utf8)!
        if let jsonArray = try? JSONSerialization.jsonObject(with: data, options : .allowFragments) as? NSDictionary
        {
            return jsonArray;
        }
        return nil;
    }
    
    func adView(_ banner: GADBannerView, didReceiveAppEvent name: String, withInfo info: String?) {
        
        
        if name == DMSAdsBannerView.NATIVE_BANNER_AD {
            if let infoValue = info {
                if let dictionary = getDictionary(string: infoValue) {
                    self.nativeBannerData = dictionary;
                    
                
                    if self.isLoaded {
                        if let adSize = self.nativeSize {
                            self.frame = CGRect(x: 0, y: 0, width: adSize.width, height: adSize.height);
                            self.superview!.setNeedsLayout();
                            self.superview!.layoutIfNeeded();
                        }
                        
                        setupNativeBanner(dictionary: dictionary);
                    }
                }
                

            }
        }
        
        if name == DMSAdsBannerView.RELOAD_AD {
       
            
            if let infoValue = info {
                if let dictionary = getDictionary(string: infoValue) as? [AnyHashable:Any] {
                    let publisherProvided = dictionary[DMSAdsBannerView.PUBLISHER_PROVIDED_ID] as? String;
                    self.loadAdWithInfo(customTargeting: dictionary, publisherProvidedId: publisherProvided);
                }
            }
           
        }
    }
    
    private func checkSubViews(view:UIView, classNames:[String]) -> CGSize? {
        for subView in view.subviews {
            
            let className = String(describing: type(of: view));
            if classNames.contains(className) {
                return subView.frame.size;
            }
            
            if subView.subviews.count > 0 {
                return checkSubViews(view: subView, classNames: classNames);
            }
        }
        return nil;
    }
    
    
    private func findMediationViewSize(bannerView:GADBannerView) -> CGSize? {
        return checkSubViews(view: bannerView, classNames: self.mediationClassNames);
    }
    
    
    func createPlayerView(dictionary:NSDictionary) {
        
        if let urlStr = dictionary["media_url"] as? String {
            if let webUrl = dictionary["web_url"] as? String {
   
                
                self.playerView = DMSAdsPlayerView(frame: CGRect(x: 0, y: 0, width: 1, height: 1));
                self.addSubview(self.playerView!);
                self.playerView?.initAd(urlStr: urlStr, webUrl:webUrl, rootViewController: self.rootViewController);
                self.playerView?.delegate = self;

                self.playerView?.play();
            }
        }
        
        
    }
    
    func createCarousel(dictionary:NSDictionary) {

        if let items = dictionary["items"] as? NSArray {
            var width:CGFloat = 280;
            if let carouselItemWidth = dictionary["carousel_item_width"] as? CGFloat {
                width = carouselItemWidth;
            }
            self.carouselScrollView = DMSAdsCarouselScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height));
            self.addSubview(self.carouselScrollView!);
            self.carouselScrollView?.initAd(items: items, carouselItemWidth: width, rootViewController: self.rootViewController)
            
        }
        
        
        
    }
    
    func playerViewReady(view: DMSAdsPlayerView) {
        self.playerView?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height);
        
    }
    
    private func setupNativeBanner(dictionary:NSDictionary) {
        if let type = dictionary["type"] as? Int {
        
            
            if type == DMSAdsBannerView.NATIVE_BANNER_VIDEO {
                createPlayerView(dictionary: dictionary);
            }
            if type == DMSAdsBannerView.NATIVE_BANNER_CAROUSEL {
                createCarousel(dictionary: dictionary);
            }
        }
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        self.delegate?.didFailWithError(bannerView: self, error: error);
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.isLoaded = true;
        
        var size = bannerView.adSize.size;
        if let adSize = self.nativeSize {
            if self.nativeBannerData != nil {
                size = adSize;
            }
        }
        
        if let mediationSize = findMediationViewSize(bannerView: bannerView) {
            size = mediationSize;
        }
        
        
        self.carouselScrollView?.removeFromSuperview();
        self.playerView?.removeFromSuperview();
        
        if let dictionary = self.nativeBannerData {
            setupNativeBanner(dictionary: dictionary);
        }

        
        self.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height);
        self.superview!.setNeedsLayout();
        self.superview!.layoutIfNeeded();
        
        self.delegate?.didReceiveAd(bannerView: self);
    }
    

}
