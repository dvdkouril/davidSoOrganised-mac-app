//
//  AppDelegate.swift
//  davidSoOrganised
//
//  Created by David Kouřil on 13/06/15.
//  Copyright (c) 2015 dvdkouril. All rights reserved.
//

import Cocoa
//import Alamofire

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    var masterViewController : MasterViewController!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        masterViewController = MasterViewController(nibName: "MasterViewController", bundle: nil)
        
        window.contentView.addSubview(masterViewController.view)
        masterViewController.view.frame = (window.contentView as! NSView).bounds
        
//        Alamofire.request(.GET, "https://www.rescuetime.com/anapi/data", parameters: ["key" : "B63nbJddWyKeBy27Zvr167duFarnzSiqczF2AbM9",
//            "format" : "json",
//            "perspective" : "interval",
//            "restrict_begin" : "2015-05-01",
//            "restrict_end" : "2015-05-01",
//            "resolution_time" : "minute"]).responseJSON() {
//            (_, _, data, _) in
//                //println(data)
//                let json = JSON(data!)
//                //println(json)
//                println(json["rows"])
//            
//            //JSON!.valueforKey("rows")
//        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

