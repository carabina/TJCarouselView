//
//  TJCarouselView.swift
//  TJCarouselView
//
//  Created by gw on 2017/12/25.
//  Copyright © 2017年 gw. All rights reserved.
//

import Foundation
import UIKit

fileprivate let pageViewIdentify = "pageViewIdentify"

protocol TJCarouselViewDelegate {
    func carouselView(_ carouselView: TJCarouselView, didSelectItemAt index: Int)
}

enum TJCarouselViewScrollDirection: Int {
    case vertical
    case horizontal
}

enum TJCarouselViewPageControlAlignment: Int {
    case center
    case right
}

class TJCarouselView: UIView {
    
    //MRAK: Private Property
    private var collectionview: UICollectionView!
    private var pageControl: UIPageControl!
    private let flowLayout = UICollectionViewFlowLayout()
    private var timer: Timer?
    private var pageControlContraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    private var didUpdateContraint = false
    private var numberOfPages: Int = 0 {
        didSet {
            if numberOfPages != oldValue {
                needsReset = true
            }
            reloadData()
        }
    }
    private var needsReset: Bool = false
    private var scrollPosition: UICollectionViewScrollPosition {
        return scrollDirection == .vertical ? .centeredVertically : .centeredHorizontally
    }
    
    //MARK: Public Property
    public var resourceItems: [TJCarouselResource]? {
        didSet {
            let (needsIncreatePage, itemsCount) = (numbersOfResourceItems > 1, numbersOfResourceItems)
            numberOfPages = needsIncreatePage ? itemsCount * 100 : itemsCount
        }
    }
    
    private var numbersOfResourceItems: Int {
        get {
            guard let itemsCount = resourceItems?.count else {
                return 0
            }
            return itemsCount
        }
    }
    public var delegate: TJCarouselViewDelegate?
    
    public var pageViewContentMode: UIViewContentMode = UIViewContentMode.scaleAspectFill
    
    public var onlyDisplayText: Bool = false
    
    public var isAutoScrollEnabled: Bool = true
    
    public var pageControlAlignment: TJCarouselViewPageControlAlignment = .center {
        didSet {
            setupConstraint()
        }
    }
    
    public var textPadding: CGFloat = 12
    
    public var timeInterval: TimeInterval = 3.0
    
    public var textColor: UIColor?
    
    public var textLabelHeight: CGFloat = 35.0 {
        didSet {
            setupConstraint()
        }
    }
    
    public var scrollDirection: TJCarouselViewScrollDirection = .horizontal {
        didSet {
            pageControl.isHidden = scrollDirection == .vertical
            flowLayout.scrollDirection = UICollectionViewScrollDirection(rawValue: scrollDirection.rawValue)!
        }
    }
    
    //MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        flowLayout.scrollDirection = UICollectionViewScrollDirection(rawValue: scrollDirection.rawValue)!
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionview = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.backgroundColor = UIColor.clear
        collectionview.isPagingEnabled = true
        collectionview.showsVerticalScrollIndicator = false
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.register(TJCarouselPageView.self, forCellWithReuseIdentifier: pageViewIdentify)
        collectionview.delegate = self
        collectionview.dataSource = self
        self.addSubview(collectionview)
        
        pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pageControl)
        
        setupConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupConstraint() {
        if !didUpdateContraint {
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionview]-0-|", options: NSLayoutFormatOptions(rawValue:  0), metrics: nil, views: ["collectionview": collectionview]))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionview]-0-|", options: NSLayoutFormatOptions(rawValue:  0), metrics: nil, views: ["collectionview": collectionview]))
            didUpdateContraint = true
        }
        if pageControlContraints.count > 0 {
            self.removeConstraints(pageControlContraints)
            pageControlContraints.removeAll()
        }
        pageControlContraints.append(NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: CGFloat(-textLabelHeight / 2)))
        var alignmentConstraint: NSLayoutConstraint
        if pageControlAlignment == .right {
            alignmentConstraint = NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -8)
        } else {
            alignmentConstraint = NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        }
        pageControlContraints.append(alignmentConstraint)
        self.addConstraints(pageControlContraints)
    }
    
    //MARK: Public Method
    public func reloadData() {
        if needsReset {
            needsReset = false
            stopTimer()
            pageControl.currentPage = 0
            pageControl.numberOfPages = numbersOfResourceItems
            pageControl.isHidden = !(numberOfPages > 1) || onlyDisplayText
            collectionview.reloadData()
            //调整初始滚动距离
            adjustOffset()
            if isAutoScrollEnabled && numberOfPages > 1{
                startTimer()
            }
        }
    }
    
    //MARK: Timer Action
    private func startTimer() {
        timer?.invalidate()
        timer = Timer(timeInterval: timeInterval, target: self, selector: #selector(TJCarouselView.autoScroll), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func autoScroll() {
        let currentPageIndex = self.currentIndex()
        let nextPageIndex = currentPageIndex + 1
        self.scroll(to: nextPageIndex)
    }
    
    private func scroll(to pageIndex: Int) {
        let (targetIndex, animated) = pageIndex >= numberOfPages ? (numberOfPages / 2,false) : (pageIndex,true)
        collectionview.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: self.scrollPosition, animated: animated)
    }
    
    private func currentIndex() -> Int {
        let (contentOffset, pageSize) = (collectionview.contentOffset, flowLayout.itemSize)
        let (offset, pageWidth) = scrollDirection == .vertical ? (contentOffset.y + pageSize.height * 0.5, pageSize.height) : (contentOffset.x + pageSize.width * 0.5, pageSize.width)
        let currentIndex = Int(offset / pageWidth)
        return max(0, currentIndex)
    }
    
    private func pageControlIndex(for index: Int) -> Int {
        return index % numbersOfResourceItems
    }
    
    private func adjustOffset() {
        if numberOfPages > numbersOfResourceItems  {
            let offsetItemIndex = numberOfPages / 2
            collectionview.scrollToItem(at: IndexPath(item: offsetItemIndex, section: 0), at: self.scrollPosition, animated: false)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        flowLayout.itemSize = self.bounds.size
        reloadData()
    }
}

extension TJCarouselView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: pageViewIdentify, for: indexPath) as! TJCarouselPageView
        cell.textLabelHeight = textLabelHeight
        cell.textPadding = textPadding
        cell.onlyDisplayText = onlyDisplayText
        cell.contentMode = pageViewContentMode
        cell.textLabel.textColor = textColor ?? UIColor.white
        let index = pageControlIndex(for: indexPath.item)
        let item = self.resourceItems![index]
        cell.configure(item)
        return cell
    }
}

extension TJCarouselView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.carouselView(self, didSelectItemAt: self.currentIndex())
    }
}

extension TJCarouselView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if isAutoScrollEnabled {
            stopTimer()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isAutoScrollEnabled {
            startTimer()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = pageControlIndex(for: currentIndex())
        self.pageControl.currentPage = index
    }
}

