//
//  File.swift
//  
//
//  Created by Kiyoshi Nagahama on 10/25/21.
//

import Cocoa

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
        
        guard isEnabled else { return }
        
        var knobColor: NSColor
        
        if isEditabled {
            knobColor = NSColor(red: 1, green: 0.687, blue: 0, alpha: 1)
        } else {
            knobColor = NSColor.lightGray
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
    
    override func accessibilityRole() -> NSAccessibility.Role? {
        return NSAccessibility.Role.valueIndicator
    }
    
    override func isAccessibilityElement() -> Bool {
        true
    }
   
    override func isAccessibilityEnabled() -> Bool {
        return isEnabled
    }

}
