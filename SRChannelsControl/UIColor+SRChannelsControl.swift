//
//  UIColor+SRChannelsControl.swift
//  SRChannelsControlDemo
//
//  Created by https://github.com/guowilling on 2017/8/8.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(colorWithR R : CGFloat, G : CGFloat, B : CGFloat) {
        self.init(red: R / 255.0, green: G / 255.0, blue: B / 255.0, alpha: 1.0)
    }
    
    class func randomColor() -> UIColor {
        return UIColor(colorWithR: CGFloat(arc4random_uniform(256)),
                       G: CGFloat(arc4random_uniform(256)),
                       B: CGFloat(arc4random_uniform(256)))
    }
    
    class func getGRBValue(_ color : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        guard let components = color.cgColor.components else {
            fatalError("Must RGB Color!")
        }
        return (components[0] * 255, components[1] * 255, components[2] * 255)
    }
}
