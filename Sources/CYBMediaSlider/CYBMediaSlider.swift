//
//  CustomSlider.swift
//  Custom_Slider
//
//  Created by Kiyoshi Nagahama on 12/21/19.
//  Copyright © 2019 Kiyoshi Nagahama. All rights reserved.
//

import Cocoa

extension NSBindingName {
    public static let CYBSliderBindingValue = NSBindingName("CYVSliderValue")
    public static let CYBSliderBindingInPoint = NSBindingName("CYVSliderInPoint")
    public static let CYBSliderBindingOutPoint = NSBindingName("CYVSliderOutPoint")
}

public class CYBMediaSlider: NSControl {
    
    @IBOutlet var view: NSView!
    
    @IBOutlet var mainSlider: CYBMainSlider!
    @IBOutlet var rangeSlider: CYBRangeSlider!
    
    var _value: CGFloat = 0
    
    public var value: CGFloat {
        
        get {
            return _value
        }
        
        set (newValue) {
            _value = newValue
            mainSlider.value = CGFloat(value)
            
            guard let observedObjectForSliderValue = observedObjectForSliderValue as? NSObject else { return }
            observedObjectForSliderValue.setValue(_value, forKey: observedKeyPathForSliderValue)
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
    
    var _inPointValue: CGFloat = 0
    
    public var inPointValue: CGFloat {
        
        get {
            return _inPointValue
        }
        
        set (newValue) {
            _inPointValue = newValue
            rangeSlider.rangeSliderKnobInPoint.value = newValue
            
            if newValue >= rangeSlider.rangeSliderKnobOutPoint.value {
                rangeSlider.rangeSliderKnobOutPoint.value = maxValue
            }
        }
    }
    
    var _outPointValue: CGFloat = 100
    
    public var outPointValue: CGFloat {
        
        get {
            return _outPointValue
        }
        
        set (newValue) {
            _outPointValue = newValue
            rangeSlider.rangeSliderKnobOutPoint.value = newValue
            
            if newValue <= rangeSlider.rangeSliderKnobInPoint.value {
                rangeSlider.rangeSliderKnobInPoint.value = minValue
            }
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
    
    // Values for Binding
    
    var observedObjectForSliderValue: Any!
    var observedKeyPathForSliderValue: String = ""
    
    var observedObjectForSliderInPoint: Any!
    var observedKeyPathForSliderInPoint: String = ""
    
    var observedObjectForSliderOutPoint: Any!
    var observedKeyPathForSliderOutPoint: String = ""
    
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
        
        rangeSlider.rangeKnobsDelegate = mainSlider
    }

    override public func bind(_ binding: NSBindingName, to observable: Any, withKeyPath keyPath: String, options: [NSBindingOption : Any]? = nil) {
        
        guard let obserableObject = observable as? NSObject else { return }
        
        if binding == .CYBSliderBindingValue {
            obserableObject.addObserver(self, forKeyPath: keyPath, options: [], context: nil)
            
            observedObjectForSliderValue = obserableObject
            observedKeyPathForSliderValue = keyPath
            
        } else if binding == .CYBSliderBindingInPoint {
            obserableObject.addObserver(self, forKeyPath: keyPath, options: [], context: nil)
            
            observedObjectForSliderInPoint = obserableObject
            observedKeyPathForSliderInPoint = keyPath
            
        } else if binding == .CYBSliderBindingOutPoint {
            obserableObject.addObserver(self, forKeyPath: keyPath, options: [], context: nil)
            
            observedObjectForSliderOutPoint = obserableObject
            observedKeyPathForSliderOutPoint = keyPath
            
        }
        
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == observedKeyPathForSliderValue {
            if let observedObjectForSliderValue = observedObjectForSliderValue as? NSObject {
                _value = observedObjectForSliderValue.value(forKey: observedKeyPathForSliderValue) as! CGFloat
            }
        } else if keyPath == observedKeyPathForSliderInPoint {
            if let observedObjectForSliderInPoint = observedObjectForSliderInPoint as? NSObject {
                _inPointValue = observedObjectForSliderInPoint.value(forKey: observedKeyPathForSliderInPoint) as! CGFloat
            }
        } else if keyPath == observedKeyPathForSliderOutPoint {
        if let observedObjectForSliderOutPoint = observedObjectForSliderOutPoint as? NSObject {
            _outPointValue = observedObjectForSliderOutPoint.value(forKey: observedKeyPathForSliderOutPoint) as! CGFloat
            }
        }
        
    }
    
    @objc func mainSliderValueChanged() {
        _value = mainSlider.value
        
        guard let observedObjectForSliderValue = observedObjectForSliderValue as? NSObject else { return }
        observedObjectForSliderValue.setValue(_value, forKey: observedKeyPathForSliderValue)
        
        delegate?.didUpdateValue(_value)
    }
    
    @objc func inPointValueChanged() {
        _inPointValue = rangeSlider.rangeSliderKnobInPoint.value
        
        guard let observedObjectForSliderInPoint = observedObjectForSliderInPoint as? NSObject else { return }
        observedObjectForSliderInPoint.setValue(_inPointValue, forKey: observedKeyPathForSliderInPoint)
        
        delegate?.didUpdatInpointValue(_inPointValue)
    }
    
    @objc func outPointValueChanged() {
        _outPointValue = rangeSlider.rangeSliderKnobOutPoint.value
        
        guard let observedObjectForSliderOutPoint = observedObjectForSliderOutPoint as? NSObject else { return }
        observedObjectForSliderOutPoint.setValue(_outPointValue, forKey: observedKeyPathForSliderOutPoint)
        
        delegate?.didUpdatOutpointValue(_outPointValue)
    }
}
