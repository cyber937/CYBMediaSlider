//
//  CYBMediaSlider_Main.swift
//  Custom_Slider
//
//  Created by Kiyoshi Nagahama on 12/23/19.
//  Copyright © 2019 Kiyoshi Nagahama. All rights reserved.
//

import Cocoa

class CYBMainSlider: NSControl {
    
    var mouseRightPlaceToClicked: Bool = false
    
    var mainSliderLine: CYBMainSliderLine!
    var mainSliderKnob: CYBMainSliderKnob!
    var rangeInKnob: CYBRangeSliderKnobInPoint!
    var rangeOutKnob: CYBRangeSliderKnobOutPoint!
    
    var minPoint: CGFloat = 0.0 {
        didSet {
            rangeInKnob.minPoint = minPoint
            rangeOutKnob.minPoint = minPoint
        }
    }
    
    var maxPoint: CGFloat = 0.0 {
        didSet {
            rangeInKnob.maxPoint = maxPoint
            rangeOutKnob.maxPoint = maxPoint
        }
    }

    var minValue: CGFloat = 0.0 {
        didSet {
            rangeInKnob.minValue = minValue
            rangeOutKnob.minValue = minValue
        }
    }
    
    var maxValue: CGFloat = 100.0 {
        didSet {
            rangeInKnob.maxValue = maxValue
            rangeOutKnob.maxValue = maxValue
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            mainSliderKnob.isHidden = !isEnabled
            mainSliderLine.isEnabled = isEnabled
        }
    }

    var isEditabled: Bool = true {
        didSet {
            mainSliderLine.isEditabled = isEditabled
        }
    }
    
    var roundedValue: Bool = false
    
    // This value is actual value.
    var value : CGFloat = 0.0 {
        didSet {
            if roundedValue {
                mainSliderKnob.frame.origin.x = ((maxPoint - minPoint) * (value / maxValue) + minPoint).rounded() - 4
            } else {
                mainSliderKnob.frame.origin.x = ((maxPoint - minPoint) * (value / maxValue) + minPoint) - 4
            }
        }
    }
    
    // Everytime when this view's size is updated, this method is triggered.
    override var frame: NSRect {
        didSet {
            // Calcurate maxPoint (subtract 'minPoint' and '8' from this view's frame)
            maxPoint = frame.size.width - minPoint

            // Assign the maxPoint to the width of
            mainSliderLine.frame.size.width = maxPoint - minPoint
            
            // Update the location of mainSliderKnob
            if roundedValue {
                mainSliderKnob.frame.origin.x = ((maxPoint - minPoint) * (value / maxValue) + minPoint).rounded() - 4
            } else {
                mainSliderKnob.frame.origin.x = ((maxPoint - minPoint) * (value / maxValue) + minPoint) - 4
            }
            
            rangeInKnob.updateKnobPosition()
            rangeOutKnob.updateKnobPosition()
        }
    }
    
    // MARK: - Initialization
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        minPoint = 8.0
        
        mainSliderLine = CYBMainSliderLine(frame: NSMakeRect(minPoint, 10, 100, 3.5))
        addSubview(mainSliderLine)
        
        rangeInKnob = CYBRangeSliderKnobInPoint(frame: NSMakeRect(0, 4, 8, 8))
        rangeInKnob.minPoint = minPoint
        
        rangeOutKnob = CYBRangeSliderKnobOutPoint(frame: NSMakeRect(0, 4, 8, 8))
        rangeOutKnob.minPoint = minPoint

        rangeInKnob.maxKnob = rangeOutKnob
        rangeOutKnob.minKnob = rangeInKnob
        
        addSubview(rangeInKnob)
        addSubview(rangeOutKnob)
        
        mainSliderKnob = CYBMainSliderKnob(frame: NSMakeRect(0.0, 5, 8.0, 13))
        
        addSubview(mainSliderKnob)
    }
    
    public override func mouseDown(with event: NSEvent) {
        if isEnabled && isEditabled {
            let clickedLocation = self.convert(event.locationInWindow, from: nil)
            let clickedMouseYPosition =  clickedLocation.y
            
            if clickedMouseYPosition >= 7 {
                mouseRightPlaceToClicked = true
            }
        }
    }
    
    public override func mouseUp(with event: NSEvent) {
        if isEnabled && isEditabled {
            mouseRightPlaceToClicked = false
        }
    }
    
    public override func mouseDragged(with event: NSEvent) {
        if isEnabled && isEditabled {
            if mouseRightPlaceToClicked {
                if isEnabled {
                    updatingSliderKnobPotision(with: event)
                }
            }
        }
    }
    
    func updatingSliderKnobPotision(with event: NSEvent) {
        
        // Find mouse pointer location inside this view.
        let dragLocation = self.convert(event.locationInWindow, from: nil)
        
        // Assign mousePosition variable
        let mouseXPosition = dragLocation.x
        
        var newValue: CGFloat
        
        if roundedValue {
            newValue = ((mouseXPosition - minPoint)  /  (maxPoint - minPoint) * maxValue).rounded()
        } else {
            newValue = ((mouseXPosition - minPoint)  /  (maxPoint - minPoint) * maxValue)
        }
        
        if newValue <= minValue {
            newValue = 0
        }
        
        if newValue >= maxValue - 1 {
            newValue = maxValue - 1
        }
        
        value = newValue
        
        if roundedValue {
            mainSliderKnob.frame.origin.x = ((maxPoint - minPoint) * (value / maxValue) + minPoint).rounded() - 4
        } else {
            mainSliderKnob.frame.origin.x = ((maxPoint - minPoint) * (value / maxValue) + minPoint) - 4
        }

        let _ = sendAction(action, to: target)
    }
    
//    override func accessibilityRole() -> NSAccessibility.Role? {
//        return NSAccessibility.Role.layoutArea
//    }
//    
//    override func isAccessibilityElement() -> Bool {
//        true
//    }
//    
//    override func accessibilityLabel() -> String? {
//        return NSLocalizedString("CYBMainSlider", comment: "accessibility label of the CYBMainSldier")
//    }
//    
//    override func accessibilityChildren() -> [Any]? {
//        return [mainSliderKnob!]
//    }
}
