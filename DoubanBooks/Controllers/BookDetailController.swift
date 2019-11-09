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


class BookDetailController: UIViewController,PickerItemSelectedDelegate,UITableViewDataSource,UITableViewDelegate{
 
    
   
    
  
    let categories: [VMCategoty] = {
                  return (try? CategotyFactory.getInstance(UIApplication.shared.delegate as! AppDelegate).getAllCategories()) ?? [VMCategoty]()
     }()

    @IBOutlet weak var imgcollect: UIBarButtonItem!
    
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
   var category:VMCategoty?
     var readonly = false
    
    let factory = BookFactory.getInstance(UIApplication.shared.delegate as! AppDelegate)
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        
        lblauthor.text = book?.author
        lblpublishing.text = book?.publisher
        lblprice.text = book?.price
        lblsummary.text = book?.summary
        aboutTheauthor.text = book?.authorIntro

        Alamofire.request(book!.image!).responseImage{ response in
                  if let imag = response.result.value {
                    self.lblimg.image = imag
                  }
        }
        
        var icStar = "ic_star_off"
        if (try? factory.isBookExists(book: book!)) ?? false{
            icStar = "ic_star_on"
        }
        imgcollect.image =  UIImage(named: icStar)
        imgcollect.isEnabled = !readonly
       
    }
  
    
    
    ///点击完成退出
    @IBAction func quit(_ sender: Any) {
       dismiss(animated: true , completion: nil)
    }
      ///点击收藏
    @IBAction func collect(_ sender: Any) {
        if  UIImage(named: "ic_star_off") == imgcollect.image{
//          let picker = ActionCollectionPicker<VMCategoty>(title: "选择图书类别", items: categories, handler: self, mother: self.view)
//                        picker.show()
            
            let Picker = ActionTabePicker(title: "选择图书类别", count: categories.count, dataSoure: self, delegate: self).show(superView: self.view)
            
        }else{
            imgcollect.image =  UIImage(named: "ic_star_off")
            let (success, error) =  try! factory.removeBook(book: book!)
            UIAlertController.showAlert("取消收藏！！", in: self)
        }
        
          
    }
    
    func itemSelected(index: Int) {
         let category1 = categories[index]
         book?.categoryId = category1.id
         let (success, error) =   factory.addBook(book: book!)
         UIAlertController.showAlert("点击了收藏！！", in: self)
         imgcollect.image =  UIImage(named: "ic_star_on")
      }
    
     private var tablePicker: ActionTabePicker?
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                let category = categories[indexPath.row]
                cell.textLabel?.text = category.name
                return cell
     }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 60
    }
    
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           itemSelected(index: indexPath.row)
           if tablePicker != nil {
               tablePicker?.cancel()
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
