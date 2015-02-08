//
//  IntroVC.swift
//  hackatbrown-2015
//
//  Created by Matt Cooper on 2/7/15.
//  Copyright (c) 2015 Matthew Cooper. All rights reserved.
//

import UIKit
import CoreLocation

class IntroVC: UIViewController, CLLocationManagerDelegate {
    
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"
    
    var locationManager: CLLocationManager!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var createEventHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        seenError = false
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        self.createEventHeight.constant = self.view.bounds.height;
        
//        let thereIsAnEvent = true;
//        if (thereIsAnEvent){
//            self.createEventHeight.constant = 100;
//            
//        }else{
//            self.createEventHeight.constant = 666;
//        }
        UIView.animateWithDuration(0.5, delay: 5, options: nil, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            if (seenError == false) {
                seenError = true
                print(error)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            var locationArray = locations as NSArray
            var locationObj = locationArray.lastObject as CLLocation
            var coord = locationObj.coordinate
            
            println(coord.latitude)
            println(coord.longitude)
            
            
            self.createEventHeight.constant = 100
            UIView.animateWithDuration(0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            var shouldIAllow = false
            
            switch status {
            case CLAuthorizationStatus.Restricted:
                locationStatus = "Restricted Access to location"
            case CLAuthorizationStatus.Denied:
                locationStatus = "User denied access to location"
            case CLAuthorizationStatus.NotDetermined:
                locationStatus = "Status not determined"
            default:
                locationStatus = "Allowed to location Access"
                shouldIAllow = true
            }
            NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
            if (shouldIAllow == true) {
                NSLog("Location to Allowed")
                // Start location services
                locationManager.startUpdatingLocation()
            } else {
                NSLog("Denied access: \(locationStatus)")
            }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let ad = UIApplication.sharedApplication().delegate as AppDelegate
        let session = ad.session
        
        
        if (segue.identifier == "modalEventVC" || segue.identifier == "modalCreateEventVC") {
            SPTRequest.starredListForUserInSession(session, callback: {
                (error, result) -> Void in
                
                
                if (error != nil) {
                    NSLog("*** Auth error: %@", error)
                    println("failed")
                    return
                }
                
                // Call the -playUsingSession: method to play a track
                println(result)

                })
        }
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        println("locations = \(locations)")
    }

}



