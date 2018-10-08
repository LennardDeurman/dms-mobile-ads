//
//  DemoBannerViewController.swift
//  MMAds
//
//  Created by L.D. Deurman on 03/10/2018.
//  Copyright © 2018 deurman. All rights reserved.
//

import UIKit
import GoogleMobileAds
class DemoBannerViewController: UIViewController {

    
    var bannerView:DMSAdsBannerView?
    var adUnitId:String!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(self.adUnitId);
        
        self.bannerView = DMSAdsBannerView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), rootViewController: self, adUnitId: self.adUnitId, adSize: kGADAdSizeMediumRectangle, validAdSizes: nil, dfpBannerViewSize: CGSize(width: 300, height: 250));
        self.bannerView?.nativeSize = CGSize(width: 350, height: 280);
        self.view.addSubview(bannerView!);
        //self.bannerView?.backgroundColor = UIColor.black;
        
        self.bannerView?.loadAd(dfpRequest: DFPRequest());
     
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        
        self.bannerView?.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2);
        
    }
    
    @IBAction func didPressRefresh(_ sender: UIBarButtonItem) {
        
            self.bannerView?.loadAd(dfpRequest: DFPRequest());
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: true);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setToolbarHidden(true, animated: true);
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
