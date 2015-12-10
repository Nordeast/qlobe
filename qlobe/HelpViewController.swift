//
//  HelpViewController.swift
//  qlobe
//
//  Created by allen rand on 12/9/15.
//  Copyright © 2015 qlobe. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    // MARK: outlets
    
    @IBOutlet weak var helpTextView: UITextView!
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: View setup functions
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func style(){
        
        view.backgroundColor = UIColor(netHex:0x2c3e50)
        
        // set text view styling
        helpTextView.selectable = true
        helpTextView.editable = true

        helpTextView.font = UIFont(name: "Kankin", size: 15)
        helpTextView.textColor = UIColor(netHex: 0xeeeeee)
        helpTextView.textAlignment = NSTextAlignment.Left
        helpTextView.backgroundColor = UIColor(netHex:0x2c3e50)
        
        helpTextView.selectable = false
        helpTextView.editable = false

        // button styling
        backButton.titleLabel!.font = UIFont(name: "Kankin", size: 25)!
        backButton.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        backButton.titleLabel!.text = "Back"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
