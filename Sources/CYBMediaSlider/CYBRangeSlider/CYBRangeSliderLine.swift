//
//  File.swift
//  
//
//  Created by Kiyoshi Nagahama on 10/25/21.
//

import Cocoa

/// This is a class to draw a range line
///
class CYBRangeSliderLine: NSView {
    
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
