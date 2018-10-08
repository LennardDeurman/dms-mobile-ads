//
//  MMWebView.swift
//  MMAds
//
//  Created by L.D. Deurman on 15/09/2018.
//  Copyright © 2018 deurman. All rights reserved.
//

import UIKit

class MMWebView: UIWebView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var parent:UIView!

    private var previousTouch:UITouch?

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if let first = touches.first?.location(in: parent) {
            
            let yPosNew = first.y;
            print(yPosNew);
            
            if let pt = self.previousTouch {
                let yPosOld = pt.location(in: parent).y;
                print(yPosOld);
                
                print(yPosNew - yPosOld);
                
            }
            
            self.previousTouch = touches.first!;
            
            
            
        }
        
        
        /*guard sender.view != nil else {return}
        let piece = sender.view!
        if let view = self.presentingViewController?.view {
            let translation = sender.translation(in: view)
            let extra = self.bounds.height - piece.frame.minY;
            let newYPos = piece.frame.minY + translation.y;
            
            piece.frame = CGRect(x: piece.frame.minX, y: newYPos > self.bounds.maxY ? self.bounds.maxY : newYPos, width: piece.frame.width, height: piece.frame.height + extra);
            
            sender.setTranslation(CGPoint.zero, in: view)
            
            
        } */
    }
    
    
}
