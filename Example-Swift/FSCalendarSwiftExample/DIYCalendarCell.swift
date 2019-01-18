//
//  DIYCalendarCell.swift
//  FSCalendarSwiftExample
//
//  Created by dingwenchao on 06/11/2016.
//  Copyright © 2016 wenchao. All rights reserved.
//

import Foundation

import UIKit

enum SelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
    case todayWithRightBorder
    case singleMiddleBorder
}

let dateRangeHighLightColor = UIColor(red: 205/255.0, green: 226/255.0, blue: 249/255.0, alpha: 1.0)
let startEndDateHighLightColor = UIColor(red: 45/255.0, green: 116/255.0, blue: 222/255.0, alpha: 1.0)

class DIYCalendarCell: FSCalendarCell {
    
    weak var circleImageView: UIImageView!
    weak var selectionLayer: CAShapeLayer!
    weak var leftArrowLayer: CALayer!
    weak var rightArrowLayer: CALayer!
    
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    //allows multiple selection
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let circleImageView = UIImageView()
        circleImageView.layer.masksToBounds=true
        circleImageView.layer.borderWidth=1.5
        circleImageView.layer.borderColor = UIColor.lightGray.cgColor
        circleImageView.layer.cornerRadius = 4
        
        self.contentView.insertSubview(circleImageView, at: 0)
        self.circleImageView = circleImageView
        
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = dateRangeHighLightColor.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer
        
        self.shapeLayer.isHidden = true
        
        let leftArrow = CALayer()
        leftArrow.contents = UIImage(named: "left_arrow_calendar.png")?.cgImage
        leftArrow.bounds = CGRect(x: 0, y: 0, width: 5, height: 10)
        leftArrow.contentsGravity = kCAGravityLeft
        self.leftArrowLayer = leftArrow
        self.selectionLayer.insertSublayer(self.leftArrowLayer, above: self.titleLabel!.layer)
        
        let rightArrow = CALayer()
        rightArrow.contents = UIImage(named: "right_arrow_calendar.png")?.cgImage
        rightArrow.bounds = CGRect(x: 0, y: 0, width: 5, height: 10)
        rightArrow.contentsGravity = kCAGravityRight
        rightArrowLayer = rightArrow
        self.selectionLayer.insertSublayer(self.rightArrowLayer, above: self.titleLabel!.layer)
        
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.white //UIColor.lightGray.withAlphaComponent(0.12)
        self.backgroundView = view;
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.circleImageView.frame = CGRect(x: 0, y:0, width: self.frame.width, height: self.frame.height)
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        self.selectionLayer.frame = self.contentView.bounds
        leftArrowLayer.frame = CGRect(x: 0, y: 14, width: 5, height: 10)
        rightArrowLayer.frame = CGRect(x: self.selectionLayer.frame.size.width-5, y: 14, width: 5, height: 10)
        
        if selectionType == .middle {
            self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
            selectionLayer.fillColor = dateRangeHighLightColor.cgColor
            leftArrowLayer.isHidden = true
            rightArrowLayer.isHidden = true
        }
        else if selectionType == .leftBorder {
            leftArrowLayer.isHidden = false
            rightArrowLayer.isHidden = true
            self.fillColorSelectedDate()
        }
        else if selectionType == .rightBorder {
            leftArrowLayer.isHidden = true
            rightArrowLayer.isHidden = false
            self.fillColorSelectedDate()
            
        }else if selectionType == .todayWithRightBorder{
            leftArrowLayer.isHidden = true
            rightArrowLayer.isHidden = false
            self.fillColorSelectedDate()
        }else if selectionType == .singleMiddleBorder{
            leftArrowLayer.isHidden = false
            rightArrowLayer.isHidden = false
            self.fillColorSelectedDate()
        }
        else if selectionType == .single {
            leftArrowLayer.isHidden = true
            rightArrowLayer.isHidden = true
            self.fillColorSelectedDate()
        }
    }
    
    func fillColorSelectedDate(){
        selectionLayer.masksToBounds = true
        selectionLayer.borderWidth = 1
        selectionLayer.borderColor = UIColor.clear.cgColor
        selectionLayer.cornerRadius = 2
        selectionLayer.backgroundColor = startEndDateHighLightColor.cgColor
        selectionLayer.fillColor = startEndDateHighLightColor.cgColor
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.lightGray
        }
    }
    
}
