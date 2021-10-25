//
//  CYBMediaSlider_Main.swift
//  Custom_Slider
//
//  Created by Kiyoshi Nagahama on 12/23/19.
//  Copyright © 2019 Kiyoshi Nagahama. All rights reserved.
//

import Cocoa

@IBDesignable
class CYBMainSlider: NSControl, CYBRangeKnobsDelegate {
    
    var mainSliderLine: CYBMainSliderLine
    var mainSliderknob: CYBMainSliderKnob
    
    var minValue: CGFloat = 0
    var maxValue: CGFloat = 50 // default max value is 100
    
    var minPoint: CGFloat = 0
    var maxPoint: CGFloat = 50 // default max point is 100

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
            mainSliderknob.frame.origin.x = ((maxPoint - minPoint) * (_value / maxValue) + minPoint).rounded()

        }
    }
    
    override var frame: NSRect {
        didSet {
            mainSliderLine.frame.size.width = frame.size.width - 16
            maxPoint = frame.size.width - 16
            let newSliderknobPosition = (maxPoint - minPoint) * (value / maxValue) + minPoint
            mainSliderknob.frame.origin.x = newSliderknobPosition
        }
    }
    
    required init?(coder: NSCoder) {
        
        mainSliderLine = CYBMainSliderLine(frame: NSMakeRect(8, 3, 100, 5))
        mainSliderknob = CYBMainSliderKnob(frame: NSMakeRect(0.0, 0.0, 8.0, 13.5))
        
        super.init(coder: coder)
        
        addSubview(mainSliderLine)
        addSubview(mainSliderknob)
        
        minPoint = 8.0
        mainSliderknob.frame.origin.x = minPoint
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
        var mousePosition = dragLocation.x - 4
        
        // Make mousePosition's limit in between "minPoint" and "maxPoint"
        if mousePosition < minPoint {
            mousePosition = minPoint
        } else if mousePosition > maxPoint {
            mousePosition = maxPoint
        }
        
        // Assign _value
        _value = ((mousePosition - minPoint)  /  (mainSliderLine.frame.width - minPoint) * maxValue).rounded()
        
        mainSliderknob.frame.origin.x = ((maxPoint - minPoint) * (_value / maxValue) + minPoint).rounded()
        
        //print("Value ... \(_value)\nMouse Position ... \(mousePosition)\nKnob Position ... \(mainSliderknob.frame.origin.x)\n\(mainSliderLine.frame.width)")
        
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

@IBDesignable
class CYBMainSliderKnob: NSView {
    
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
        
        var knobColor = NSColor(red: 1, green: 0.687, blue: 0, alpha: 1)
        
        if !isEditabled {
            knobColor = NSColor.gray
        }
        
        if !isEnabled {
            knobColor = NSColor(red: 1, green: 0.687, blue: 0, alpha: 0)
            return
        }
        
        knobColor.set()
        
        let mainSliderKnobPath = NSBezierPath()
        mainSliderKnobPath.move(to: NSPoint(x: 4, y: 13))
        mainSliderKnobPath.line(to: NSPoint(x: 8.0, y: 9.0))
        mainSliderKnobPath.line(to: NSPoint(x: 0, y: 9))
        mainSliderKnobPath.close()
        mainSliderKnobPath.fill()
        
        let rectangle3CornerRadius: CGFloat = 3
        let rectangle3Rect = NSRect(x: 0, y: 0, width: 8, height: 9)
        let rectangle3InnerRect = rectangle3Rect.insetBy(dx: rectangle3CornerRadius, dy: rectangle3CornerRadius)
        let rectangle3Path = NSBezierPath()
        rectangle3Path.appendArc(withCenter: NSPoint(x: rectangle3InnerRect.minX, y: rectangle3InnerRect.minY), radius: rectangle3CornerRadius, startAngle: 180, endAngle: 270)
        rectangle3Path.appendArc(withCenter: NSPoint(x: rectangle3InnerRect.maxX, y: rectangle3InnerRect.minY), radius: rectangle3CornerRadius, startAngle: 270, endAngle: 360)
        rectangle3Path.line(to: NSPoint(x: rectangle3Rect.maxX, y: rectangle3Rect.maxY))
        rectangle3Path.line(to: NSPoint(x: rectangle3Rect.minX, y: rectangle3Rect.maxY))
        rectangle3Path.close()
        rectangle3Path.fill()
    }
}

@IBDesignable
class CYBMainSliderLine: NSView {

    var minKnobPosition: CGFloat = 0
    var maxKnobPosition: CGFloat = 0

    var isEditabled: Bool = true{
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
        
        
        var lightGray = NSColor(red: 0.619, green: 0.619, blue: 0.619, alpha: 1)
        
        if !isEditabled {
            lightGray = NSColor.gray.withAlphaComponent(0.8)
        }
        
        guard isEnabled else {
            NSColor.darkGray.setFill()
            bounds.fill()
            return
        }
        
        lightGray.setFill()
        bounds.fill()
        
        NSColor.darkGray.setFill()
        
        guard isEnabled else { return }
   
        let minRect = NSMakeRect(0, 0, minKnobPosition, 15)
        minRect.fill()

        let maxRect = NSMakeRect(self.frame.size.width - maxKnobPosition, 0, self.frame.size.width, 5)
        maxRect.fill()
    }
}
