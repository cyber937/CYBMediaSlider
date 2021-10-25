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
    
    var rangeMinKnob: CYBRangeMinKnob
    var rangeMaxKnob: CYBRangeMaxKnob
    var rangeLine: CYBRangeLine
    
    var minValue: CGFloat = 0 {
        didSet {
            rangeMinKnob.minValue = minValue
            rangeMaxKnob.minValue = minValue
        }
    }
    
    var maxValue: CGFloat = 50 {
        didSet {
            rangeMinKnob.maxValue = maxValue
            rangeMaxKnob.maxValue = maxValue
        }
    }
    
    var inPointValue: CGFloat = 0 {
        didSet {
            rangeLine.frame.origin.x = rangeMinKnob.frame.origin.x + rangeMinKnob.frame.width
            rangeLine.frame.size.width = rangeMaxKnob.frame.origin.x - rangeLine.frame.origin.x
            rangeKnobsDelegate?.didUpdateMinKnobPosition(rangeMinKnob.frame.origin.x)
        }
    }

    var outPointValue: CGFloat = 0 {
        didSet {
            rangeLine.frame.origin.x = rangeMinKnob.frame.origin.x + rangeMinKnob.frame.width
            rangeLine.frame.size.width = rangeMaxKnob.frame.origin.x - rangeLine.frame.origin.x
            rangeKnobsDelegate?.didUpdateMaxKnobPosition(frame.size.width - rangeMaxKnob.frame.origin.x - rangeMaxKnob.frame.size.width)
        }
    }
    
    var isEditabled: Bool = true {
        didSet {
            rangeMinKnob.isEditabled = isEditabled
            rangeMaxKnob.isEditabled = isEditabled
            rangeLine.isEditabled = isEditabled
        }
    }
    
    var isEnabled: Bool = true {
        didSet {
            rangeMinKnob.isEnabled = isEnabled
            rangeMaxKnob.isEnabled = isEnabled
            
            rangeLine.isEnabled = isEnabled
            
            if !isEnabled {
                rangeLine.frame.origin.x = rangeMinKnob.frame.width
                rangeLine.frame.size.width = frame.size.width - rangeMaxKnob.frame.width - rangeMinKnob.frame.width
            } else {
                rangeLine.frame.origin.x = rangeMinKnob.frame.origin.x + rangeMinKnob.frame.width
                rangeLine.frame.size.width = rangeMaxKnob.frame.origin.x - rangeLine.frame.origin.x
            }
            
        }
    }
    
    weak var rangeKnobsDelegate: CYBRangeKnobsDelegate?
    
    required init?(coder: NSCoder) {
        
        rangeMinKnob = CYBRangeMinKnob(frame: NSMakeRect(0, 1, 8, 8))
        rangeMaxKnob = CYBRangeMaxKnob(frame: NSMakeRect(0, 1, 8, 8))
        rangeLine = CYBRangeLine(frame: NSMakeRect(rangeMinKnob.frame.size.width, 3, 100, 4))
        
        super.init(coder: coder)
        
        addSubview(rangeLine)
        addSubview(rangeMinKnob)
        addSubview(rangeMaxKnob)
        
        rangeMaxKnob.minKnob = rangeMinKnob
        rangeMinKnob.maxKnob = rangeMaxKnob
    }
    
    override var frame: NSRect {
        didSet {
            // Knob update
            rangeMinKnob.maxPoint = frame.size.width - (rangeMinKnob.frame.size.width * 2)
            rangeMaxKnob.maxPoint = frame.size.width - rangeMaxKnob.frame.size.width
            rangeMaxKnob.minPoint = rangeMinKnob.frame.size.width
            
            let newMinKnobPosition = rangeMinKnob.maxPoint * (rangeMinKnob.value / rangeMinKnob.maxValue)
            rangeMinKnob.frame.origin.x = newMinKnobPosition
            
            let newMaxKnobPosition = (rangeMaxKnob.maxPoint - rangeMaxKnob.minPoint) * (rangeMaxKnob.value / rangeMaxKnob.maxValue) + rangeMaxKnob.minPoint
            rangeMaxKnob.frame.origin.x = newMaxKnobPosition
            
            // Line update
            rangeLine.frame.origin.x = rangeMinKnob.frame.origin.x + rangeMinKnob.frame.width
            rangeLine.frame.size.width = rangeMaxKnob.frame.origin.x - rangeLine.frame.origin.x
            
            rangeKnobsDelegate?.didUpdateMinKnobPosition(rangeMinKnob.frame.origin.x)
            rangeKnobsDelegate?.didUpdateMaxKnobPosition(frame.size.width - rangeMaxKnob.frame.origin.x - rangeMaxKnob.frame.size.width)

        }
    }
}

@objc protocol CYBRangeKnobsDelegate: AnyObject {
    func didUpdateMinKnobPosition(_ position: CGFloat)
    func didUpdateMaxKnobPosition(_ position: CGFloat)
}

/// This is a class to draw a range line
///
class CYBRangeLine: NSView {
    
    var isEditabled: Bool = true {
        didSet {
            needsDisplay = true
        }
    }
    
    var isEnabled: Bool = true {
        didSet {
            needsDisplay = true
            
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        var rangeLineColor = NSColor.gray
        
        if !isEditabled || !isEnabled {
            rangeLineColor = NSColor.darkGray
        }
        
        rangeLineColor.setFill()
        dirtyRect.fill()
    }
}


class CYBRangeMinKnob: NSControl {
    
    var maxKnob: CYBRangeMaxKnob?
    
    var minPoint: CGFloat = 0
    var maxPoint: CGFloat = 0
    
    var minValue: CGFloat = 0
    var maxValue: CGFloat = 50
    
    var _value: CGFloat = 0
    
    var value : CGFloat {
        get {
            return _value
        }
        
        set (newValue) {
            _value = newValue
            let newMinKnobPosition = (newValue / maxValue)
            frame.origin.x = (superview!.frame.size.width  - frame.size.width) * newMinKnobPosition
            guard let rangeSlider = superview as? CYBRangeSlider else { return }
            rangeSlider.inPointValue = newValue
        }
    }
    
    var isEditabled: Bool = true {
        didSet {
            needsDisplay = true
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            isHidden = !isEnabled
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        var knobColor = NSColor(red: 1, green: 0.687, blue: 0, alpha: 1)
        
        if !isEditabled {
            knobColor = NSColor.darkGray
        }
        
        let bezierPath = NSBezierPath()
        bezierPath.move(to: NSPoint(x: 0, y: 7))
        bezierPath.line(to: NSPoint(x: 8, y: 7))
        bezierPath.line(to: NSPoint(x: 8, y: 0))
        bezierPath.line(to: NSPoint(x: 0, y: 7))
        bezierPath.close()
        knobColor.setFill()
        bezierPath.fill()
        knobColor.setStroke()
        bezierPath.lineWidth = 1.5
        bezierPath.lineJoinStyle = .round
        bezierPath.stroke()
    }
    
    override func mouseDragged(with event: NSEvent) {
        
        // If isEnabled is not true, return the function.
        guard isEditabled else { return }
        
        // Find mouse drag location and assign the value to 'newDragLocation'
        let newPosition = superview!.convert(event.locationInWindow, from: nil).x
        
        // Check the new position is not less than the minPoint and does not exceed maxPoint
        guard newPosition > minPoint,
              newPosition < maxPoint else { return }
        
        // Assign calculated number to _value
        _value = ((newPosition - minPoint) / (superview!.frame.width - minPoint) * maxValue).rounded()
        
        // Check the _value does not exceed maxKnob value
        guard let maxKnobValue = maxKnob?.value,
              maxKnobValue > _value else { return }
        
        // Assign calculated number to the view's center position
        frame.origin.x = ((maxPoint - minPoint - 8) * (_value / maxValue) + minPoint).rounded()
        
        guard let rangeSlider = superview as? CYBRangeSlider else { return }
        rangeSlider.inPointValue = _value
        
        let _ = sendAction(action, to: target)
    }
}

// MaxKnob

class CYBRangeMaxKnob: NSControl {
    
    var minKnob: CYBRangeMinKnob?
    
    var minPoint: CGFloat = 0
    var maxPoint: CGFloat = 0
    
    var minValue: CGFloat = 0
    var maxValue: CGFloat = 50
    
    var _value: CGFloat = 45
    
    var value : CGFloat {
        get {
            return _value
        }
        
        set (newValue){
            _value = newValue
            let newMaxKnobPosition = (newValue / maxValue)
            frame.origin.x = (superview!.frame.size.width  - frame.size.width) * newMaxKnobPosition
            guard let rangeSlider = superview as? CYBRangeSlider else { return }
            rangeSlider.outPointValue = _value
        }
    }
    
    var isEditabled: Bool = true {
        didSet {
            needsDisplay = true
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            isHidden = !isEnabled
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        var knobColor = NSColor(red: 1, green: 0.687, blue: 0, alpha: 1)
        
        if !isEditabled {
            knobColor = NSColor.darkGray
        }
        
        let bezier2Path = NSBezierPath()
        bezier2Path.move(to: NSPoint(x: 8, y: 7))
        bezier2Path.line(to: NSPoint(x: 0, y: 7))
        bezier2Path.line(to: NSPoint(x: 0, y: 0))
        bezier2Path.line(to: NSPoint(x: 8, y: 7))
        bezier2Path.close()
        knobColor.setFill()
        bezier2Path.fill()
        knobColor.setStroke()
        bezier2Path.lineWidth = 1.5
        bezier2Path.lineJoinStyle = .round
        bezier2Path.stroke()
    }
    
    override func mouseDragged(with event: NSEvent) {
        
        // If isEnabled is not true, return the function.
        guard isEditabled else { return }
        
        let newPosition = superview!.convert(event.locationInWindow, from: nil).x
        
        // Check the new position is not less than the minPoint and does not exceed maxPoint
        guard newPosition > minPoint,
              newPosition < maxPoint else { return }
        
        // Assign calculated number to _value
        _value = ((newPosition - minPoint) / (superview!.frame.width - minPoint) * maxValue).rounded()
        
        // Check the _value does not exceed maxKnob value
        guard let minKnobValue = minKnob?.value,
              minKnobValue < _value else { return }
        
        // Assign calculated number to the view's center position
        frame.origin.x = ((maxPoint - minPoint - 8) * (_value / maxValue) + minPoint).rounded() + 8
        
        guard let rangeSlider = superview as? CYBRangeSlider else { return }
        rangeSlider.outPointValue = _value
        
        let _ = sendAction(action, to: target)
    }
    
    override func mouseUp(with event: NSEvent) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "com.cyberseeds.MediaQ.sliderMaxMouseReleased"),
                                        object:     nil,
                                        userInfo:   nil)
    }
}
