//
//  CarouselContainerCell.swift
//  TJCarouselView
//
//  Created by gw on 2018/1/4.
//  Copyright © 2018年 gw. All rights reserved.
//

import UIKit

class CarouselContainerCell: UITableViewCell {
    
    var carouselView: TJCarouselView = TJCarouselView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(carouselView)
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[carouselView]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["carouselView": carouselView]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[carouselView]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["carouselView": carouselView]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
