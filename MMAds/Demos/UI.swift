//
//  Item.swift
//  MMAds
//
//  Created by L.D. Deurman on 28/05/2018.
//  Copyright © 2018 deurman. All rights reserved.
//

import Foundation
import UIKit
class Item {
    var src:String;
    var title:String;
    var subTitle:String;
    
    init(src:String, title:String, subtitle:String) {
        self.src = src;
        self.title = title;
        self.subTitle = subtitle;
    }
    
    
    static func getDemoItems() -> [Item] {
        
        let item1 = Item(src: "boardwalk.jpg", title: "Boardwalk", subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam condimentum nulla ac mi venenatis, vel malesuada risus vestibulum. Donec non rhoncus dui, a consectetur elit. Pellentesque sed leo risus.");
        let item2 = Item(src: "beach.jpg", title: "Beach & sun", subtitle: "Cras interdum elementum nulla vel facilisis. Suspendisse cursus, ligula eget tempus suscipit, tortor massa dignissim nisl, sit amet dignissim justo mi id purus.");
        let item3 = Item(src: "alps.jpg", title: "Alps & mountains", subtitle: "Donec consequat nibh non ante cursus, ut scelerisque sapien bibendum. Suspendisse lobortis, nunc ac mollis semper, urna sapien semper libero, eu blandit tellus nisi a mauris. Nunc vitae metus quis turpis hendrerit malesuada eget sit amet erat.");
        let item4 = Item(src: "adventure.jpg", title: "Adventure", subtitle: "Sed vitae consectetur nibh, vehicula vehicula quam. Aenean porta eleifend lacus non convallis. Cras aliquam turpis non nunc eleifend tristique. Mauris rhoncus velit quis turpis molestie.");
        let item5 = Item(src: "asia.jpg", title: "Asia", subtitle: "Duis vehicula elit sit amet velit suscipit, sit amet laoreet quam malesuada. Duis aliquet ullamcorper lobortis. Nunc quis orci a diam elementum pellentesque. In hac habitasse platea dictumst. Sed tincidunt congue elementum. Nullam tincidunt dictum lectus, vel lobortis arcu maximus nec. Cras consectetur elementum lorem, in consectetur nisl rutrum vitae.")
        let item6 = Item(src: "greece.jpg", title: "Greece", subtitle: "Cras a lorem scelerisque, tincidunt arcu ac, tempus turpis. Aliquam sed ex in sapien aliquet molestie at ac diam. Aliquam neque dolor, dictum eget sem ac, facilisis varius nisl. Aliquam dignissim viverra porttitor.");
        let item7 = Item(src: "cliffs.jpg", title: "Cliffs", subtitle: "Curabitur gravida rutrum mi vitae laoreet. Cras eu laoreet eros, sed maximus libero. Aliquam tempus elit nec ligula blandit, id placerat metus mollis. In molestie nisl mauris, et sodales orci pharetra non. Phasellus pellentesque tortor imperdiet eros elementum dictum. ");
        let item8 = Item(src: "country.jpg", title: "Countryside", subtitle: "Maecenas pharetra, tortor consectetur faucibus semper, enim nibh accumsan metus, quis pulvinar libero erat ac magna. Vivamus risus metus, tempus eget justo sed, placerat venenatis tortor. ");
        let item9 = Item(src: "paris.jpg", title: "Paris", subtitle: "In in sem id augue rutrum lobortis. Morbi commodo imperdiet quam in tempor. Maecenas nec eros volutpat quam dictum vehicula. Quisque nec augue scelerisque ligula imperdiet condimentum. ");
        let item10 = Item(src: "road.jpg", title: "Roadtrip", subtitle: "Quisque molestie leo est, vitae pellentesque augue posuere ac. Nulla vulputate sagittis arcu ut finibus. Donec blandit vulputate mi a rutrum. In vel mauris eros. Praesent tempus vulputate quam, in ultrices ex mattis nec. ");
        let item11 = Item(src: "backpack.jpg", title: "Backpack", subtitle: "Morbi congue semper quam, sit amet luctus risus bibendum in. Mauris tellus est, feugiat posuere erat id, suscipit sollicitudin purus. Sed id leo nec tortor tempus consectetur sit amet non elit.")
        let item12 = Item(src: "exotic.jpg", title: "Exotic", subtitle: "Ut in neque in diam vestibulum vehicula. Nullam et auctor odio, sit amet sodales felis. Mauris volutpat leo in hendrerit vehicula. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae");
        return [item1, item2, item3, item4, item5, item6, item7, item8, item9, item10, item11, item12];
        
    }
}


class NewsTableCell: UITableViewCell {
    
    @IBOutlet weak var itemSubTitle: UILabel!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(item:Item){
        itemImageView.image = UIImage(named: item.src);
        itemTitle.text = item.title;
        itemSubTitle.text = item.subTitle;
        
    }
    
}
