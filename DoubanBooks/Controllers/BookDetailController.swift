//
//  BookDetailController.swift
//  DoubanBooks
//
//  Created by 2017yd2 on 2019/11/4.
//  Copyright © 2019 2017yd. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class BookDetailController: UIViewController {

    
    @IBOutlet weak var lblimg: UIImageView!
    ///作者
    @IBOutlet weak var lblauthor: UILabel!
    ///出版社
    @IBOutlet weak var lblpublishing: UILabel!
    
    ///出版日期
    @IBOutlet weak var lblpublicationdate: UILabel!
    ///价格
    @IBOutlet weak var lblprice: UILabel!
    
    ///总结
    @IBOutlet weak var lblsummary: UITextView!
    
    ///作者简介
    @IBOutlet weak var aboutTheauthor: UITextView!
    
    
   var book:VMBook?
    let factory = BookFactory.getInstance(UIApplication.shared.delegate as! AppDelegate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblauthor.text = book?.author
        lblpublishing.text = book?.publisher
        lblprice.text = book?.price
        lblsummary.text = book?.summary
        aboutTheauthor.text = book?.authorIntro
        
        factory.addBook(cattegory: book!)
        Alamofire.request(book!.image!).responseImage{ response in
                  if let imag = response.result.value {
                    self.lblimg.image = imag
                  }
              }
        // Do any additional setup after loading the view.
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
