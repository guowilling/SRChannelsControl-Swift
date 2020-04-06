//
//  SRChannelsControl.h
//
//  Created by https://github.com/guowilling on 2017/8/16.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit

public protocol SRChannelsControlDelegate: class {
    func channelsControl(_ ctrl: SRChannelsControl, didEndScrollAtIndex atIndex: Int)
    func channelsControl(_ ctrl: SRChannelsControl, didSelectIndex index: Int)
}

extension SRChannelsControlDelegate {
    func channelsControl(_ ctrl: SRChannelsControl, didEndScrollAtIndex atIndex: Int) { }
    func channelsControl(_ ctrl: SRChannelsControl, didSelectIndex index: Int) { }
}

public class SRChannelsControl: UIView {
    
    private var titles: [String]
    private var titleStyle: SRChannelsTitleStyle
    private var childVCs: [UIViewController]
    private weak var parentVC: UIViewController?
    
    var channelsTitle: SRChannelsTitle!
    var channelsContent: SRChannelsContent!
    
    init(frame: CGRect, titles: [String], titleStyle: SRChannelsTitleStyle, childVCs: [UIViewController], parentVC: UIViewController) {
        self.titles = titles
        self.titleStyle = titleStyle
        self.childVCs = childVCs
        self.parentVC = parentVC
        
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: SRChannelsControlDelegate?
    
    var isContentScrollEnabled: Bool {
        get { return channelsContent.collectionView.isScrollEnabled }
        set { channelsContent.collectionView.isScrollEnabled = newValue }
    }
    
    private func setupUI() {
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: titleStyle.titleHeight)
        channelsTitle = SRChannelsTitle(frame: titleFrame, titles: titles, titleStyle: titleStyle)
        channelsTitle.delegate = self
        addSubview(channelsTitle)
        
        let contentFrame = CGRect(x: 0, y: titleFrame.maxY, width: bounds.width, height: frame.height - titleFrame.height)
        channelsContent = SRChannelsContent(frame: contentFrame, childVCs: childVCs, parentVC: parentVC!)
        channelsContent.delegate = self
        addSubview(channelsContent)
    }
}

extension SRChannelsControl: SRChannelsContentDelegate {
    
    func channelsContent(_ channelsContent: SRChannelsContent, scrollFromIndex fromIndex: Int, toIndex: Int, progress: CGFloat) {
        channelsTitle.scroll(fromIndex: fromIndex, toIndex: toIndex, progress: progress)
    }
    
    func channelsContent(_ channelsContent: SRChannelsContent, didEndScrollAtIndex atIndex: Int) {
        channelsTitle.didEndScrollAtIndex(atIndex: atIndex)
        delegate?.channelsControl(self, didEndScrollAtIndex: atIndex)
    }
}

extension SRChannelsControl: SRChannelsTitleDeleate {
    
    func channelsTitle(_ channelsTitle: SRChannelsTitle, didSelectIndex index: Int) {
        channelsContent.didSelectIndex(index: index)
        delegate?.channelsControl(self, didSelectIndex: index)
    }
}
