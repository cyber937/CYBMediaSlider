//
//  CYBMediaSliderDelegate.swift
//  CYBMediaSlider
//
//  Created by Kiyoshi Nagahama on 1/12/20.
//  Copyright © 2020 Kiyoshi Nagahama. All rights reserved.
//

import Cocoa

@objc public protocol CYBMediaSliderDelegate {
    func didUpdateValue(_ value: CGFloat)
    func didUpdatInpointValue(_ value: CGFloat)
    func didUpdatOutpointValue(_ value: CGFloat)
}
