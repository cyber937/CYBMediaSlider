//
//  File.swift
//  
//
//  Created by Kiyoshi Nagahama on 10/25/21.
//

import Cocoa

class CYBRangeSliderKnobInPoint: NSControl {
    
    var maxKnob: CYBRangeSliderKnobOutPoint?
    
    var minPoint: CGFloat = 0.0
    var maxPoint: CGFloat = 0.0
    
    var minValue: CGFloat = 0.0
    var maxValue: CGFloat = 100.0
    
    var value : CGFloat = 0.0 {
        didSet {
            updateKnobPosition()
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
        let dragLocation = superview!.convert(event.locationInWindow, from: nil)
        
        // Assign mousePosition variable
        let mousePosition = dragLocation.x.rounded() + 4
        
        // Check the new position is not less than the minPoint and does not exceed maxPoint
        guard mousePosition >= minPoint,
              mousePosition <= maxPoint else { return }
        
        // Assign calculated number to _value
        let newValue = ((mousePosition - minPoint) / (maxPoint - minPoint) * maxValue).rounded()
        
        // Check the _value does not exceed maxKnob value
        guard let maxKnobValue = maxKnob?.value,
              maxKnobValue > newValue else { return }
        
        value = newValue
        
        let _ = sendAction(action, to: target)
    }
    
    func updateKnobPosition() {
        // Assign calculated number to the view's center position
        frame.origin.x = ((maxPoint - minPoint) * (value / maxValue) + minPoint).rounded() - 8
    }
}

// MaxKnob

class CYBRangeSliderKnobOutPoint: NSControl {
    
    var minKnob: CYBRangeSliderKnobInPoint?
    
    var minPoint: CGFloat = 0.0
    var maxPoint: CGFloat = 0.0
    
    var minValue: CGFloat = 0.0
    var maxValue: CGFloat = 100.0
    
    var value : CGFloat = 100.0 {
        didSet {
            updateKnobPosition()
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
        
        let dragLocation = superview!.convert(event.locationInWindow, from: nil)

        let mousePosition = dragLocation.x.rounded() - 4
        
        // Check the new position is not less than the minPoint and does not exceed maxPoint
        guard mousePosition >= minPoint,
              mousePosition <= maxPoint else { return }
        
        // Assign calculated number to _value
        let newValue = ((mousePosition - minPoint) / (maxPoint - minPoint) * maxValue).rounded()
    
        // Check the _value does not exceed maxKnob value
        guard let minKnobValue = minKnob?.value,
              minKnobValue < newValue else { return }
        
        value = newValue
        
        let _ = sendAction(action, to: target)
    }
    
    func updateKnobPosition() {
        // Assign calculated number to the view's center position
        frame.origin.x = ((maxPoint - minPoint) * (value / maxValue) + minPoint).rounded()
    }
    
    override func mouseUp(with event: NSEvent) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "com.cyberseeds.MediaQ.sliderMaxMouseReleased"),
                                        object:     nil,
                                        userInfo:   nil)
    }
}
