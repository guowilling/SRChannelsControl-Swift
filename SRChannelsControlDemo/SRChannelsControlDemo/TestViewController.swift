//
//  TestViewController.swift
//  SRChannelsControlDemo
//
//  Created by Willing Guo on 2017/8/16.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit

public let SR_SCREEN_W: CGFloat = UIScreen.main.bounds.size.width
public let SR_SCREEN_H: CGFloat = UIScreen.main.bounds.size.height

public var SR_isIPhoneXSeries: Bool {
    return SR_SCREEN_H >= 812
}

public var SR_NAVGATION_H: CGFloat {
    return SR_isIPhoneXSeries ? 88 : 64
}

class TestViewController: UIViewController {

    fileprivate var titleStyle: SRChannelsTitleStyle
    
    init(titleStyle: SRChannelsTitleStyle) {
        self.titleStyle = titleStyle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        view.backgroundColor = UIColor.white
        
        var titles: [String]
        if titleStyle.isScrollEnabled {
            titles = ["Title1", "Title2", "Title3", "Title4", "Title5", "Title6", "Title7", "Title8", "Title999"]
        } else {
            titles = ["Title1", "Title2", "Title3", "Title4", "Title5"]
        }
        let pageViewFrame = CGRect(x: 0, y: SR_NAVGATION_H, width: view.bounds.width, height: view.bounds.height - SR_NAVGATION_H)
        var childVCs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.sr_randomColor()
            childVCs.append(vc)
        }
        let channelsControl = SRChannelsControl(frame: pageViewFrame, titles: titles, titleStyle: titleStyle, childVCs: childVCs, parentVC: self)
        view.addSubview(channelsControl)
    }
}
