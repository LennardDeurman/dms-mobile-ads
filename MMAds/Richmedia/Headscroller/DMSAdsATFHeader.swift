//
//  MMATFHeader.swift
//  MMAds
//
//  Created by L.D. Deurman on 29/05/2018.
//  Copyright © 2018 deurman. All rights reserved.
//

import Foundation
import UIKit
class DMSAdsATFHeader {
    
    private var headerView:UIView?
    private var tableBackgroundView:UIView?
    
    
    private var tableView:UITableView
    private var headerVisibilityType:DMSAdsATFHeaderViewType = .completlyVisibile;
    
    public var adjustedInsetHeight:CGFloat = 0;
    
    init (tableView:UITableView, visibilityType:DMSAdsATFHeaderViewType) {
        self.tableView = tableView
        self.headerVisibilityType = visibilityType;
    }
    
    
    public enum DMSAdsATFHeaderViewType {
        case completlyVisibile;
        case partlyVisible;
        case none;
    }
    
    
    public func configureWithAdView(bannerView:UIView, margin:CGFloat) {
        let height = bannerView.bounds.height + margin;
        createContainerView(tableView: self.tableView, bannerView:bannerView, height: height)
    }
    
    
    private func adjustContentInsets(height:CGFloat, tableView:UITableView){
        
        let edgeInsets = UIEdgeInsetsMake(height - self.adjustedInsetHeight, 0, 0, 0)
        tableView.contentInset = edgeInsets
        tableView.scrollIndicatorInsets = edgeInsets
        
    }
    
    
    private func bindConstraints(backgroundView:UIView, headerView:UIView, height:CGFloat) {
        headerView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height))
        headerView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .leading, relatedBy: .equal, toItem: backgroundView, attribute: .leading, multiplier: 1, constant: 0))
        
        backgroundView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .trailing, relatedBy: .equal, toItem: backgroundView, attribute: .trailing, multiplier: 1, constant: 0))
        
        backgroundView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .top, relatedBy: .equal, toItem: backgroundView, attribute: .top, multiplier: 1, constant: 0))

    }
    
    private func createBackgroundView(tableView:UITableView,bannerView:UIView, height:CGFloat){
        let tableBackgroundView = UIView()
        let headerView = DMSAdsATFHFOView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: height));
        headerView.setBannerView(bannerView: bannerView)
        tableBackgroundView.addSubview(headerView);
        self.headerView = headerView;
        self.tableBackgroundView = tableBackgroundView;
        
    }
    
    private func setVisibility(tableView:UITableView, height:CGFloat){
        switch (self.headerVisibilityType) {
        case .completlyVisibile:
               tableView.setContentOffset(CGPoint(x: 0, y: -1 * height), animated: true);
               break;
        case .partlyVisible:
            tableView.setContentOffset(CGPoint(x: 0, y: -0.5 * height), animated: true);
            break;
        case .none:
            
            tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true);
            break;
            
        }
        
     
    }
    
    
    private func createContainerView(tableView:UITableView, bannerView:UIView, height:CGFloat){
        
        adjustContentInsets(height: height, tableView: tableView);
        createBackgroundView(tableView: tableView, bannerView:bannerView, height: height);
        bindConstraints(backgroundView: self.tableBackgroundView!, headerView: self.headerView!, height: height);
        

        tableView.backgroundView = self.tableBackgroundView
        
        
        setVisibility(tableView:tableView, height: height);
      
    }

}
