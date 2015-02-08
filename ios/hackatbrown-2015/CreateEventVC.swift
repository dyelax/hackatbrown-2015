//
//  CreateEventVC.swift
//  hackatbrown-2015
//
//  Created by Matt Cooper on 2/7/15.
//  Copyright (c) 2015 Matthew Cooper. All rights reserved.
//

import UIKit

class CreateEventVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : GenreCell = tableView.dequeueReusableCellWithIdentifier("genreCell") as GenreCell
        
        if(indexPath.row == 0){
            cell.genreLabel.text = "Rock";
        }else if(indexPath.row == 1){
            cell.genreLabel.text = "Pop";
        }else if(indexPath.row == 2){
            cell.genreLabel.text = "Alternative";
        }else if(indexPath.row == 3){
            cell.genreLabel.text = "Classical";
        }else if(indexPath.row == 4){
            cell.genreLabel.text = "Reggae";
        }
        
        return cell
    }
}
