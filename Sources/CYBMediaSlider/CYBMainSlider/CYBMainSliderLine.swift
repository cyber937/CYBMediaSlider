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
    
    //var lightGray = NSColor(red: 0.619, green: 0.619, blue: 0.619, alpha: 1)
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        guard isEnabled else {
            NSColor.unemphasizedSelectedContentBackgroundColor.setFill()
            bounds.fill()
            return
        }
        
        if isEditabled {
            NSColor.gray.setFill()
        } else {
            NSColor.lightGray.setFill()
        }

        bounds.fill()
   
        let minRect = NSMakeRect(0, 0, minKnobPosition, 15)
        minRect.fill()

        let maxRect = NSMakeRect(self.frame.size.width + 8 - maxKnobPosition, 0, self.frame.size.width, 5)
        maxRect.fill()
    }
}
