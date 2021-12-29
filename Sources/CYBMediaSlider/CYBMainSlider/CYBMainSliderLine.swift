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
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        guard isEnabled else {
            NSColor.disabledControlTextColor.setFill()
            bounds.fill()
            return
        }
        
        if isEditabled {
            NSColor.gray.setFill()
        } else {
            NSColor.lightGray.setFill()
        }

        bounds.fill()
    }
}
