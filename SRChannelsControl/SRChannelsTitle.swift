//
//  SRChannelsControl.h
//
//  Created by https://github.com/guowilling on 2017/8/16.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit

protocol SRChannelsTitleDeleate: class {
    func channelsTitle(_ channelsTitle: SRChannelsTitle, didSelectIndex index: Int)
}

class SRChannelsTitle: UIView {
    
    weak var delegate: SRChannelsTitleDeleate?
    
    public var titles: [String]
    public var titleStyle: SRChannelsTitleStyle
    public var titleLabels: [UILabel] = []
    public var currentIndex: Int = 0
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView(frame: self.bounds)
        sv.showsHorizontalScrollIndicator = false
        sv.scrollsToTop = false
        return sv
    }()
    
    public lazy var bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = self.titleStyle.bottomLineColor
        line.frame.origin.y = self.bounds.height - titleStyle.bottomLineHeight - 2
        line.frame.size.height = self.titleStyle.bottomLineHeight
        return line
    }()
    
    public lazy var slider: UIView = {
        let slider = UIView()
        slider.backgroundColor = self.titleStyle.sliderColor
        slider.alpha = self.titleStyle.sliderAlpha
        return slider
    }()
    
    init(frame: CGRect, titles: [String], titleStyle: SRChannelsTitleStyle) {
        self.titles = titles
        self.titleStyle = titleStyle
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SRChannelsTitle {
    
    private func setupUI() {
        backgroundColor = UIColor.white
        addSubview(scrollView)
        setupTitleLabels()
        setupBottomLine()
        setupSlider()
    }
    
    private func setupTitleLabels() {
        for (i, title) in titles.enumerated() {
            let lb = UILabel()
            lb.text = title
            lb.tag = i
            lb.font = titleStyle.titleFont
            lb.textColor = i == 0 ? titleStyle.titleSelectdColor : titleStyle.titleNormalColor
            lb.textAlignment = .center
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(didTapTitleLabel(_:)))
            lb.isUserInteractionEnabled = true
            lb.addGestureRecognizer(tapGes)
            scrollView.addSubview(lb)
            titleLabels.append(lb)
        }
        
        let count = titles.count
        for (i, label) in titleLabels.enumerated() {
            var lbX: CGFloat = 0
            let lbY: CGFloat = 0
            var lbW: CGFloat = 0
            let lbH: CGFloat = bounds.height
            if !titleStyle.isScrollEnabled {
                lbW = bounds.width / CGFloat(count)
                lbX = lbW * CGFloat(i)
            } else {
                lbW = (titles[i] as NSString).boundingRect(
                    with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0),
                    options: .usesLineFragmentOrigin,
                    attributes: [NSAttributedString.Key.font: titleStyle.titleFont],
                    context: nil
                    ).width
                if i == 0 {
                    lbX = titleStyle.titleMargin * 1.25
                } else {
                    let preLabel = titleLabels[i - 1]
                    lbX = preLabel.frame.maxX + titleStyle.titleMargin
                }
            }
            label.frame = CGRect(x: lbX, y: lbY, width: lbW, height: lbH)
            
            if titleStyle.isTitleScaling && i == 0 {
                label.transform = CGAffineTransform(scaleX: titleStyle.scaleRange, y: titleStyle.scaleRange)
            }
        }
        
        if titleStyle.isScrollEnabled {
            scrollView.contentSize.width = titleLabels.last!.frame.maxX + titleStyle.titleMargin * 1.25
        }
    }
    
    private func setupBottomLine() {
        guard titleStyle.isBottomLineDisplayed else {
            return
        }
        if titleStyle.isFixedBottomLineWidth {
            bottomLine.frame.origin.x = titleLabels.first!.center.x - 15.auto() * 0.5
            bottomLine.frame.size.width = 15.auto()
            bottomLine.layer.cornerRadius = 1.5
            bottomLine.layer.masksToBounds = true
        } else {
            bottomLine.frame.origin.x = titleLabels.first!.frame.origin.x
            bottomLine.frame.size.width = titleLabels.first!.bounds.width
        }
        scrollView.addSubview(bottomLine)
    }
    
    private func setupSlider() {
        guard titleStyle.isSliderDisplayed else {
            return
        }
        var sliderW: CGFloat = 0.0
        if titleStyle.isScrollEnabled {
            sliderW = titleLabels.first!.frame.width + titleStyle.titleMargin
        } else {
            sliderW = titleLabels.first!.frame.width - 2 * titleStyle.sliderInset
        }
        let sliderH: CGFloat = titleStyle.sliderHeight
        slider.bounds = CGRect(x: 0, y: 0, width: sliderW, height: sliderH)
        slider.center = titleLabels.first!.center
        slider.layer.cornerRadius = titleStyle.sliderHeight * 0.5
        slider.layer.masksToBounds = true
        scrollView.addSubview(slider)
    }
}

extension SRChannelsTitle {
    // MARK: - Private Methods
    @objc private func didTapTitleLabel(_ tapGes : UITapGestureRecognizer) {
        guard let currentLabel = tapGes.view as? UILabel else {
            return
        }
        if currentIndex == currentLabel.tag {
            return
        }
        let lastLabel = titleLabels[currentIndex]
        lastLabel.textColor = titleStyle.titleNormalColor
        currentLabel.textColor = titleStyle.titleSelectdColor
        currentIndex = currentLabel.tag
        
        if titleStyle.isBottomLineDisplayed {
            if titleStyle.isFixedBottomLineWidth {
                bottomLine.frame.origin.x = currentLabel.center.x - 15.auto() * 0.5
                bottomLine.frame.size.width = 15.auto()
            } else {
                bottomLine.frame.origin.x = currentLabel.frame.origin.x
                bottomLine.frame.size.width = currentLabel.frame.width
            }
        }
        
        if titleStyle.isTitleScaling {
            currentLabel.transform = lastLabel.transform
            lastLabel.transform = CGAffineTransform.identity
        }
        
        if titleStyle.isSliderDisplayed {
            var sliderW: CGFloat = 0.0
            if titleStyle.isScrollEnabled {
                sliderW = currentLabel.frame.width + titleStyle.titleMargin
            } else {
                sliderW = currentLabel.frame.width - 2 * titleStyle.sliderInset
            }
            slider.frame.size.width = sliderW
            slider.center = currentLabel.center
        }
        
        delegate?.channelsTitle(self, didSelectIndex: currentIndex)
        
        adjustPosition(currentLabel)
    }
    
    private func adjustPosition(_ newLabel: UILabel) {
        guard titleStyle.isScrollEnabled else { return }
        let maxOffset = scrollView.contentSize.width - bounds.width
        guard maxOffset > 0 else { return }
        var offsetX = newLabel.center.x - scrollView.bounds.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        if offsetX > maxOffset {
            offsetX = maxOffset
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}

extension SRChannelsTitle {
    // MARK: - Public Methods
    public func scroll(fromIndex: Int, toIndex: Int, progress: CGFloat) {
        let lastLabel = titleLabels[fromIndex]
        let toLabel = titleLabels[toIndex]
        let normalRGB = UIColor.getGRBValue(titleStyle.titleNormalColor)
        let selectedRGB = UIColor.getGRBValue(titleStyle.titleSelectdColor)
        let deltaRGB = (selectedRGB.0 - normalRGB.0,
                        selectedRGB.1 - normalRGB.1,
                        selectedRGB.2 - normalRGB.2)
        lastLabel.textColor = UIColor(sr_colorWithR: selectedRGB.0 - deltaRGB.0 * progress,
                                      G: selectedRGB.1 - deltaRGB.1 * progress,
                                      B: selectedRGB.2 - deltaRGB.2 * progress)
        toLabel.textColor = UIColor(sr_colorWithR: normalRGB.0 + deltaRGB.0 * progress,
                                    G: normalRGB.1 + deltaRGB.1 * progress,
                                    B: normalRGB.2 + deltaRGB.2 * progress)
        
        if titleStyle.isBottomLineDisplayed {
            if titleStyle.isFixedBottomLineWidth {
                let toLabelX = toLabel.center.x - 15.auto() * 0.5
                let lastLabelX = lastLabel.center.x - 15.auto() * 0.5
                let deltaX = toLabelX - lastLabelX
                bottomLine.frame.origin.x = lastLabelX + deltaX * progress
            } else {
                let deltaX = toLabel.frame.origin.x - lastLabel.frame.origin.x
                let deltaW = toLabel.frame.width - lastLabel.frame.width
                bottomLine.frame.origin.x = lastLabel.frame.origin.x + deltaX * progress
                bottomLine.frame.size.width = lastLabel.frame.width + deltaW * progress
            }
        }
        
        if titleStyle.isTitleScaling {
            let deltaScale = titleStyle.scaleRange - 1.0
            lastLabel.transform = CGAffineTransform(scaleX: titleStyle.scaleRange - deltaScale * progress,
                                                    y: titleStyle.scaleRange - deltaScale * progress)
            toLabel.transform = CGAffineTransform(scaleX: 1.0 + deltaScale * progress, y: 1.0 + deltaScale * progress)
        }
        
        if titleStyle.isSliderDisplayed {
            var lastW: CGFloat = 0;
            var toW: CGFloat = 0;
            if titleStyle.isScrollEnabled {
                lastW = lastLabel.frame.width + titleStyle.titleMargin
                toW = toLabel.frame.width + titleStyle.titleMargin
            } else {
                lastW = lastLabel.frame.width - 2 * titleStyle.sliderInset
                toW = toLabel.frame.width - 2 * titleStyle.sliderInset
            }
            let deltaW = toW - lastW
            let deltaX = toLabel.center.x - lastLabel.center.x
            slider.frame.size.width = lastW + deltaW * progress
            slider.center.x = lastLabel.center.x + deltaX * progress
        }
    }
    
    public func didEndScrollAtIndex(atIndex: Int) {
        guard atIndex != currentIndex else { return }
        let lastLabel = titleLabels[currentIndex]
        let atLabel = titleLabels[atIndex]
        lastLabel.textColor = titleStyle.titleNormalColor
        lastLabel.transform = .identity
        atLabel.textColor = titleStyle.titleSelectdColor
        currentIndex = atIndex
        adjustPosition(atLabel)
    }
}
