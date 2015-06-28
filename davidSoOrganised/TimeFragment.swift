//
//  TimeFragment.swift
//  davidSoOrganised
//
//  Created by David Kouřil on 15/06/15.
//  Copyright (c) 2015 dvdkouril. All rights reserved.
//

import Foundation

// TimeFragment class represents 5 minute time fragment with information about activites done in that 5 minute interval
class TimeFragment : Equatable, Printable, DebugPrintable {
    let timeStamp : String
    var activities : [(String,Int,Int)] // triple: name, time (in seconds), productivity score
    
    init(timeStamp : String) {
        self.timeStamp = timeStamp
        activities = [(String,Int, Int)]()
    }
    
    func addActivity(activity : String, time : Int, prodScore : Int) {
        activities.append((activity, time, prodScore))
    }
    
    /*override func == (lhs : TimeFragment, rhs : TimeFragment) -> Bool {
        return lhs.timeStamp == rhs.timeStamp
    }*/
    var description : String {
        var retString = "TimeFragment \(timeStamp), activities:"
        
        for (activity, time, productivity) in activities {
            retString += " (\(activity), \(time) s, \(productivity))"
        }
        
        return retString
    }
    
    var debugDescription : String {
        var retString = "TimeFragment \(timeStamp), activities:"
        
        for (activity, time, productivity) in activities {
            retString += " (\(activity), \(time) s, \(productivity))"
        }
        
        return retString
    }
    
    // computes weighted averages: 
    // (activity_1 * time_lasted_1 + activity_2 * time_lasted_2 + ...) / (time_lasted_1 + time_lasted_2 + ...)
    func weightedAverageOfActivities() -> Double {        var sum : Int = 0
        var sumWeights : Int = 0
        
        for (name, time, productivity) in activities {
            sum += productivity * time
            sumWeights += time
        }
        
        return Double(sum) / Double(sumWeights)
    }
    
}

func ==(lhs : TimeFragment, rhs : TimeFragment) -> Bool {
    return lhs.timeStamp == rhs.timeStamp
}