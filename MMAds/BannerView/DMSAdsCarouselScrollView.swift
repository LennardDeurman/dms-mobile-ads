//
//  DMSAdsCarouselScrollView.swift
//  MMAds
//
//  Created by L.D. Deurman on 23/09/2018.
//  Copyright © 2018 deurman. All rights reserved.
//

import Foundation
import UIKit
open class DMSAdsCarouselScrollViewStyle {
    
    open var navigationBarColor:UIColor?
    
    open var navigationBarCloseButtonTintColor:UIColor?
}

class DMSAdsCarouselScrollView : UIScrollView {
    
    
    open var rootViewController:UIViewController?;
    open var items = NSArray();
    open var style = DMSAdsCarouselScrollViewStyle();
    
    private var isPresenting = false;
    public var activeIndex:Int = 0;
    
    open func initAd(items:NSArray, carouselItemWidth:CGFloat, rootViewController:UIViewController) {
        self.items = items;
        self.rootViewController = rootViewController;
        self.showsHorizontalScrollIndicator = false;
        buildCarouselItems(carouselItemWidth: carouselItemWidth);
    }
    
    open func initWithExistingItems(items:NSArray, activeIndex:Int, carouselItemWidth:CGFloat, rootViewController:UIViewController) {
        self.items = items;
        self.isPresenting = true;
        self.rootViewController = rootViewController;
        self.showsHorizontalScrollIndicator = false;
        buildCarouselItems(carouselItemWidth: carouselItemWidth);
        
        if activeIndex < self.items.count {
            self.setContentOffset(CGPoint(x: carouselItemWidth * CGFloat(activeIndex), y: 0), animated: true);
        }
        
    }
    
    private func buildCarouselItems(carouselItemWidth:CGFloat) {
        
        
        for subview in self.subviews {
            subview.removeFromSuperview();
        }
        
        
        let width:CGFloat = carouselItemWidth;
        let height:CGFloat = self.bounds.height;
        var totalContentOffset:CGFloat = 0.0;
        
        for i in 0..<self.items.count {
            if let dictionary = self.items[i] as? NSDictionary {
                
                let x = CGFloat(i) * width;
                
                let view = UIView(frame: CGRect(x: x, y: 0, width: width, height: height));
                //view.backgroundColor = (i % 2) == 0 ? UIColor.black : UIColor.red;
                
                
                let carouselItemView = DMSAdsCarouselItemView(frame: CGRect(x: 0, y: 0, width: 250, height: 250));
                carouselItemView.tag = i;
                carouselItemView.carouselItem = DMSAdsCarouselItem(dictionary: dictionary);
                carouselItemView.scrollView = self;
                view.addSubview(carouselItemView);
                carouselItemView.center = CGPoint(x: width / 2, y: height / 2);
                
                
                
                self.addSubview(view);
                
                totalContentOffset = x + width;
                
                
            }
            
        }
        
        
        self.contentSize = CGSize(width: totalContentOffset, height: self.bounds.height);
        
        
        
        
        
        
    }
    
    public func showSplitView(carouselItemView:DMSAdsCarouselItemView) {

        if self.isPresenting {
            
            if let presentationController = self.rootViewController as? DMSAdsAdPresentationController {
                if let urlString = carouselItemView.carouselItem.url {
                    presentationController.showUrl(url: urlString);
                }
            }
            
        } else {
            
            
            self.activeIndex = carouselItemView.tag;
            let vc = DMSAdsAdPresentationController();
            if let urlString = carouselItemView.carouselItem.url {
                vc.urlString = urlString;
                vc.contentView = self;
                let navVC = UINavigationController(rootViewController: vc);
                self.rootViewController?.present(navVC, animated: false, completion: nil);
            }
        }
        
    }
    
    
    

    
   
    
    
}
