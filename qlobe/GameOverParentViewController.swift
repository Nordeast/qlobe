//
//  GameOverParentViewController.swift
//  qlobe
//
//  Created by allen rand on 12/9/15.
//  Copyright © 2015 qlobe. All rights reserved.
//

import UIKit

class GameOverParentViewController: UIViewController {
    
    @IBOutlet weak var GameOverView: UIView!
    
    var upsidedown = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(netHex: 0x2c3e50)
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        animateInfinitelyWithDelay(5, duration: 1)
    }
    
    func animateInfinitelyWithDelay(delay : NSTimeInterval, duration : NSTimeInterval) {
        
        UIView.animateWithDuration(duration, delay: delay, options:[ .CurveEaseInOut, .AllowUserInteraction],
            animations: { () -> Void in
                
                if(self.upsidedown == false){
                    self.GameOverView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                    self.upsidedown = true
                }else{
                    self.GameOverView.transform = CGAffineTransformMakeRotation(CGFloat(0))
                    self.upsidedown = false
                }
                
            } ,completion: { _ in
                
                self.animateInfinitelyWithDelay(delay, duration: duration)
                
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
