//
//  ViewController.swift
//  DoubanBooks
//
//  Created by 2017yd2 on 2019/11/12.
//  Copyright © 2019 2017yd. All rights reserved.
//

import UIKit

class ChartsPageController: UIPageViewController ,UIPageViewControllerDataSource{
    var container:PageContainerDelegate? //容器Controller
    
    private (set) lazy var controllers:[UIViewController] = {
        return [getController(identifier: "chart1"),getController(identifier: "chart2"),getController(identifier: "chart3")]
    }()
    
    private func getController(identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.viewDidLoad()
        self.dataSource = self
        if let chatrlController = controllers.first {  //设置第一个图表Controller
            setViewControllers([chatrlController], direction: .forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    //滑动切换页面时，返回当前正显示页面的前一页的vc对象
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

            guard let index = controllers.firstIndex(of: viewController) else {return nil}
            container?.switchTabButton(to: index)
            let prevIndex = index - 1
            guard prevIndex >= 0 else {
                return controllers.last
            }
            guard prevIndex < controllers.count else {
                return nil
            }
            return controllers[prevIndex]
        
      }
      
      func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController) else { return nil}
        container?.switchTabButton(to: index)
        let nextIndex = index + 1
        guard nextIndex != controllers.count else {
            return controllers.first
        }
        guard nextIndex < controllers.count else {
            return nil
        }
        return controllers[nextIndex]
      }
    func setPage(to index:Int){
        if index >= 0 && index < controllers.count{
            setViewControllers([controllers[index]], direction: .forward, animated: true, completion: nil)
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
