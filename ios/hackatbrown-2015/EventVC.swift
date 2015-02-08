//
//  EventVC.swift
//  hackatbrown-2015
//
//  Created by Matt Cooper on 2/7/15.
//  Copyright (c) 2015 Matthew Cooper. All rights reserved.
//

import UIKit


class EventVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var songs : NSMutableArray = [10]
    override func viewDidLoad() {
        songs = NSMutableArray()
        for var i = 0; i < 10; i++ {
            let song : Song = Song();
            song.artist = "J Beibs";
            song.title = "Turn down for hackathonz"
            song.albumCover = UIImage(named: "nirvana");
            
            songs.addObject(song)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : SongCell = tableView.dequeueReusableCellWithIdentifier("songCell") as SongCell
        
        cell.setupWithSong(songs[indexPath.row] as Song)
        
        if indexPath.row == 0{
            cell.backgroundColor = UIColor(red:(0x16 / 255.0), green:(0x95 / 255.0), blue:(0xA3 / 255.0), alpha:1.0)
        }else{
            cell.backgroundColor = UIColor(red:(0xAC / 255.0), green:(0xF0 / 255.0), blue:(0xF2 / 255.0), alpha:1.0)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 59
    }
    
    @IBAction func leave(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
}
