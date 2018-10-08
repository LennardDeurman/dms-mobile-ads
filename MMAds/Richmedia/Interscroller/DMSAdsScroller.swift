//
//  MMScroller.swift
//  MMAds
//
//  Created by L.D. Deurman on 30/05/2018.
//  Copyright © 2018 deurman. All rights reserved.
//

import Foundation
import UIKit
class DMSAdsScroller {
    
    public var isAdLoaded = false;
    
    
    public var topText:String?
    public var bottomText:String?
    
    private var tableView:UITableView
    private var indexPath:IndexPath
    private var scrollHeight:CGFloat
    
    private static let SCROLLER_TABLEVIEWCELL = "interScrollerCell";
    private static let SCROLLER_COLLAPSED_HEIGHT:CGFloat = 0.001;
    
    
    init (tableView:UITableView, indexPath:IndexPath) {
        //tableViewController.edgesForExtendedLayout = [];
        self.tableView = tableView
        self.indexPath = indexPath;
        self.scrollHeight = self.tableView.bounds.height;
        self.tableView.register(DMSAdsScrollerTableViewCell.self, forCellReuseIdentifier: DMSAdsScroller.SCROLLER_TABLEVIEWCELL);
        
    }
    
    func setup(bannerView:UIView?, backgroundView:UIView) {
        self.isAdLoaded = bannerView != nil;
        self.tableView.backgroundView = backgroundView;
        if let bannerViewValue = bannerView {
            backgroundView.addSubview(bannerViewValue);
            bannerViewValue.center = CGPoint(x: backgroundView.bounds.width / 2, y: backgroundView.bounds.height / 2);
        }
        
    }
    
    func scrollViewDidScroll(scrollView:UIScrollView) {
        if !((self.tableView.indexPathsForVisibleRows?.contains(self.indexPath))!) {
            self.tableView.backgroundView?.isHidden = true;
        } else {
            self.tableView.backgroundView?.isHidden = false;
        } 
    }
    
    func scrollerTableViewCell(tableView:UITableView, indexPath:IndexPath) -> DMSAdsScrollerTableViewCell? {
        
        if self.indexPath.section == indexPath.section && self.indexPath.row == indexPath.row {
            
            let cell =  tableView.dequeueReusableCell(withIdentifier: DMSAdsScroller.SCROLLER_TABLEVIEWCELL) as! DMSAdsScrollerTableViewCell;
            cell.backgroundColor = UIColor.clear;
            cell.isHidden = !self.isAdLoaded;
            cell.topText = self.topText;
            cell.bottomText = self.bottomText;
            return cell;
        }
        
        return nil;
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat? {
        
    
        if (indexPath.row == self.indexPath.row && indexPath.section == self.indexPath.section) {
            if (self.isAdLoaded) {
                
                let screenHeight = UIScreen.main.bounds.height;
                if (screenHeight < self.scrollHeight) {
                    return screenHeight;
                } else {
                    return self.scrollHeight;
                }
                
                
            } else {
                return DMSAdsScroller.SCROLLER_COLLAPSED_HEIGHT;
            }
        }
        return nil;
    }
}
