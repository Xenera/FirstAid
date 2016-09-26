//
//  MassajViewController.swift
//  FirstAid
//
//  Created by Ернур Сункарбек on 16.08.16.
//  Copyright © 2016 Ернур Сункарбек. All rights reserved.
//

import UIKit

class MassajViewController: UIViewController {

   
    
//    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        scrollView.contentSize.height = 600
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
               
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
