//
//  CustomRefreshControl.swift
//  Unplanner
//
//  Created by Abhishek Patel on 7/15/15.
//  Copyright (c) 2015 StubHubLabs. All rights reserved.
//

import UIKit

protocol CustomRefreshControlDelegate {
    func animateControlBeforeRefreshing(refreshControl: UIRefreshControl, pullDistance: CGFloat, pullRatio: CGFloat, refreshBounds : CGRect)
    func animateControlAfterRefreshing(refreshControl: UIRefreshControl, pullDistance: CGFloat, pullRatio: CGFloat, refreshBounds : CGRect)
}

protocol CustomRefreshControlDatasource {
    func customRefreshControl(refreshControl: UIRefreshControl) -> UIView
}

class CustomRefreshControl: UIRefreshControl {

    private var refreshContainerView: UIView!
    private var overlayView: UIView!
    
    var delegate : CustomRefreshControlDelegate?
    var dataSource : CustomRefreshControlDatasource?
    
    required override internal init() {
        fatalError("use init(frame:) instead")
    }
    
    required internal init(coder aDecoder: NSCoder) {
        fatalError("use init(frame:) instead")
    }
    
    init(frame: CGRect, delegate: CustomRefreshControlDelegate, dataSource: CustomRefreshControlDatasource) {
        super.init()
        bounds.size.width = frame.size.width
        
        self.delegate = delegate
        self.dataSource = dataSource
        
        if let containerView = self.dataSource?.customRefreshControl(self) {
            self.refreshContainerView = containerView
            
            self.addSubview(containerView)
        }
    }
    
    func updateControl() {
        self.refreshContainerView.removeFromSuperview()
        
        if let containerView = self.dataSource?.customRefreshControl(self) {
            self.refreshContainerView = containerView
            
            self.addSubview(containerView)
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        var refreshBounds = self.bounds;
        
        // Distance the table has been pulled
        var pullDistance = max(0.0, -self.frame.origin.y);
        var pullRatio = min(max(pullDistance, 0.0), 140.0) / 140.0;
        
        refreshBounds.size.height = pullDistance;
        
        [self.refreshContainerView].map({$0.frame = refreshBounds});
        
        if refreshing {
            self.delegate?.animateControlAfterRefreshing(self, pullDistance: pullDistance, pullRatio: pullRatio, refreshBounds : refreshBounds)
        } else {
            self.delegate?.animateControlBeforeRefreshing(self, pullDistance: pullDistance, pullRatio: pullRatio, refreshBounds : refreshBounds)
        }
    }
}
