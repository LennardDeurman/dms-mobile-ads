//
//  MMPlayerViewController.swift
//  MMAds
//
//  Created by L.D. Deurman on 09/09/2018.
//  Copyright © 2018 deurman. All rights reserved.
//

import UIKit
import AVFoundation
class MMPlayerViewController: UIViewController {

    var playerFrame:CGRect!
    var sender:MMPlayerView!
    
    var playerView:MMPlayerView?
    var scrollView:UIScrollView?
    
    var playerContentView:UIImageView?
    var topView:UIView?
    var bottomView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.blue;

        
        //self.view.addSubview(playerView);
        //self.playerView = MMPlayerView(frame: playerFrame);
        //self.playerView!.initWithExistingView(sender: sender, presentingViewController: self);
        //self.view.addSubview(self.playerView!);

        
        self.scrollView = UIScrollView(frame: self.view.frame);
        self.topView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400));
        self.playerContentView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400));
        self.playerContentView?.contentMode = .scaleAspectFill;
        self.playerContentView?.image = UIImage(named: "mmads_landscape_demo");
        self.playerContentView?.backgroundColor = UIColor.darkGray;
        self.bottomView = UIView(frame: CGRect(x: 0, y: 400, width: self.view.frame.width, height: 1200));
        self.bottomView!.backgroundColor = UIColor.brown;
        self.topView!.backgroundColor = UIColor.purple;
        self.scrollView!.backgroundColor = UIColor.black;
        
        self.view.addSubview(self.scrollView!);
        self.scrollView!.addSubview(self.topView!);
        self.scrollView!.addSubview(self.bottomView!);
        self.scrollView!.addSubview(self.playerContentView!)
        
        if #available(iOS 11.0, *) {
            self.scrollView!.contentInsetAdjustmentBehavior = .never
        }
        
    
        
   
       
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //self.playerView?.adjustForView();
        
        if self.scrollView != nil {
            
            
            
            let leading = NSLayoutConstraint(item: self.scrollView!, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.scrollView!.superview!, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
            let bottom = NSLayoutConstraint(item: self.scrollView!, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.scrollView!.superview!, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            
            let trailing = NSLayoutConstraint(item: self.scrollView!, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.scrollView!.superview!, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
            let top = NSLayoutConstraint(item: self.scrollView!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0);
            
            self.scrollView!.backgroundColor = UIColor.white;
            
            self.view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addConstraints([trailing, top, bottom, leading]);
            
            
            if self.topView != nil {
                //height, left, right, top
                
                let left = NSLayoutConstraint(item: self.topView!, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.scrollView!, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
                let right = NSLayoutConstraint(item: self.topView!, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.scrollView!, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
                let top = NSLayoutConstraint(item: self.topView!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.scrollView!, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0);
                let heightConstraint = NSLayoutConstraint(item: self.topView!, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 400);
                
                
                
                self.topView!.addConstraint(heightConstraint)
                self.scrollView!.addConstraints([left, right, top]);
                
                if self.bottomView != nil {
                    //height, left, right, top
                    
                    let left = NSLayoutConstraint(item: self.bottomView!, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.scrollView!, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
                    let right = NSLayoutConstraint(item: self.bottomView!, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.scrollView!, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
                    let top = NSLayoutConstraint(item: self.bottomView!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.topView!, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0);
                    
                    let bottom = NSLayoutConstraint(item: self.bottomView!, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.scrollView!, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0);
                    let heightConstraint = NSLayoutConstraint(item: self.bottomView!, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 1200);
                    
                    
                    
                    self.bottomView!.addConstraint(heightConstraint)
                    self.scrollView!.addConstraints([left, right, bottom, top]);
                }
                
                if self.playerContentView != nil {
                    
                    
                 
                    
                    let left = NSLayoutConstraint(item: self.playerContentView!, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.topView!, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
                    let right = NSLayoutConstraint(item: self.playerContentView!, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.topView!, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
                    let top = NSLayoutConstraint(item: self.playerContentView!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0);
                    top.priority = .defaultHigh;
                    
                    let bottom = NSLayoutConstraint(item: self.playerContentView!, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.topView!, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0);
                    
                    let heightConstraint = NSLayoutConstraint(item: self.playerContentView!, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: self.topView!, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0);
                    heightConstraint.priority = .required;
                    
                    self.scrollView!.addConstraints([left, right, bottom, heightConstraint]);
                    self.view.addConstraint(top);
                }
                
         
            }
            
        }
  
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
