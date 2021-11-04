//
//  CustomSlider.swift
//  Custom_Slider
//
//  Created by Kiyoshi Nagahama on 12/21/19.
//  Copyright © 2019 Kiyoshi Nagahama. All rights reserved.
//

import Cocoa

@available(macOS 10.15, *)
public class CYBMediaSlider: NSControl {
    
    @IBOutlet var view: NSView!
    @IBOutlet public var mainSlider: CYBMainSlider!

    @Published public var value: CGFloat = 0.0 {
        didSet {
            mainSlider.value = value
        }
    }
    
    @Published public var inPointValue: CGFloat = 0.0 {
        didSet {
            mainSlider.rangeInKnob.value = inPointValue
        }
    }
    
    @Published public var outPointValue: CGFloat = 100.0 {
        didSet {
            mainSlider.rangeOutKnob.value = outPointValue
        }
    }
    
    public var minValue: CGFloat = 0 {
        didSet {
            mainSlider.minValue = CGFloat(minValue)
        }
    }
    
    public var maxValue: CGFloat = 100 {
        didSet {
            mainSlider.maxValue = CGFloat(maxValue)
        }
    }
    
    public var isEditabled: Bool = true {
        didSet {
            mainSlider.isEditabled = isEditabled
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            mainSlider.isEditabled = isEnabled
            mainSlider.isEnabled = isEnabled
        }
    }
    
    public var rangeSliderIsEnable: Bool = true {
        didSet {
                mainSlider.rangeInKnob.isEnabled = rangeSliderIsEnable
                mainSlider.rangeOutKnob.isEnabled = rangeSliderIsEnable
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        Bundle.module.loadNibNamed("CYBMediaSlider", owner: self, topLevelObjects: nil)
        
        let contentFrame = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height)
        self.view.frame = contentFrame
        self.addSubview(self.view)
        
        mainSlider.target = self
        mainSlider.action = #selector(mainSliderValueChanged)
        
        mainSlider.rangeInKnob.target = self
        mainSlider.rangeInKnob.action = #selector(inPointValueChanged)
        
        mainSlider.rangeOutKnob.target = self
        mainSlider.rangeOutKnob.action = #selector(outPointValueChanged)
 
    }
    
    @objc func mainSliderValueChanged() {
        value = mainSlider.value
    }

    @objc func inPointValueChanged() {
        inPointValue = mainSlider.rangeInKnob.value
    }

    @objc func outPointValueChanged() {
        outPointValue = mainSlider.rangeOutKnob.value
    }
}
