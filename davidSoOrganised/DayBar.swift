//
//  DayBar.swift
//  davidSoOrganised
//
//  Created by David Kouřil on 13/06/15.
//  Copyright (c) 2015 dvdkouril. All rights reserved.
//

import Foundation
import SpriteKit
import Alamofire

class DayBar {
    let barHeight: Int
    let barWidth: Int
    let barYPos: Int
    let dayIndex: Int
    
    var dayTimeStamp: String!
    var fragsDir = [String:TimeFragment]()
    var scene : SKScene!
    
    var barContent: [BarElement]
    
    init() {
        barHeight = 50
        barWidth = 500
        barYPos = 0
        barContent = [BarElement]()
        dayIndex = 0
    }
    
    /*init(barWidth: Int, barHeight: Int) {
        self.barHeight = barHeight
        self.barWidth = barWidth
        barYPos = 0
        barContent = [BarElement]()
    }*/
    
    // it has to be in format YYYY-mm-dd
    init(day : String, scene : SKScene, yPos : Int, dayIndex : Int) { // TODO: last two arguments can be merged
        dayTimeStamp = day
        barContent = [BarElement]()
        self.scene = scene
        barYPos = yPos
        self.dayIndex = dayIndex
        
        // I don't even think I need these now
        barWidth = 0
        barHeight = 0
    }
    
    func addElement(el : BarElement) {
        barContent.append(el)
    }
    
    func requestData() {
        Alamofire.request(.GET, "https://www.rescuetime.com/anapi/data", parameters: ["key" : "B63nbJddWyKeBy27Zvr167duFarnzSiqczF2AbM9",
            "format" : "json",
            "perspective" : "interval",
            "restrict_begin" : dayTimeStamp,
            "restrict_end" : dayTimeStamp,
            "resolution_time" : "minute"]).responseJSON() {
                (_, _, data, _) in
        
                let json = JSON(data!) // I will be parsing the data with SwiftyJSON
                
                //var fragsDir = [String:TimeFragment]() // in this directory I store information about all time fragments tracked
                
                for record in json["rows"] {
                    
                    let activity = record.1[3]
                    let numberOfSeconds = record.1[1]
                    let timeStarted = record.1[0]
                    let productivityScore = record.1[5]
                    
                    if self.fragsDir.indexForKey(timeStarted.string!) == nil { // new time fragment
                        
                        self.fragsDir[timeStarted.string!] = TimeFragment(timeStamp: timeStarted.string!)
                        self.fragsDir[timeStarted.string!]?.addActivity(activity.string!, time: numberOfSeconds.intValue, prodScore: productivityScore.intValue)
                        
                    } else { // some info for this time fragment has already been found
                        
                        self.fragsDir[timeStarted.string!]?.addActivity(activity.string!, time: numberOfSeconds.intValue, prodScore: productivityScore.intValue)
                        
                    }
                    
                }
                // debug: In what interval are the productivity data?
                for (String,timeFragment) in self.fragsDir {
                    println(timeFragment.weightedAverageOfActivities())
                }
                
                println("finished request")
                // dirty...
                self.drawGraph(self.scene)
                (self.scene as! VisualizationScene).setDayIsLoaded(self.dayIndex)
        }
    }
    
    func drawGraph(scene : SKScene) {
        // problem: what if there is not a single fragment tracked yet for this day?
        if fragsDir.count == 0 {
            return
        }
        
        var sampleTimeStamp = fragsDir[fragsDir.startIndex].0 // pick the first record in directory, just to get
        // the same day date
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        var dayDate = dateFormatter.dateFromString(sampleTimeStamp)
        println(dateFormatter.stringFromDate(dayDate!)) // this is how see the "correct" date
        
        let calendar = NSCalendar.currentCalendar()
        var components = calendar.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear |
            .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDate: dayDate!)
        // reseting the time to start of the day
        components.hour = 0
        components.minute = 0
        components.second = 0
        var iteratingDate = calendar.dateFromComponents(components)
        println("after reseting: \(dateFormatter.stringFromDate(iteratingDate!))")
        
        components.hour = 23
        components.minute = 55
        components.second = 0
        var endDate = calendar.dateFromComponents(components)
        println("last date to check: \(dateFormatter.stringFromDate(endDate!))")
        
        println("Number of fragments: \(fragsDir.count)")
        
        var i = 0
        //var xOffset : CGFloat = (800 - 576) / 2
        var xOffset : CGFloat = 120
        
        // background rect (untracked time)
        drawRectAt(scene, pos: CGPoint(x: xOffset, y: CGFloat(barYPos)), size: CGSize(width: 576, height: 10), col: SKColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.0))
        
        while !(iteratingDate!.isEqualToDate(endDate!)) { // bug: doesn't draw the last 5-min
            var itDateString = dateFormatter.stringFromDate(iteratingDate!)
            var size = CGSize(width: 576 / 288, height: 10)
            
            if fragsDir.indexForKey(itDateString) == nil { // no activity for this date
                // draw empty rect
                /*var color : SKColor
                color = SKColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
                
                self.drawRectAt(scene, pos: CGPoint(x: CGFloat(xOffset + CGFloat(i) * size.width), y: CGFloat(self.barYPos)), size: size, col: color)*/
            } else { // some activities found
                // draw rect based on average productivity
                var color : SKColor
                
                var productivity = fragsDir[itDateString]?.weightedAverageOfActivities()
                
                switch productivity! {
                case -2...(-1):
                    // rgb: 202, 68, 68
                    color = SKColor(red: 0.79, green: 0.27, blue: 0.27, alpha: 1.0)
                case -1...0:
                    // rgb: 221, 211, 102
                    color = SKColor(red: 0.87, green: 0.83, blue: 0.4, alpha: 1.0)
                case 0...1:
                    // rgb 62, 161, 135
                    color = SKColor(red: 0.24, green: 0.63, blue: 0.53, alpha: 1.0)
                case 1...2:
                    // rgb 70, 221, 162
                    color = SKColor(red: 0.27, green: 0.87, blue: 0.64, alpha: 1.0)
                default:
                    color = SKColor.magentaColor()
                }
                
                self.drawRectAt(scene, pos: CGPoint(x: CGFloat(xOffset + CGFloat(i) * size.width), y: CGFloat(self.barYPos)), size: size, col: color)
            }
            
            iteratingDate = iteratingDate?.dateByAddingTimeInterval(300) // jump 5 minutes (300 seconds) in time
            i += 1
        }

    }
    
    // pos ... is position of left bottom corner
    func drawRectAt(scene : SKScene, pos : CGPoint, size : CGSize, col : SKColor) {
        var rect = SKShapeNode(rectOfSize: size)
        rect.fillColor = col
        rect.position = CGPoint(x: pos.x + size.width / 2, y: pos.y + size.height / 2)
        rect.lineWidth = 0
        
        scene.addChild(rect)
    }
    
    func drawBar(scene : SKScene) {
        //var bgRect = SKShapeNode(rectOfSize: CGSize(width: barWidth, height: barHeight))
        //bgRect.fillColor = SKColor.grayColor()
        ////bgRect.position = CGPoint(x: 0, y: scene.frame.height / 2)
        //bgRect.position = CGPoint(x: CGFloat(0 + barWidth / 2), y: scene.frame.height / 2)
        
        //scene.addChild(bgRect)
        
        drawRectAt(scene, pos: CGPoint(x: 0, y: scene.frame.height / 2), size: CGSize(width: barWidth, height: barHeight), col: SKColor.grayColor())
        
        for i in 0...23 {
            drawRectAt(scene, pos: CGPoint(x: CGFloat(0 + i * (barWidth / 24)), y: scene.frame.height / 2), size: CGSize(width: barWidth / 24, height: barHeight), col: SKColor.blackColor())
        }
    }
}





