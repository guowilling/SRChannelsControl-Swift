//
//  SRChannelsTitleStyle.swift
//  SRChannelsControlDemo
//
//  Created by https://github.com/guowilling on 2017/8/8.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit

class SRChannelsTitleStyle {
    
    var isScrollEnabled: Bool = false
    
    var titleHeight: CGFloat = 44
    var titleMargin: CGFloat = 20
    var titleFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    var titleNormalColor: UIColor = UIColor(colorWithR: 0, G: 0, B: 0)
    var titleSelectdColor: UIColor = UIColor(colorWithR: 255, G: 0, B: 0)
    
    var isTitleScaling: Bool = false
    var scaleRange: CGFloat = 1.2
    
    var isBottomLineDisplayed: Bool = false
    var bottomLineColor: UIColor = UIColor.orange
    var bottomLineHeight: CGFloat = 2
    
    var isSliderDisplayed: Bool = false
    var sliderColor: UIColor = UIColor.black
    var sliderAlpha: CGFloat = 0.1
    var sliderHeight: CGFloat = 25
    var sliderInset: CGFloat = 10
}
