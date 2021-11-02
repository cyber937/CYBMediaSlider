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
    
    @IBOutlet var mainSlider: CYBMainSlider!
    @IBOutlet var rangeSlider: CYBRangeSlider!

    @Published public var value: CGFloat = 0.0 {
        didSet {
            mainSlider.value = value
        }
    }
    
    @Published public var inPointValue: CGFloat = 0.0 {
        didSet {
            rangeSlider.inPointValue = inPointValue
        }
    }
    
    @Published public var outPointValue: CGFloat = 100.0 {
        didSet {
            rangeSlider.outPointValue = outPointValue
        }
    }
    
    public var minValue: CGFloat = 0 {
        didSet {
            mainSlider.minValue = CGFloat(minValue)
            rangeSlider.minValue = CGFloat(minValue)
        }
    }
    
    public var maxValue: CGFloat = 100 {
        didSet {
            mainSlider.maxValue = CGFloat(maxValue)
            rangeSlider.maxValue = CGFloat(maxValue)
        }
    }
    
    public var isEditabled: Bool = true {
        didSet {
            mainSlider.isEditabled = isEditabled
            rangeSlider.isEditabled = isEditabled
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            mainSlider.isEnabled = isEnabled
            rangeSlider.isEnabled = isEnabled
        }
    }
    
    public var rangeSliderIsEnable: Bool = true{
        didSet {
            rangeSlider.isEnabled = rangeSliderIsEnable
        }
    }
    
    public weak var delegate: CYBMediaSliderDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        Bundle.module.loadNibNamed("CYBMediaSlider", owner: self, topLevelObjects: nil)
        
        let contentFrame = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height)
        self.view.frame = contentFrame
        self.addSubview(self.view)
        
        mainSlider.target = self
        mainSlider.action = #selector(mainSliderValueChanged)
        
        rangeSlider.rangeSliderKnobInPoint.target = self
        rangeSlider.rangeSliderKnobInPoint.action = #selector(inPointValueChanged)
        
        rangeSlider.rangeSliderKnobOutPoint.target = self
        rangeSlider.rangeSliderKnobOutPoint.action = #selector(outPointValueChanged)
 
    }
    
    @objc func mainSliderValueChanged() {
        value = mainSlider.value
    }

    @objc func inPointValueChanged() {
        inPointValue = rangeSlider.rangeSliderKnobInPoint.value
    }

    @objc func outPointValueChanged() {
        outPointValue = rangeSlider.rangeSliderKnobOutPoint.value
    }
}
