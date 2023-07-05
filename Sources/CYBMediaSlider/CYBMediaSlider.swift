//
//  CustomSlider.swift
//  Custom_Slider
//
//  Created by Kiyoshi Nagahama on 12/21/19.
//  Copyright © 2019 Kiyoshi Nagahama. All rights reserved.
//

import Cocoa
import Combine

public class CYBMediaSlider: NSControl {
    
    @IBOutlet var view: NSView!
    @IBOutlet var mainSlider: CYBMainSlider!

    @Published public var value: CGFloat = 0.0 {
        didSet {
            mainSlider.value = value
            if mainSlider.mouseRightPlaceToClicked {
                let _ = sendAction(action, to: target)
            }
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
    
    public var minValue: CGFloat = 0.0 {
        didSet {
            mainSlider.minValue = CGFloat(minValue)
        }
    }
    
    public var maxValue: CGFloat = 100.0 {
        didSet {
            mainSlider.maxValue = CGFloat(maxValue)
        }
    }
    
    public var isEditabled: Bool = true {
        didSet {
            mainSlider.mainSliderKnob.isEditabled = isEditabled
            mainSlider.isEditabled = isEditabled
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            mainSlider.isEnabled = isEnabled
            //mainSlider.mainSliderKnob.isHidden = !isEnabled
            //mainSlider.mainSliderKnob.isEnabled = isEnabled
        }
    }
    
    public var roundedValue: Bool = false {
        didSet {
            mainSlider.roundedValue = roundedValue
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
 
        isEnabled = true
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
    
    public override func accessibilityRole() -> NSAccessibility.Role? {
        return NSAccessibility.Role.slider
    }

    public override func isAccessibilityElement() -> Bool {
        true
    }

    public override func isAccessibilityEnabled() -> Bool {
        true
    }
    
    public override func accessibilityLabel() -> String? {
        return NSLocalizedString("CYBMediaSlider", comment: "accessibility label of the CYBMediaSldier")
    }

    public override func accessibilityChildren() -> [Any]? {
        return [mainSlider!.mainSliderKnob!]
    }

    public override func accessibilityMaxValue() -> Any? {
        return maxValue
    }

    public override func accessibilityMinValue() -> Any? {
        return minValue
    }

    public override func setAccessibilityValue(_ accessibilityValue: Any?) {

        guard let value = accessibilityValue as? CGFloat else { return }

        print(value)

        self.value = value
    }


    public override func accessibilityPerformDecrement() -> Bool {
        return true
    }

    public override func accessibilityPerformIncrement() -> Bool {
        return true
    }

    public override func accessibilityValue() -> Any? {
        return self.value
    }
    
    public override func accessibilityOrientation() -> NSAccessibilityOrientation {
        return .horizontal
    }
}


