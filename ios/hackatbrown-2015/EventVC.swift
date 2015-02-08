//
//  EventVC.swift
//  hackatbrown-2015
//
//  Created by Matt Cooper on 2/7/15.
//  Copyright (c) 2015 Matthew Cooper. All rights reserved.
//

import UIKit

class EventVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var songs : NSMutableArray = []
    override func viewDidLoad() {
        songs = NSMutableArray()
        for var i = 0; i < 10; i++ {
            let song : Song = Song();
            song.artist = "J Beibs";
            song.title = "Turn down for hackathonz"
            song.albumCover = UIImage(named: "nirvana");
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : SongCell = tableView.dequeueReusableCellWithIdentifier("songCell") as SongCell
        
        cell.setupWithSong(songs[indexPath.row] as Song)
        
        return cell
    }
}
