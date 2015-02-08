//
//  IntroVC.swift
//  hackatbrown-2015
//
//  Created by Matt Cooper on 2/7/15.
//  Copyright (c) 2015 Matthew Cooper. All rights reserved.
//

import UIKit

class IntroVC: UIViewController {
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var createEventHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        let thereIsAnEvent = true;
        if (thereIsAnEvent){
            self.createEventHeight.constant = 40;
            UIView.animateWithDuration(0.5, delay: 5, options: nil, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
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

