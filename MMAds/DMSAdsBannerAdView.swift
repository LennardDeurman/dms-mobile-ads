//
//  DMSAdsBannerAdView.swift
//  MMAds
//
//  Created by L.D. Deurman on 24/09/2018.
//  Copyright © 2018 deurman. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
open class DMSAdsCarouselScrollViewStyle {
    
    open var navigationBarColor:UIColor?
    
    open var navigationBarCloseButtonTintColor:UIColor?
}



public class DMSAdsBannerAdView : UIView, GADBannerViewDelegate, GADAppEventDelegate, DMSAdsPlayerViewDelegate {
    
    
    private var playerView:DMSAdsPlayerView?
    private var bannerView:UIView?
    private var carouselView:DMSAdsCarouselScrollView?
    
    private var isLoaded = false;
    private var nativeBannerData:NSDictionary?
    //private var bannerViewAdSize:CGSize?
    
    //public static let AD_SIZE = "adSize";
    //public static let RELOAD_AD = "reloadAd";
    public static let NATIVE_BANNER_AD = "nativeBannerAd";
    
    public static let NATIVE_BANNER_CAROUSEL = 1;
    public static let NATIVE_BANNER_VIDEO = 2;
    
    public var dfpBannerViewSize:CGSize!
    public var dfpAdUnitId:String!
    public var dfpAdSize:GADAdSize!
    public var dfpValidAdSizes:[NSValue]?
    public var rootViewController:UIViewController!
    
    
    public var dfpBannerView:DFPBannerView!
    
    private var isViewLoaded = false;
    
    //public var mediationClassNames:[String] = [];
    //public var closeProtection:Bool = false;
    
    private var currentTargeting:[AnyHashable : Any]?
    private var publisherProvidedId:String?
    private var shouldFireRequest = false;
    
    public override func draw(_ rect: CGRect) {

         super.draw(rect);
        
        self.bannerView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        self.bannerView!.layer.masksToBounds = true;
        self.dfpBannerView = DFPBannerView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: self.dfpBannerViewSize));
        self.dfpBannerView.adUnitID = self.dfpAdUnitId;
        self.dfpBannerView.adSize = self.dfpAdSize;
        self.dfpBannerView.validAdSizes = self.dfpValidAdSizes;
        self.dfpBannerView.rootViewController = self.rootViewController;
        self.dfpBannerView.appEventDelegate = self;
        self.dfpBannerView.delegate = self;
        
        
        self.carouselView = DMSAdsCarouselScrollView(frame: rect);
        self.carouselView?.backgroundColor = UIColor.darkGray;
        
        addSubview(self.carouselView!);
        addSubview(self.bannerView!);
        
        self.isViewLoaded = true;
        
        if self.shouldFireRequest {
            loadAdWithInfo(targeting: self.currentTargeting, publisherProvidedId: self.publisherProvidedId);
        }
        
        
    }
    
    
    func createPlayerView(dictionary:NSDictionary) {
        
        if let urlStr = dictionary["media_url"] as? String {
            if let webUrl = dictionary["web_url"] as? String {
                self.playerView?.removeFromSuperview();
                self.playerView = DMSAdsPlayerView(frame: CGRect(x: 0, y: 0, width: 1, height: 1));
                self.playerView?.initAd(urlStr: urlStr, webUrl:webUrl, rootViewController: self.rootViewController);
                self.playerView?.delegate = self;
                self.playerView?.backgroundColor = UIColor.red;
                addSubview(self.playerView!);
            }
        }
        
        
        self.carouselView?.isHidden = true;
        self.bannerView?.isHidden = true;
        self.playerView?.isHidden = false;
        
    }
    
    func createCarousel(dictionary:NSDictionary) {
        if let items = dictionary["items"] as? NSArray {
            var width:CGFloat = 280;
            if let carouselItemWidth = dictionary["carousel_item_width"] as? CGFloat {
                width = carouselItemWidth;
            }
            self.carouselView?.initAd(items: items, carouselItemWidth: width, rootViewController: self.rootViewController)
            
        }
        
        self.carouselView?.isHidden = false;
        self.bannerView?.isHidden = true;
        self.playerView?.isHidden = true;
        
    }
    
    func playerViewReady(view: DMSAdsPlayerView) {
        
        
        self.playerView?.frame = CGRect(x: 0, y: 0, width: 300, height: 250);
        self.playerView?.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2);
    }
    
    
    
    
    
    
    
    public func adView(_ banner: GADBannerView, didReceiveAppEvent name: String, withInfo info: String?) {
        
        
        
        /*if name == DMSAdsBannerAdView.AD_SIZE {
            if let infoValue = info {
                if let dictionary = getDictionary(string: infoValue) {
                    self.bannerViewAdSize = getAdSize(dictionary: dictionary);
                }
            }
        }
        
        if name == DMSAdsBannerAdView.RELOAD_AD {
            loadAdWithInfo(info: info);
         } */
        
        
        if name == DMSAdsBannerAdView.NATIVE_BANNER_AD  {
            if let infoValue = info {
                if let dictionary = getDictionary(string: infoValue) {
                    self.nativeBannerData = dictionary;
                }
            }
        }
        
      
        
        
    }
    
    /*private func checkSubViews(view:UIView, classNames:[String]) -> CGSize? {
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
    } */
    
    public func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.isLoaded = true;
        
        print(bannerView.adSize.size);
        
        
        
        setAdSize(size: bannerView.adSize.size);
        
        if let nativeData = self.nativeBannerData {
            
            print(nativeData);
            
        } else {
            self.carouselView?.isHidden = true;
            self.playerView?.isHidden = true;
        }
        
        /*if let bannerViewSize = self.bannerViewAdSize {
            setAdSize(size: bannerViewSize);
        } else {
            if let mediationSize = findMediationViewSize(bannerView: bannerView) {
                if mediationSize.width > 10 && mediationSize.height > 10 {
                    setAdSize(size: mediationSize);
                }
            } else {
                setAdSize(size: bannerView.adSize.size);
            }
            
        } */
        
        //self.carouselView?.isHidden = true;
        //self.playerView?.isHidden = true;
        
        
        
    }
    

    public func loadAdWithInfo(targeting:[AnyHashable : Any]?, publisherProvidedId:String?) {
        if self.isViewLoaded {
            
            self.bannerView?.isHidden = false;
            
            self.isLoaded = false;
            self.nativeBannerData = nil;
            self.shouldFireRequest = false;
            let dfpRequest = DFPRequest();
            dfpRequest.customTargeting = targeting;
            dfpRequest.publisherProvidedID = publisherProvidedId;
            self.dfpBannerView.load(dfpRequest);
            
        } else {
            self.shouldFireRequest = true;
            self.currentTargeting = targeting;
            self.publisherProvidedId = publisherProvidedId;
        }
        
    }
    

    
    
    
    /*private func getAdSize(dictionary:NSDictionary) -> CGSize? {
        if let sizeDictionary = dictionary["size"] as? NSDictionary {
            if let height = sizeDictionary["height"] as? Int {
                if let width = sizeDictionary["width"] as? Int {
                    return CGSize(width: width, height: height);
                }
            }
            
        }
        return nil;
    }
    */
    
    
    
    private func setAdSize(size:CGSize) {
        let height = size.height;

       
        
        if self.bannerView != nil {
            self.bannerView!.frame = CGRect(x: self.bannerView!.frame.minX, y: self.bannerView!.frame.minY, width: size.width, height: size.height);
            print(self.bannerView?.frame);
            print(self.dfpBannerView?.frame);
        }
        
        self.setNeedsLayout();
        self.layoutIfNeeded();
        

        self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: height);
        self.superview!.setNeedsLayout()
        self.superview!.layoutIfNeeded()
        
        
    }
 
    
    private func getDictionary(string:String) -> NSDictionary? {
        let data = string.data(using: .utf8)!
        if let jsonArray = try? JSONSerialization.jsonObject(with: data, options : .allowFragments) as? NSDictionary
        {
            return jsonArray;
        }
        return nil;
    }
    
    public override func layoutSubviews() {
        self.carouselView?.frame = self.frame;
        let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2);
        self.playerView?.center = center;
        self.bannerView?.center = center;
        self.carouselView?.center = center;
        
    }
    
    
}
