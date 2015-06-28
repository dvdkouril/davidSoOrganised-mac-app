//
//  VisualizationScene.swift
//  davidSoOrganised
//
//  Created by David Kouřil on 13/06/15.
//  Copyright (c) 2015 dvdkouril. All rights reserved.
//

import Cocoa
import SpriteKit
import Alamofire

class VisualizationScene: SKScene {
    
    let BAR_LENGTH = 500
    var dayOne : DayBar!
    let numberOfDaysLoaded = 7
    var daysLoaded = [Bool]()
    
    override init(size: CGSize) {
        super.init(size: size)
        //println("init start")
        for i in 0..<numberOfDaysLoaded {
            daysLoaded.append(false)
            //println(i)
        }
        //println("init end")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // pos ... is position of left bottom corner
    func drawRectAt(scene : SKScene, pos : CGPoint, size : CGSize, col : SKColor) {
        var rect = SKShapeNode(rectOfSize: size)
        rect.fillColor = col
        rect.position = CGPoint(x: pos.x + size.width / 2, y: pos.y + size.height / 2)
        rect.lineWidth = 0
        
        scene.addChild(rect)
    }
    
    func allDaysLoaded() -> Bool {
        
        for val in daysLoaded {
            if !val {
                return false
            }
        }
        
        return true
    }
    
    func setDayIsLoaded(index: Int) {
        daysLoaded[index] = true
    }
    
    override func didMoveToView(view: SKView) {
    
        //var offset = 50
        var offset = 63
        //dayOne = DayBar(barWidth: Int(self.frame.width), barHeight: 50)
        
        // Title
        var juneText = SKLabelNode(fontNamed: "Avenir Next")
        juneText.text = "Last 7 days: 23 June 2015 - 29 June 2015"
        juneText.fontSize = 24
        //juneText.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        juneText.position = CGPoint(x: 46, y: 242)
        juneText.horizontalAlignmentMode = .Left
        juneText.verticalAlignmentMode = .Bottom
        self.addChild(juneText)
        
        // get current date
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        let components = calendar.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: date)
        // extract day/ month/ year from the date
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        var dateString = dateFormatter.stringFromDate(date)
        //println(dateString)
        
        // use it in the string "day"
        
        for index in 0...6 {
            var dayStr = "\(components.year)-\(components.month)-\(components.day - index)"
            var dayDataBar = DayBar(day: dayStr, scene: self, yPos: offset + index*20, dayIndex: index)
            dayDataBar.requestData()
        }
        
        //while !allDaysLoaded() {
            
        //}
        
        // timeline lines
        drawRectAt(self, pos: CGPoint(x: 120, y: 58), size: CGSize(width: 1, height: 140), col: SKColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 1.0))
        drawRectAt(self, pos: CGPoint(x: 263, y: 58), size: CGSize(width: 1, height: 140), col: SKColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 1.0))
        drawRectAt(self, pos: CGPoint(x: 407, y: 58), size: CGSize(width: 1, height: 140), col: SKColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 1.0))
        drawRectAt(self, pos: CGPoint(x: 550, y: 58), size: CGSize(width: 1, height: 140), col: SKColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 1.0))
        drawRectAt(self, pos: CGPoint(x: 693, y: 58), size: CGSize(width: 1, height: 140), col: SKColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 1.0))
        
        /*var i = 0
        for day in 1...16 {
            var dayDataBar = DayBar(day: "2015-06-\(day)", scene: self, yPos: offset + i*10)
            dayDataBar.requestData()
            i += 1
        }*/
        
    }
}
