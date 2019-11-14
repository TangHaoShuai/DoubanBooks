//
//  AnalyzeController.swift
//  DoubanBooks
//
//  Created by 2017yd2 on 2019/11/12.
//  Copyright © 2019 2017yd. All rights reserved.
//

import UIKit

class AnalyzeController: UIViewController,PageContainerDelegate {
   
    

    @IBOutlet weak var vlndictor1: UIView!
    
    @IBOutlet weak var vlndictor2: UIView!
    
    @IBOutlet weak var vlndictor3: UIView!
    
    var indicators:[UIView]!
    
    var controller:ChartsPageController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller = (children.first as! ChartsPageController)
        controller.container = self
        indicators = [vlndictor1,vlndictor2,vlndictor3]
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapToChangeChart(_ sender: UIButton) {
        let index = sender.tag
        controller.setPage(to: index)
        switchTabButton(to: index)
    }
    
    func switchTabButton(to index: Int) {
        for indicator in indicators!{
            if indicators.firstIndex(of: indicator) == index {
                indicator.backgroundColor = UIColor.blue
            }else {
                indicator.backgroundColor = UIColor.lightGray
            }
        }
       }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



