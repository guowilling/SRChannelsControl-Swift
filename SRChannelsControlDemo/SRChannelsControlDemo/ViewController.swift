//
//  ViewController.swift
//  SRChannelsControlDemo
//
//  Created by Willing Guo on 2017/8/16.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let titleStyle = SRChannelsTitleStyle()
        switch row {
        case 0:
            titleStyle.isScrollEnabled = true
            titleStyle.isTitleScaling = true
            titleStyle.isBottomLineDisplayed = false
            titleStyle.isSliderDisplayed = false
        case 1:
            titleStyle.isScrollEnabled = true
            titleStyle.isTitleScaling = false
            titleStyle.isBottomLineDisplayed = true
            titleStyle.isSliderDisplayed = false
        case 2:
            titleStyle.isScrollEnabled = true
            titleStyle.isTitleScaling = false
            titleStyle.isBottomLineDisplayed = false
            titleStyle.isSliderDisplayed = true
        case 3:
            titleStyle.isScrollEnabled = false
            titleStyle.isTitleScaling = true
            titleStyle.isBottomLineDisplayed = true
            titleStyle.isSliderDisplayed = false
        case 4:
            titleStyle.isScrollEnabled = false
            titleStyle.isTitleScaling = true
            titleStyle.isBottomLineDisplayed = false
            titleStyle.isSliderDisplayed = true
        default: break
        }
        navigationController?.pushViewController(TestViewController(titleStyle: titleStyle), animated: true)
    }
}
