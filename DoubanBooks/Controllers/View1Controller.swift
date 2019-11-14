//
//  View1Controller.swift
//  DoubanBooks
//
//  Created by 2017yd2 on 2019/11/12.
//  Copyright © 2019 2017yd. All rights reserved.
//

import UIKit
import Charts
import AAInfographics
class View1Controller: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mzznotice()
        NotificationCenter.default.addObserver(self, selector: #selector(mzznotice), name: NSNotification.Name(rawValue: MzznotiCategory), object: nil)
        
    }
    @objc func mzznotice(){
        let chartWidth = UIScreen.main.bounds.width - 20
        let chartHeight = UIScreen.main.bounds.height - 200
        if view.subviews.count > 0 {
            let old = view.subviews[0]
            old.removeFromSuperview()
        }
        let chart = BarChartView(frame: CGRect(x: 10, y: 10, width: chartWidth, height: chartHeight))
        self.view.addSubview(chart)
        let categories = try? CategotyFactory.getInstance(UIApplication.shared.delegate as! AppDelegate).getAllCategories()
        let bookFactory = CategotyFactory.getInstance(UIApplication.shared.delegate as! AppDelegate)
        var x = 0
        var xLabels = [String]()
        if let data = categories {
            var entries = [BarChartDataEntry]()
            for category in data{
                let entry = BarChartDataEntry(x: Double(x), y: Double(bookFactory.getBooksCountOfCategory(category: category.id) ?? 0))
                entries.append(entry)
                xLabels.append(category.name!)
                x += 1
            }
            let dataSet = BarChartDataSet(entries: entries,label: "类别藏书柱状图")
            dataSet.colors = [.cyan,.green,.purple,.magenta,.orange,.blue,.red]
            let chartData = BarChartData(dataSets: [dataSet])
            chart.data = chartData
            chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: xLabels)
            chart.leftAxis.axisMinimum = 0
            chart.rightAxis.axisMinimum = 0
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


