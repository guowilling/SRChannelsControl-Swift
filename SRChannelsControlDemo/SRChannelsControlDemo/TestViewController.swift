//
//  TestViewController.swift
//  SRChannelsControlDemo
//
//  Created by Willing Guo on 2017/8/16.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit

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
        let pageViewFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
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
