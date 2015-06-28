//
//  BarElement.swift
//  davidSoOrganised
//
//  Created by David Kouřil on 13/06/15.
//  Copyright (c) 2015 dvdkouril. All rights reserved.
//

import Foundation

class BarElement {
    var startPercent: Double // between 0.0 and 1.0
    var endPercent: Double // between 0.0 and 1.0
    
    init() {
        startPercent = 0
        endPercent = 0
    }
    
    init(start : Double, end : Double) {
        startPercent = start
        endPercent = end
    }
}