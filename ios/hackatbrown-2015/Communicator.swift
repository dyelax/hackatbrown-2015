//
//  Communicator.swift
//  hackatbrown-2015
//
//  Created by Rick Miyagi on 2/7/15.
//  Copyright (c) 2015 Matthew Cooper. All rights reserved.
//

import UIKit

class Communicator: NSObject {
    
    func communicate() {
        let url = "http://127.0.0.1:5000/new/1/10,10"
        let nsurl = NSURL(string: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(nsurl!, completionHandler: {
            
            data, response, error in
            
            if (error != nil) {
                println(error)
            }
            else {
                let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                
                println(jsonResult)
            }
        })
        task.resume()
    }
    
    //func receivePlaylist
    //func sendStarred
    //func sendCreatedEvent
    //func playerActions
    

}
