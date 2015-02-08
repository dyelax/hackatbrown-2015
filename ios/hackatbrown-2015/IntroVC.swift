//
//  IntroVC.swift
//  hackatbrown-2015
//
//  Created by Matt Cooper on 2/7/15.
//  Copyright (c) 2015 Matthew Cooper. All rights reserved.
//

import UIKit

class IntroVC: UIViewController {
    
    override func viewDidLoad() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let ad = UIApplication.sharedApplication().delegate as AppDelegate
        let session = ad.session
        
        if (segue.identifier == "modalEventVC") {
            SPTRequest.starredListForUserInSession(session, callback: {
                error, session in
                
                if (error != nil) {
                    NSLog("*** Auth error: %@", error)
                    return
                }
                
                // Call the -playUsingSession: method to play a track
                })
        
    }

} 

}

