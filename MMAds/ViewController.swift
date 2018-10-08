//
//  ViewController.swift
//  MMAds
//
//  Created by L.D. Deurman on 08/09/2018.
//  Copyright © 2018 deurman. All rights reserved.
//

import UIKit
import GoogleMobileAds




class ViewController: UIViewController, GADAppEventDelegate, GADBannerViewDelegate {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let themeColor = "#B40808";
        UITabBar.appearance().tintColor = UIColor(hexString: themeColor);
        
        
        
        UINavigationBar.appearance().barTintColor   = UIColor(hexString: themeColor)
        
        UINavigationBar.appearance().tintColor = UIColor.white // for titles, buttons, etc.
        
        
        let navigationTitleFont = UIFont(name: "Avenir", size: 20)!
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: navigationTitleFont, NSAttributedStringKey.foregroundColor: UIColor.white]
        
        UIToolbar.appearance().backgroundColor = UIColor(hexString: themeColor);
        UIToolbar.appearance().tintColor = UIColor.white;
        UIToolbar.appearance().barTintColor = UIColor(hexString: themeColor);
        
        
        
       
        
        //bannerView.loadAd(dfpRequest: DFPRequest());
        
        
        
        
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DemoBannerViewController {
            if let identifier = segue.identifier {
                switch (identifier){
                case "carouselAd":
                    print("carouselAd");
                    destination.adUnitId = "/35445201/dmsads_native_carousel_ad";
                    break;
                case "splitAd":
                    print("splitAd");
                    destination.adUnitId = "/35445201/dmsads_native_video_ad";
                    break;
                default:
                    destination.adUnitId = "/35445201/dmads_banner_demo";
                    break;
                }
            }
        }
    }
 
   
    
  
    
    func getDemoDictionary() -> NSDictionary {
        let dictionary:NSDictionary = [
            "url": "https://www.funda.nl",
            "image_src": "https://images.tedbakerimages.com/us%2Fc%2FPIK-Crew-neck-cotton-T-shirt--Navy%2FTS7M_PIK_NAVY_2.jpg.jpg?o=a18iizmF@eIJ3PRrH2OW6jlyncUj&V=OZ60&w=564%26h=705%26q=85",
            "content_mode": 2,
            "title": "Ted Baker",
            "sub_title": "MALTTEA TEXTURED CREW NECK - Trui",
            "price": [
                "price_from": "£65.50",
                "price_to": "£32.50"
            ],
            "bottom_image": [
                "width": 50,
                "height": 50,
                "image_src": "https://www.incsmart.biz/assets/images/discountart.png"
            ],
            "brand_image": [
                "width": 65,
                "height": 35,
                "image_src": "https://cdn.shopify.com/s/files/1/1567/7015/collections/TED_BAKER_1_1024x1024.png?v=1491319979"
            ]
        ]
        return dictionary;
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
      
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true);
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        //let vc = DemoArticleController();
        //present(vc, animated: true, completion: nil);

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


