//
//  File.swift
//  
//
//  Created by Kiyoshi Nagahama on 10/25/21.
//

import Cocoa

class CYBMainSliderLine: NSControl {

    var minKnobPosition: CGFloat = 0.0
    var maxKnobPosition: CGFloat = 0.0

    var isEditabled: Bool = true {
        didSet {
            needsDisplay = true
        }
    }

    override var isEnabled: Bool {
        didSet {
            needsDisplay = true
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        guard isEnabled && isEditabled else {
            NSColor.disabledControlTextColor.setFill()
            bounds.fill()
            return
        }
        
        NSColor.gray.setFill()
        bounds.fill()
    }
}
