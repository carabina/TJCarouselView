//
//  ViewController.swift
//  TJCarouselView
//
//  Created by gw on 2017/12/25.
//  Copyright © 2017年 gw. All rights reserved.
//

import UIKit

struct CarsouselItem: TJCarouselResource {
    var image: UIImage?
    var imageURL: String?
    var attributeText: AttributedStringConvertible?
}

class ViewController: UIViewController {
    
    var items: [TJCarouselResource] = [TJCarouselResource]()
    var carouselView: TJCarouselView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        carouselView = TJCarouselView(frame: CGRect(x: 0, y: 100, width: self.view.bounds.size.width, height: 200))
        carouselView.backgroundColor = UIColor.gray
        carouselView.pageControlAlignment = .right
        self.view.addSubview(carouselView)
        
        DispatchQueue.global().async {
            sleep(1);
            for index in 0..<5 {
                let item = CarsouselItem(image: nil,
                                         imageURL: "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-\(index + 1).jpg",
                    attributeText: "这是第\(index)页")
                self.items.append(item)
            }
            DispatchQueue.main.async {
                self.carouselView.items = self.items
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


