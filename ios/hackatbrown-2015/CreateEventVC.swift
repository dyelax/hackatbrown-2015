//
//  CreateEventVC.swift
//  hackatbrown-2015
//
//  Created by Matt Cooper on 2/7/15.
//  Copyright (c) 2015 Matthew Cooper. All rights reserved.
//

import UIKit

class CreateEventVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var eventPicker: UIPickerView!
    
    var picker = ["Happy", "Sad", "Angry", "Excited", "Relaxing"]

    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("keyboardWillAppear"), name:UIKeyboardWillShowNotification, object:nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("keyboardWillDisappear"), name:UIKeyboardWillHideNotification, object:nil);
    }
    
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
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5;
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var s:NSMutableAttributedString
        let a = picker[row]
        return NSAttributedString(string: a, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    func keyboardWillAppear(){
        self.eventPicker.userInteractionEnabled = false;
    }
    func keyboardWillDisappear(){
        self.eventPicker.userInteractionEnabled = true;
    }
    @IBAction func dismissKeyboard(sender: AnyObject) {
        self.view.endEditing(true);
    }
    
    
    @IBAction func done(sender: AnyObject) {
        //post event
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
