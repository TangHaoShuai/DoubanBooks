//
//  View3Controller.swift
//  DoubanBooks
//
//  Created by 2017yd2 on 2019/11/12.
//  Copyright © 2019 2017yd. All rights reserved.
//

import UIKit
import AAInfographics
class View3Controller: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mzznotice()
        NotificationCenter.default.addObserver(self, selector: #selector(mzznotice), name: NSNotification.Name(rawValue: notiUpdateKeywords), object: nil)
        
        
    }
    @objc func mzznotice(){
        let chartWidth = UIScreen.main.bounds.width
        let chartHeight = UIScreen.main.bounds.height - 170
        if view.subviews.count > 0 {
            let old = view.subviews[0]
            old.removeFromSuperview()
        }
        let chart = AAChartView()
        chart.frame = CGRect(x: 0, y: 0, width: chartWidth, height: chartHeight)
        view.addSubview(chart)
        let keywords = UserCookies.getTopKeywords(top: 10)
        let categories = keywords.map({$0.0})
        let frequencies = keywords.map({$0.1})
        let chartModel = AAChartModel()
            .chartType(.bar)
            .title("前十大关键词")
            .subtitle("截止\(Date.dateAsString(date: Date(), pattern: "yyyy-MM-dd"))关键词排名")
            .titleFontColor("#FF0000")
            .dataLabelsEnabled(false)
            .categories(categories)
            .series([
                AASeriesElement()
                    .name("使用关键字频率")
                    .data(frequencies)
            ])
        chart.aa_drawChartWithChartModel(chartModel)
    }
    
    
}

