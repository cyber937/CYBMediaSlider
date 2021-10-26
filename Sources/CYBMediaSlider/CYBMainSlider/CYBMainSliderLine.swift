//
//  File.swift
//  
//
//  Created by Kiyoshi Nagahama on 10/25/21.
//

import Cocoa

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

        let maxRect = NSMakeRect(self.frame.size.width + 8 - maxKnobPosition, 0, self.frame.size.width, 5)
        maxRect.fill()
    }
}
