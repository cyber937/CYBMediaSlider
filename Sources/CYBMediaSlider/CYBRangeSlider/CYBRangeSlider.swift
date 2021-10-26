//
//  CYBMediaSlider_Renge.swift
//  Custom_Slider
//
//  Created by Kiyoshi Nagahama on 12/23/19.
//  Copyright © 2019 Kiyoshi Nagahama. All rights reserved.
//

import Cocoa

@IBDesignable
class CYBRangeSlider: NSView {
    
    var rangeSliderKnobInPoint: CYBRangeSliderKnobInPoint!
    var rangeSliderKnobOutPoint: CYBRangeSliderKnobOutPoint!
    var rangeSliderLine: CYBRangeSliderLine!
    
    var minPoint: CGFloat = 0 {
        didSet {
            rangeSliderKnobInPoint.minPoint = minPoint
            rangeSliderKnobOutPoint.minPoint = minPoint
        }
    }

    var maxPoint: CGFloat = 0 {
        didSet {
            rangeSliderKnobInPoint.maxPoint = maxPoint
            rangeSliderKnobOutPoint.maxPoint = maxPoint
        }
    }
        
    var minValue: CGFloat = 0 {
        didSet {
            rangeSliderKnobInPoint.minValue = minValue
            rangeSliderKnobOutPoint.minValue = minValue
        }
    }
    
    var maxValue: CGFloat = 10 {
        didSet {
            rangeSliderKnobInPoint.maxValue = maxValue
            rangeSliderKnobOutPoint.maxValue = maxValue
        }
    }
    
    var inPointValue: CGFloat = 0 {
        didSet {
            rangeSliderLine.frame.origin.x = rangeSliderKnobInPoint.frame.origin.x + rangeSliderKnobInPoint.frame.width
            rangeSliderLine.frame.size.width = rangeSliderKnobOutPoint.frame.origin.x - rangeSliderLine.frame.origin.x
            rangeKnobsDelegate?.didUpdateMinKnobPosition(rangeSliderKnobInPoint.frame.origin.x)
        }
    }

    var outPointValue: CGFloat = 0 {
        didSet {
            rangeSliderLine.frame.origin.x = rangeSliderKnobInPoint.frame.origin.x + rangeSliderKnobInPoint.frame.width
            rangeSliderLine.frame.size.width = rangeSliderKnobOutPoint.frame.origin.x - rangeSliderLine.frame.origin.x
            rangeKnobsDelegate?.didUpdateMaxKnobPosition(frame.size.width - rangeSliderKnobOutPoint.frame.origin.x - rangeSliderKnobOutPoint.frame.size.width)
        }
    }
    
    var isEditabled: Bool = true {
        didSet {
            rangeSliderKnobInPoint.isEditabled = isEditabled
            rangeSliderKnobOutPoint.isEditabled = isEditabled
            rangeSliderLine.isEditabled = isEditabled
        }
    }
    
    var isEnabled: Bool = true {
        didSet {
            rangeSliderKnobInPoint.isEnabled = isEnabled
            rangeSliderKnobOutPoint.isEnabled = isEnabled
            
            rangeSliderLine.isEnabled = isEnabled
            
            if !isEnabled {
                rangeSliderLine.frame.origin.x = rangeSliderKnobInPoint.frame.width
                rangeSliderLine.frame.size.width = frame.size.width - rangeSliderKnobOutPoint.frame.width - rangeSliderKnobInPoint.frame.width
            } else {
                rangeSliderLine.frame.origin.x = rangeSliderKnobInPoint.frame.origin.x + rangeSliderKnobInPoint.frame.width
                rangeSliderLine.frame.size.width = rangeSliderKnobOutPoint.frame.origin.x - rangeSliderLine.frame.origin.x
            }
            
        }
    }
    
    weak var rangeKnobsDelegate: CYBRangeKnobsDelegate?
    
    // Everytime when this view's size is updated, this method is triggered.
    override var frame: NSRect {
        didSet {
            
            maxPoint = frame.size.width - minPoint - 8.0
            
            rangeSliderLine.frame.size.width = maxPoint - 8.0

            rangeSliderKnobInPoint.uploadKnobPosition()
            rangeSliderKnobOutPoint.uploadKnobPosition()

            // Line update
            rangeSliderLine.frame.origin.x = rangeSliderKnobInPoint.frame.origin.x + rangeSliderKnobInPoint.frame.width
            rangeSliderLine.frame.size.width = rangeSliderKnobOutPoint.frame.origin.x - rangeSliderLine.frame.origin.x
            
            rangeKnobsDelegate?.didUpdateMinKnobPosition(rangeSliderKnobInPoint.frame.origin.x)
            rangeKnobsDelegate?.didUpdateMaxKnobPosition(frame.size.width - rangeSliderKnobOutPoint.frame.origin.x - rangeSliderKnobOutPoint.frame.size.width)

        }
    }
    
    // MARK: - Initialization
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        minPoint = 8
        
        rangeSliderLine = CYBRangeSliderLine(frame: NSMakeRect(minPoint, 3, 100, 4))
        
        rangeSliderKnobInPoint = CYBRangeSliderKnobInPoint(frame: NSMakeRect(0, 1, 8, 8))
        rangeSliderKnobInPoint.minPoint = minPoint
        
        rangeSliderKnobOutPoint = CYBRangeSliderKnobOutPoint(frame: NSMakeRect(0, 1, 8, 8))
        rangeSliderKnobOutPoint.minPoint = minPoint
        
        rangeSliderKnobInPoint.maxKnob = rangeSliderKnobOutPoint
        rangeSliderKnobOutPoint.minKnob = rangeSliderKnobInPoint
        
        addSubview(rangeSliderLine)
        addSubview(rangeSliderKnobInPoint)
        addSubview(rangeSliderKnobOutPoint)
    }
}

@objc protocol CYBRangeKnobsDelegate: AnyObject {
    func didUpdateMinKnobPosition(_ position: CGFloat)
    func didUpdateMaxKnobPosition(_ position: CGFloat)
}
