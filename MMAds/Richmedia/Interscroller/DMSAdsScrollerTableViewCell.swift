
//
//  MMScrollerTableViewCell.swift
//  MMAds
//
//  Created by L.D. Deurman on 30/05/2018.
//  Copyright © 2018 deurman. All rights reserved.
//

import UIKit

class DMSAdsScrollerTableViewCell: UITableViewCell {

    public var topText:String?
    public var bottomText:String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect);
       self.backgroundColor = UIColor.clear
        self.selectionStyle = .none;
        self.isUserInteractionEnabled = false;
        addTopLabel()
        addBottomLabel()
    }
    
    private func createLabel(text:String) -> UILabel {
        let label = UILabel()
        label.text = text;
        label.backgroundColor = UIColor.darkGray
        label.textColor = UIColor.white
        label.font = UIFont(name: "Avenir", size: 11)
        label.textAlignment = .center;
        self.addSubview(label)
        bindPresetConstraints(label: label);
        return label;
    }
    
    private func bindPresetConstraints(label:UILabel){
        
        label.addConstraint(NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.addConstraint(NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
    }
    
    private func addTopLabel(){
        let topLabel = createLabel(text: self.topText ?? "Scroll down");
        self.addConstraint(NSLayoutConstraint(item: topLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
    }
    
    private func addBottomLabel(){
        let bottomLabel = createLabel(text: self.bottomText ?? "Content continues below");
        self.addConstraint(NSLayoutConstraint(item: bottomLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
