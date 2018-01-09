//
//  TJCarouselResource.swift
//  TJCarouselView
//
//  Created by tianjian on 2017/12/25.
//  Copyright © 2017年 gw. All rights reserved.
//

import Foundation
import UIKit

public protocol TJCarouselResource {
    var image: UIImage? { get }
    var imageURL: String? { get }
    var attributeText: AttributedStringConvertible? { get }
}

public protocol AttributedStringConvertible {
    func asAttributeString() -> NSAttributedString
}

extension String: AttributedStringConvertible {
    public func asAttributeString() -> NSAttributedString {
        return NSAttributedString(string: self)
    }
}

extension NSAttributedString: AttributedStringConvertible {
    public func asAttributeString() -> NSAttributedString {
        return self
    }
}

