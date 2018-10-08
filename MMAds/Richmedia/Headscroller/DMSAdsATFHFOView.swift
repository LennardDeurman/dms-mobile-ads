//
//  ATFHFOView.swift
//  MMAds
//
//  Created by L.D. Deurman on 29/05/2018.
//  Copyright © 2018 deurman. All rights reserved.
//

import UIKit

class DMSAdsATFHFOView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    
    private var bannerView:UIView?
    
    
    func setBannerView(bannerView:UIView) {
        self.bannerView = bannerView;
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect);
        if let bannerViewValue = self.bannerView {
            createCenterView(adContainer: bannerViewValue)
        }
    }
    
    
    private func createCenterView(adContainer:UIView) {
        
        let width:CGFloat = adContainer.bounds.width
        let height:CGFloat = adContainer.bounds.height
        adContainer.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        self.addSubview(adContainer);
        adContainer.translatesAutoresizingMaskIntoConstraints = false;
        adContainer.addConstraint(NSLayoutConstraint(item: adContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height))
        adContainer.addConstraint(NSLayoutConstraint(item: adContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width))
        self.addConstraint(NSLayoutConstraint(item: adContainer, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: adContainer, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
    }
    
    
}
