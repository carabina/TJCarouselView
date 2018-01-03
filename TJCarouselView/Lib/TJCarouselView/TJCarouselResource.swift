//
//  TJCarouselResource.swift
//  TJCarouselView
//
//  Created by tianjian on 2017/12/25.
//  Copyright © 2017年 gw. All rights reserved.
//

import Foundation
import UIKit

protocol TJCarouselResource {
    var image: UIImage? { get }
    var imageURL: String? { get }
    var attributeText: AttributedStringConvertible? { get }
}

protocol AttributedStringConvertible {
    func asAttributeString() -> NSAttributedString
}

extension String: AttributedStringConvertible {
    func asAttributeString() -> NSAttributedString {
        return NSAttributedString(string: self)
    }
}

extension NSAttributedString: AttributedStringConvertible {
    func asAttributeString() -> NSAttributedString {
        return self
    }
}

