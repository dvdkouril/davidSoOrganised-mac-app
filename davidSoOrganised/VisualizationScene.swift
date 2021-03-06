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
    var timelineHasBeenDrawn = false
    
    override init(size: CGSize) {
        super.init(size: size)
        //println("init start")
        for _ in 0..<numberOfDaysLoaded {
            daysLoaded.append(false)
            //println(i)
        }
        //println("init end")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        
        let offset = 63
        
        // TODO:
        //    1. get current date
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate() // today's date
        var components = calendar.components([.Weekday, .Day, .Month, .Year], fromDate: date)
        // extract day/ month/ year from the date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        //    2. find last monday
        //    3. draw graph for 7 days starting from that monday
        
        // use it in the string "day"
        
        for index in 0...6 {
            let currentBarDate = calendar.dateByAddingUnit(.Day, value: -index, toDate: date, options: [])!
            components = calendar.components([.Weekday, .Day, .Month, .Year], fromDate: currentBarDate)
            //let dayStr = "\(components.year)-\(components.month)-\(components.day - index)"
            let dayStr = "\(components.year)-\(components.month)-\(components.day)"
            //components.day
            //let weekday = components.weekday
            let dayDataBar = DayBar(day: dayStr, scene: self, yPos: offset + index*20, dayIndex: index)
            dayDataBar.requestData()
            
            //let weekdayStr = getWeekdayString(weekday)
            let weekdayFormatter = NSDateFormatter()
            weekdayFormatter.dateFormat = "EEE"
            let weekdayStr = weekdayFormatter.stringFromDate(currentBarDate)
            
            // day title
            //drawText(dayStr, pos: CGPoint(x: 77, y: 59 + index*20), size: 10)
            let text = SKLabelNode(fontNamed: "Avenir Next")
            text.text = "\(weekdayStr) \(dayStr)"
            text.fontSize = 10
            text.position = CGPoint(x: 108, y: 63 + index*20)
            //text.horizontalAlignmentMode = .Left
            text.horizontalAlignmentMode = .Right
            text.verticalAlignmentMode = .Bottom
            self.addChild(text)
        }
        
        let endStr = "\(components.year)-\(components.month)-\(components.day)"
        let startStr = "\(components.year)-\(components.month)-\(components.day - 6)"
        
        // Title
        let juneText = SKLabelNode(fontNamed: "Avenir Next")
        //juneText.text = "Last 7 days: 23 June 2015 - 29 June 2015"
        juneText.text = "Last 7 days: \(startStr) - \(endStr)"
        juneText.fontSize = 24
        juneText.position = CGPoint(x: 46, y: 242)
        juneText.horizontalAlignmentMode = .Left
        juneText.verticalAlignmentMode = .Bottom
        self.addChild(juneText)
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if allDaysLoaded() && !timelineHasBeenDrawn {
            drawTimeline()
            // TODO: make sure that it only draws it once (or rather that it adds the node only once)
            timelineHasBeenDrawn = true
        }
    }
    
    // pos ... is position of left bottom corner
    func drawRectAt(scene : SKScene, pos : CGPoint, size : CGSize, col : SKColor) {
        let rect = SKShapeNode(rectOfSize: size)
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
    
    func drawText(textToDraw: String, pos : CGPoint, size: CGFloat) {
        let text = SKLabelNode(fontNamed: "Avenir Next")
        text.text = textToDraw
        text.fontSize = size
        text.position = pos
        text.horizontalAlignmentMode = .Left
        text.verticalAlignmentMode = .Bottom
        self.addChild(text)
    }
    
    func drawTimeline() {
        
        
        
        // 0:00 line
        drawRectAt(self, pos: CGPoint(x: 120, y: 58), size: CGSize(width: 1, height: 140), col: SKColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 1.0))
        drawText("0:00", pos: CGPoint(x: 110, y: 203), size: 10)
        
        // 6:00 line
        drawRectAt(self, pos: CGPoint(x: 263, y: 58), size: CGSize(width: 1, height: 140), col: SKColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 1.0))
        drawText("6:00", pos: CGPoint(x: 253, y: 203), size: 10)
        
        // 12:00 line
        drawRectAt(self, pos: CGPoint(x: 407, y: 58), size: CGSize(width: 1, height: 140), col: SKColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 1.0))
        drawText("12:00", pos: CGPoint(x: 394, y: 203), size: 10)
        
        // 18:00 line
        drawRectAt(self, pos: CGPoint(x: 550, y: 58), size: CGSize(width: 1, height: 140), col: SKColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 1.0))
        drawText("18:00", pos: CGPoint(x: 537, y: 203), size: 10)
        
        // 0:00 line
        drawRectAt(self, pos: CGPoint(x: 693, y: 58), size: CGSize(width: 1, height: 140), col: SKColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 1.0))
        drawText("0:00", pos: CGPoint(x: 684, y: 203), size: 10)
    }
    
}
