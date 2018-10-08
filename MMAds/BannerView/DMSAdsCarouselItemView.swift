//
//  DMSAdsCarouselItemView.swift
//  MMAds
//
//  Created by L.D. Deurman on 21/09/2018.
//  Copyright © 2018 deurman. All rights reserved.
//

import UIKit


class DMSAdsCarouselItem {
    
    var imageSrc:String?
    var imageContentMode:UIViewContentMode = .scaleAspectFit;
    
    var title:String?
    var subTitle:String?
    
    var titleFont:UIFont = UIFont(name: "AvenirNext-Medium", size: 13)!;
    var subTitleFont:UIFont = UIFont(name: "AvenirNext-Regular", size: 10)!;
    
    var titleColor:UIColor = UIColor.black;
    var subTitleColor:UIColor = UIColor.gray;
    
    var backgroundColor:UIColor = UIColor.white;
    
    var margin:CGFloat = 8.0;
    var topMargin:CGFloat = 9.0;
    
    var brandImageObject:DMSAdsImage?
    var bottomImageObject:DMSAdsImage?
    var priceObject:DMSAdsPrice?
    
    var url:String?
    
    init(dictionary:NSDictionary) {
        
        if let url = dictionary["url"] as? String {
            self.url = url;
        }
        
        if let contentModeValue = dictionary["content_mode"] as? Int {
            self.imageContentMode = UIViewContentMode.init(rawValue: contentModeValue) ?? .scaleAspectFit;
        }
        
        if let src = dictionary["image_src"] as? String {
            self.imageSrc = src;
        }
        
        self.title = dictionary["title"] as? String;
        self.subTitle = dictionary["sub_title"] as? String;
        if let titleFont = parseFont(dictionary: dictionary, key: "title_font") {
            self.titleFont = titleFont;
        }
        
        if let subTitleFont = parseFont(dictionary: dictionary, key: "sub_title_font")  {
            self.subTitleFont = subTitleFont;
        }
        
        if let color = dictionary["title_color"] as? String {
            self.titleColor = UIColor(hexString: color);
        }
        
        if let color = dictionary["sub_title_color"] as? String {
            self.subTitleColor = UIColor(hexString: color);
        }
        
        if let price = dictionary["price"] as? NSDictionary {
            self.priceObject = DMSAdsPrice(dictionary: price);
        }
        
        if let bottomImage = dictionary["bottom_image"] as? NSDictionary {
            self.bottomImageObject = DMSAdsImage(dictionary: bottomImage);
        }
        
        
        if let brandImage = dictionary["brand_image"] as? NSDictionary {
            self.brandImageObject = DMSAdsImage(dictionary: brandImage);
        }
    }
    
    func parseFont(dictionary:NSDictionary, key:String) -> UIFont? {
        if let fontDictionary = dictionary[key] as? NSDictionary {
            if let name = fontDictionary["name"] as? String {
                if let size = fontDictionary["size"] as? CGFloat {
                    return UIFont(name: name, size: size);
                }
            }
        }
        return nil;
    }
    
    
    class DMSAdsPrice {
        var priceFrom:String?
        var priceTo:String?
        var priceFromColor:UIColor = .darkGray;
        var priceToColor:UIColor = .red;
        
        init (dictionary:NSDictionary) {
            self.priceFrom = dictionary["price_from"] as? String;
            self.priceTo = dictionary["price_to"] as? String;
           
            if let priceFromColorHex = dictionary["price_from_color"] as? String {
                self.priceFromColor = UIColor(hexString: priceFromColorHex);
            }
            
            if let priceToColorHex = dictionary["price_to_color"] as? String {
                self.priceToColor = UIColor(hexString: priceToColorHex);
            }
        }
        
    }
    
    class DMSAdsImage {
        var imageSrc:String?
        var width:CGFloat?
        var height:CGFloat?
        var contentMode:UIViewContentMode = .scaleAspectFit;
        
        init(dictionary:NSDictionary) {
            self.imageSrc = dictionary["image_src"] as? String;
            self.width = dictionary["width"] as?  CGFloat;
            self.height = dictionary["height"] as?  CGFloat;
            if let contentModeValue = dictionary["content_mode"] as? Int {
                self.contentMode = UIViewContentMode.init(rawValue: contentModeValue) ?? .scaleAspectFit;
            }

        }
    }
    
    
    
    
}




class DMSAdsCarouselItemView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private let width:CGFloat = 250;
    private let imageViewHeight:CGFloat = 200;
   
    open var carouselItem:DMSAdsCarouselItem!
    open var scrollView:DMSAdsCarouselScrollView!
    open var style = DMSAdsCarouselScrollViewStyle();
    
    private var layerView:UIButton?
    
    
    
    override func draw(_ rect: CGRect) {
        
        
        
        super.draw(rect);
        
        
        
        let view = self;
        view.backgroundColor = self.carouselItem.backgroundColor;
        
      
        
        
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: self.width, height: self.imageViewHeight));
        imageView.clipsToBounds = true;
        view.addSubview(imageView);
        
        if let imageSrc = self.carouselItem.imageSrc {
            imageView.downloaded(from: imageSrc, contentMode: self.carouselItem.imageContentMode);
        }
        
        imageView.contentMode = self.carouselItem.imageContentMode;
        imageView.clipsToBounds = true;
        
        
        let stackView = createLabelPair(titleLabelText: NSMutableAttributedString(string: self.carouselItem.title ?? ""), subTitleLabelText: NSMutableAttributedString(string: self.carouselItem.subTitle ?? ""), titleFont: self.carouselItem.titleFont, subTitleFont: self.carouselItem.subTitleFont, titleColor: self.carouselItem.titleColor, subTitleColor: self.carouselItem.subTitleColor);
        
        let height = view.bounds.height - imageView.bounds.height;
        
        
        let trailing = NSLayoutConstraint(item: stackView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.right, multiplier: 1, constant:self.carouselItem.margin * -1.0)
        
        let leading = NSLayoutConstraint(item: stackView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant:self.carouselItem.margin)
        let bottom = NSLayoutConstraint(item: stackView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: self.carouselItem.topMargin * -1.0);
        let heightConstraint = NSLayoutConstraint(item: stackView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: height - (self.carouselItem.topMargin * 2));
        
        
        view.addSubview(stackView)
        view.addConstraints([trailing, leading, bottom]);
        stackView.addConstraint(heightConstraint);
        
        view.backgroundColor = UIColor.white;
        stackView.backgroundColor = UIColor.white;
 
        
        if let priceObject = self.carouselItem.priceObject {
            createPriceLabel(view: view, priceObject: priceObject, margin: self.carouselItem.margin);
        }
        
        
        if let brandObject = self.carouselItem.brandImageObject {
            
            let brandImageView = UIImageView(frame: CGRect(x: self.carouselItem.margin, y: self.carouselItem.margin + 3, width: brandObject.width ?? 0, height: brandObject.height ?? 0));
            
            if let imageSrc = brandObject.imageSrc {
                brandImageView.downloaded(from: imageSrc, contentMode: brandObject.contentMode);
            }
            
            
            brandImageView.contentMode = brandObject.contentMode;
            view.addSubview(brandImageView);
            
        }
        
        if let bottomObject = self.carouselItem.bottomImageObject {
            
            let bottomImageView = UIImageView(frame: CGRect(x: self.carouselItem.margin, y: imageView.bounds.height - (bottomObject.height ?? 0) - self.carouselItem.margin, width: bottomObject.width ?? 0, height: bottomObject.height ?? 0));
            
            
            if let imageSrc = bottomObject.imageSrc {
                bottomImageView.downloaded(from: imageSrc, contentMode: bottomObject.contentMode);
            }
            
            bottomImageView.contentMode = bottomObject.contentMode;
            view.addSubview(bottomImageView);
        }
        
        
        view.layer.borderColor = UIColor.lightGray.cgColor;
        view.layer.borderWidth = 0.5;
        
        
        self.layerView = UIButton(frame: rect);
        self.layerView!.backgroundColor = UIColor.black.withAlphaComponent(0);
        self.layerView!.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside);
        self.layerView!.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside);
        self.layerView!.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchCancel);
        self.layerView!.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown);
        self.addSubview(layerView!);
        
        
        
        layer.cornerRadius = 6.0
        layer.masksToBounds = true
        
        view.layer.backgroundColor = UIColor.white.cgColor;

    }
    
    
    
    @objc func touchUpInside(_ sender: UIButton) {
        sender.backgroundColor = UIColor.black.withAlphaComponent(0);
        self.scrollView.showSplitView(carouselItemView: self);
    }
    
    @objc func touchDown(_ sender: UIButton) {
        sender.backgroundColor = UIColor.black.withAlphaComponent(0.5);
        
        
    }
    
    @objc func touchUpOutside(_ sender: UIButton) {
        sender.backgroundColor = UIColor.black.withAlphaComponent(0);
    }
 
    
    private func createLabelPair(titleLabelText:NSMutableAttributedString, subTitleLabelText:NSMutableAttributedString, titleFont:UIFont?, subTitleFont:UIFont?, titleColor:UIColor, subTitleColor:UIColor) -> UIStackView {
        let titleLabel = UILabel();
        titleLabel.attributedText = titleLabelText;
        titleLabel.textColor = titleColor;
        let subtitleLabel = UILabel();
        subtitleLabel.attributedText = subTitleLabelText;
        self.addSubview(titleLabel);
        self.addSubview(subtitleLabel);
        titleLabel.font = titleFont;
        subtitleLabel.font = subTitleFont;
        subtitleLabel.textColor = subTitleColor;
        
        let stackView   = UIStackView()
        stackView.axis  = UILayoutConstraintAxis.vertical
        stackView.distribution  = UIStackViewDistribution.equalSpacing
        
        stackView.addArrangedSubview(titleLabel);
        stackView.addArrangedSubview(subtitleLabel);
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView;
    }
    
    private func createPriceLabel(view:UIView, priceObject:DMSAdsCarouselItem.DMSAdsPrice, margin:CGFloat) {
        let fromPrice = NSMutableAttributedString(string: priceObject.priceFrom ?? "", attributes: [NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue]);
        let toPrice = NSMutableAttributedString(string: priceObject.priceTo ?? "");
        let stackView = createLabelPair(titleLabelText: fromPrice, subTitleLabelText: toPrice, titleFont: UIFont(name: "Futura-Medium", size: 13), subTitleFont: UIFont(name: "Futura-Medium", size: 15), titleColor: priceObject.priceFromColor, subTitleColor: priceObject.priceToColor);
        view.addSubview(stackView);
        let trailing = NSLayoutConstraint(item: stackView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: margin * -1)
        let top = NSLayoutConstraint(item: stackView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: margin);
        view.addConstraints([trailing, top]);
    }

}
