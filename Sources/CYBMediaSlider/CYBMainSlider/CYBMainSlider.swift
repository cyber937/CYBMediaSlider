//
//  CYBMediaSlider_Main.swift
//  Custom_Slider
//
//  Created by Kiyoshi Nagahama on 12/23/19.
//  Copyright © 2019 Kiyoshi Nagahama. All rights reserved.
//

import Cocoa

class CYBMainSlider: NSControl, CYBRangeKnobsDelegate {
    
    var mainSliderLine: CYBMainSliderLine!
    var mainSliderknob: CYBMainSliderKnob!
    
    var minValue: CGFloat = 0
    var maxValue: CGFloat = 100 // default max value is 100
    
    var minPoint: CGFloat = 0
    var maxPoint: CGFloat = 0 // default max point is 100

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
    
    var _value: CGFloat = 0
    
    // This value is actual value.
    var value : CGFloat {
        get {
            return _value
        }
        
        set (newValue) {
            _value = newValue
            mainSliderknob.frame.origin.x = ((maxPoint - minPoint) * (_value / maxValue) + minPoint).rounded() - 4

        }
    }
    
    // Everytime when this view's size is updated, this method is triggered.
    override var frame: NSRect {
        didSet {
            // Calcurate maxPoint (subtract 'minPoint' and '8' from this view's frame)
            maxPoint = frame.size.width - minPoint - 8.0

            // Assign the maxPoint to the width of
            mainSliderLine.frame.size.width = maxPoint - 8.0
            
            // Update the location of mainSliderKnob
            mainSliderknob.frame.origin.x = ((maxPoint - minPoint) * (_value / maxValue) + minPoint).rounded() - 4
        }
    }
    
    // MARK: - Initialization
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        minPoint = 8.0
        
        mainSliderLine = CYBMainSliderLine(frame: NSMakeRect(minPoint, 3, 100, 5))
        mainSliderknob = CYBMainSliderKnob(frame: NSMakeRect(0.0, 0.0, 8.0, 13.5))
        
        addSubview(mainSliderLine)
        addSubview(mainSliderknob)
    }
    
    
    
    override func mouseDown(with event: NSEvent) {
        if isEditabled {
            updatingSliderKnobPotision(with: event)
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        if isEditabled {
            updatingSliderKnobPotision(with: event)
        }
    }
    
    func updatingSliderKnobPotision(with event: NSEvent) {
        
        // Find mouse pointer location inside this view.
        let dragLocation = self.convert(event.locationInWindow, from: nil)
        
        // Assign mousePosition variable
        let mousePosition = dragLocation.x.rounded()
        
        // Make mousePosition's limit in between "minPoint" and "maxPoint"
        guard mousePosition > minPoint,
              mousePosition < maxPoint else { return }
        
        // Assign _value
        _value = ((mousePosition - minPoint)  /  (maxPoint - minPoint) * maxValue).rounded()
        
        if _value == maxValue {
            _value = maxValue - 1
            return
        }

        mainSliderknob.frame.origin.x = ((maxPoint - minPoint) * (_value / maxValue) + minPoint).rounded() - 4

        let _ = sendAction(action, to: target)
    }
    
    func didUpdateMinKnobPosition(_ position: CGFloat) {
        mainSliderLine.minKnobPosition = position
        mainSliderLine.needsDisplay = true
    }

    func didUpdateMaxKnobPosition(_ position: CGFloat) {
        mainSliderLine.maxKnobPosition = position
        mainSliderLine.needsDisplay = true
    }
}
