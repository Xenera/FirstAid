//
//  DyhanieViewController.swift
//  FirstAid
//
//  Created by Ернур Сункарбек on 28.08.16.
//  Copyright © 2016 Ернур Сункарбек. All rights reserved.
//

import UIKit

class DyhanieViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var timer : NSTimer!
    var updateCounter: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCounter = 0
        timer = NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: #selector(DyhanieViewController.updateTimer), userInfo: nil, repeats: true)
        
    }
    
    internal func updateTimer() {
        if updateCounter <= 2 {
            pageControl.currentPage = updateCounter
            imgView.image = UIImage(named: String(updateCounter) + ".png")
            updateCounter = updateCounter + 1
        } else {
            updateCounter = 0
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

   
}
