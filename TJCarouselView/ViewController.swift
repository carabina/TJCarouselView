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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let carouselView1 = TJCarouselView(frame: CGRect(x: 0, y: 50, width: self.view.bounds.size.width, height: 150))
        self.view.addSubview(carouselView1);
        
        let carouselView2 = TJCarouselView(frame: CGRect(x: 0, y: 250, width: self.view.bounds.size.width, height: 150))
        carouselView2.pageControlAlignment = .right
        carouselView2.textPadding = 20
        carouselView2.textLabelHeight = 50
        self.view.addSubview(carouselView2);
        
        let carouselView3 = TJCarouselView(frame: CGRect(x: 0, y: 500, width: self.view.bounds.size.width, height: 50))
        carouselView3.pageControlAlignment = .right
        carouselView3.onlyDisplayText = true
        carouselView3.backgroundColor = UIColor.black
        carouselView3.scrollDirection = .vertical
        self.view.addSubview(carouselView3);
        
        DispatchQueue.global().async {
            sleep(1);
            var items1: [TJCarouselResource] = [TJCarouselResource]()
            for index in 0..<5 {
                let item = CarsouselItem(image: nil,
                                         imageURL: "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-\(index + 1).jpg",
                    attributeText: "这是第\(index + 1)页")
                items1.append(item)
            }
            var items2: [TJCarouselResource] = [TJCarouselResource]()
            for index in 5..<10 {
                let attributeText = NSMutableAttributedString(string: "这是第\(index - 5 + 1)页", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18),NSAttributedStringKey.foregroundColor: UIColor.cyan])
                
                attributeText.setAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20),NSAttributedStringKey.foregroundColor: UIColor.red], range: NSRange(location: 3, length: 1))
                let item = CarsouselItem(image: nil,
                                         imageURL: "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-\(index + 1).jpg",
                    attributeText: attributeText)
                items2.append(item)
            }
            
            var items3: [TJCarouselResource] = [TJCarouselResource]()
            for index in 0..<5 {
                let attributeText = NSMutableAttributedString(string: "这是第\(index)页", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18),NSAttributedStringKey.foregroundColor: UIColor.cyan])
                
                attributeText.setAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20),NSAttributedStringKey.foregroundColor: UIColor.red], range: NSRange(location: 3, length: 1))
                let item = CarsouselItem(image: nil,imageURL: nil,attributeText: attributeText)
                items3.append(item)
            }
            DispatchQueue.main.async {
                carouselView1.resourceItems = items1
                carouselView2.resourceItems = items2
                carouselView3.resourceItems = items3
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


