//
//  TJCarouselPageView.swift
//  TJCarouselView
//
//  Created by gw on 2017/12/25.
//  Copyright © 2017年 gw. All rights reserved.
//

import UIKit
import Kingfisher

protocol PageViewProvider {
    func createPageView() -> UICollectionViewCell
}

class TJPageViewProvider: PageViewProvider {
    func createPageView() -> UICollectionViewCell {
        return TJCarouselPageView()
    }
}

class TJCarouselPageView: UICollectionViewCell {
    
    public let imageView: UIImageView = UIImageView()
    public let textLabel: UILabel = UILabel()
    private let textContainer: UIView = UIView()
    private let textDimBackgroundView: UIView = UIView()
    public var textPadding: CGFloat? {
        didSet {
            if textPadding == oldValue {
                return
            }
            self.setNeedsUpdateConstraints()
            self.updateConstraintsIfNeeded()
        }
    }
    public var textLabelHeight: CGFloat? {
        didSet {
            if textLabelHeight == oldValue {
                return
            }
            self.setNeedsUpdateConstraints()
            self.updateConstraintsIfNeeded()
        }
    }
    public var onlyDisplayText: Bool = false {
        didSet {
            if onlyDisplayText == oldValue {
                return
            }
            textDimBackgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: onlyDisplayText ? 0 : 0.4)
            imageView.isHidden = onlyDisplayText
            self.setNeedsUpdateConstraints()
            self.updateConstraintsIfNeeded()
        }
    }
    private var textLabelContraints: [NSLayoutConstraint]?
    private var textContainerConstraints: [NSLayoutConstraint]?
    private var didUpdateConstraint: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageView);
        
        textContainer.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(textContainer)
        
        textDimBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        textDimBackgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        textContainer.addSubview(textDimBackgroundView)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.systemFont(ofSize: 15)
        textContainer.addSubview(textLabel)
        
        setupContraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupContraints() {
        if !didUpdateConstraint  {
            self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[imageView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["imageView":imageView]))
            self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[imageView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["imageView":imageView]))
            self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[textContainer]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["textContainer":textContainer]))
            textContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[textDimBackgroundView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["textDimBackgroundView":textDimBackgroundView]))
            textContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[textDimBackgroundView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["textDimBackgroundView":textDimBackgroundView]))
            textContainer.addConstraint(NSLayoutConstraint(item: textLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: textContainer, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
            
            didUpdateConstraint = true
        }
        if textLabelContraints != nil {
            textContainer.removeConstraints(textLabelContraints!)
        }
        if textContainerConstraints != nil {
            self.contentView.removeConstraints(textContainerConstraints!)
        }
        textLabelContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-textPadding-[textLabel]-textPadding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["textPadding": textPadding ?? 0], views: ["textLabel": textLabel])
        textContainer.addConstraints(textLabelContraints!)
        
        if onlyDisplayText {
            textContainerConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[textContainer]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["textContainer":textContainer])
            self.contentView.addConstraints(textContainerConstraints!)
        } else {
            textContainerConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[textContainer(==height)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["height": textLabelHeight ?? 0], views: ["textContainer":textContainer])
            self.contentView.addConstraints(textContainerConstraints!)
        }
    }
    
    override func updateConstraints() {
        setupContraints()
        super.updateConstraints()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension TJCarouselPageView {
    func configure(_ item: TJCarouselResource) {
        
        textLabel.attributedText = item.attributeText?.asAttributeString()
        
        if let image = item.image {
            imageView.image = image
        } else {
            if let imageURL = item.imageURL {
                imageView.kf.setImage(with: URL(string: imageURL))
            }
        }
    }
}

