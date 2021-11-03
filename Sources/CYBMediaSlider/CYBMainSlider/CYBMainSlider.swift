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
    var mainSliderknob: CYBMainSliderKnob!
    var rangeInKnob: CYBRangeSliderKnobInPoint!
    var rangeOutKnob: CYBRangeSliderKnobOutPoint!
    
    var minPoint: CGFloat = 0 {
        didSet {
            rangeInKnob.minPoint = minPoint
            rangeOutKnob.minPoint = minPoint
        }
    }
    
    var maxPoint: CGFloat = 0 {
        didSet {
            rangeInKnob.maxPoint = maxPoint
            rangeOutKnob.maxPoint = maxPoint
        }
    }

    var minValue: CGFloat = 0 {
        didSet {
            rangeInKnob.minValue = minValue
            rangeOutKnob.minValue = minValue
        }
    }
    
    var maxValue: CGFloat = 100 {
        didSet {
            rangeInKnob.maxValue = maxValue
            rangeOutKnob.maxValue = maxValue
        }
    }
    
    var isEditabled: Bool = true {
        didSet {
            mainSliderknob.isEditabled = isEditabled
            mainSliderLine.isEditabled = isEditabled
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            mainSliderknob.isEnabled = isEnabled
            mainSliderLine.isEnabled = isEnabled
        }
    }

    // This value is actual value.
    var value : CGFloat = 0 {
        didSet {
            mainSliderknob.frame.origin.x = ((maxPoint - minPoint) * (value / maxValue) + minPoint).rounded() - 4
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
            mainSliderknob.frame.origin.x = ((maxPoint - minPoint) * (value / maxValue) + minPoint).rounded() - 4
            
            rangeInKnob.updateKnobPosition()
            rangeOutKnob.updateKnobPosition()
        }
    }
    
    // MARK: - Initialization
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        minPoint = 8.0
        
        mainSliderLine = CYBMainSliderLine(frame: NSMakeRect(minPoint, 9.5, 100, 5))
        addSubview(mainSliderLine)
        
        
        rangeInKnob = CYBRangeSliderKnobInPoint(frame: NSMakeRect(0, 1, 8, 8))
        rangeInKnob.minPoint = minPoint
        
        rangeOutKnob = CYBRangeSliderKnobOutPoint(frame: NSMakeRect(0, 1, 8, 8))
        rangeOutKnob.minPoint = minPoint

        rangeInKnob.maxKnob = rangeOutKnob
        rangeOutKnob.minKnob = rangeInKnob
        
        addSubview(rangeInKnob)
        addSubview(rangeOutKnob)
        
        mainSliderknob = CYBMainSliderKnob(frame: NSMakeRect(0.0, 7, 8.0, 13))
        
        addSubview(mainSliderknob)
    }
    
    override func mouseDown(with event: NSEvent) {
        if isEditabled {
            let clickedLocation = self.convert(event.locationInWindow, from: nil)
            let clickedMouseYPosition =  clickedLocation.y
            
            if clickedMouseYPosition >= 7 {
                mouseRightPlaceToClicked = true
            }
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        if isEditabled {
            mouseRightPlaceToClicked = false
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        if isEditabled {
            if mouseRightPlaceToClicked {
                if isEditabled {
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
        
        
        var newValue = ((mouseXPosition - minPoint)  /  (maxPoint - minPoint) * maxValue).rounded()
        
        if newValue <= minValue {
            newValue = 0
        }
        
        if newValue >= maxValue - 1 {
            newValue = maxValue - 1
        }
        
        value = newValue
        
        mainSliderknob.frame.origin.x = ((maxPoint - minPoint) * (value / maxValue) + minPoint).rounded() - 4

        let _ = sendAction(action, to: target)
    }
}
