//
//  CategorisesController.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/18.
//  Copyright © 2019年 2017yd. All rights reserved.
//
import UIKit

private let reuseIdentifier = "categoryCell"
private let BooksSague = "BooksSague"
 
class CategorisesController: UICollectionViewController ,EmptyViewDelegate{
   var categories: [VMCategoty]?
    
     var isEmpty: Bool{
         get {
             if let data = categories {
                 return data.count == 0
             }
             return true
         }
     }
    
     var imgEmpty:UIImageView?
    
     func createEmptyView() -> UIView? {
         if let empty = imgEmpty {
         return empty
     }
         let w = UIScreen.main.bounds.width
         let h = UIScreen.main.bounds.height
         let barHeight = navigationController?.navigationBar.frame.height
         let img = UIImageView(frame: CGRect(x: (w-139)/2, y: (h-128)/2-(barHeight ?? 0), width: 139, height: 128))
         img.contentMode = .scaleToFill
         img.image = UIImage(named: "no_data")
         self.imgEmpty = img
         return img
     }
    
   
    
    let addCategorySegu = "addCategorySegu"
    let factory = CategotyFactory.getInstance(UIApplication.shared.delegate as! AppDelegate)
    override func viewDidLoad() {
        
        super.viewDidLoad()
        do{
          categories = try factory.getAllCategories()
        }catch DataError.readCollectionError(let info){
            categories = [VMCategoty]()
            UIAlertController.showALertAndDismiss(info, in: self)
        }catch{
            categories = [VMCategoty]()
        }
        /// selector：要做什么
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: notiCategory), object: nil)
        
        
        let lpTap = UILongPressGestureRecognizer(target: self ,action: #selector(longPressSwitch(_:)))
        collectionView.addGestureRecognizer(lpTap)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToStopShakingOrBooksSegue(_:)))
        collectionView.addGestureRecognizer(tap)

        collectionView.setEmtpyCollectionViewDelegate(target: self)
    }
    /// 接受数据
    @objc func refresh(noti: Notification){
        //刷新
        ///使用键来获取值
        let name = noti.userInfo!["name"] as! String
        do{
            categories?.removeAll()
            categories?.append(contentsOf: try factory.getAllCategories())
            UIAlertController.showALertAndDismiss("\(name)添加成功！", in: self, completion: {
                self.navigationController?.popViewController(animated: true)
                self.collectionView.reloadData()
                })

        }catch DataError.readCollectionError(let info){
            categories = [VMCategoty]()
            UIAlertController.showALertAndDismiss(info, in: self)
        }catch{
            categories = [VMCategoty]()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var longPressed = false {
        didSet {
            if oldValue != longPressed{
                collectionView.reloadData()
            }
        }
    }
    var point:CGPoint?
    
    @objc func longPressSwitch(_ IpTap: UILongPressGestureRecognizer ){
        // 如果长按（在item上）就进入删除模式
        point = IpTap.location(in: collectionView)
        if let p = point , let _ = collectionView.indexPathForItem(at: p){
            longPressed = true
        }
      
    }

    @objc func tapToStopShakingOrBooksSegue(_ tap: UITapGestureRecognizer){
        // 1 如果删除模式 停止删除模式   2 如果非删除模式 ，点击itme的时候就执行books场景过度
        point = tap.location(in: collectionView)
        if let  p = point, collectionView.indexPathForItem(at: p) == nil{
            longPressed = false
        }
        if let p = point , let index = collectionView.indexPathForItem(at: p){
            if !longPressed {
                  performSegue(withIdentifier: BooksSague, sender: index.item)
            }
        }
    }
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categories!.count
    }
  //  var path:String
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCell
        let category = categories![indexPath.item]
        cell.lblName.text = category.name!
        cell.lblCount.text = String(factory.getBooksCountOfCategory(category: category.id)!)
        // TODO: 图库文件保存到沙盒，取文件地址
        cell.imgCover.image = UIImage(contentsOfFile: NSHomeDirectory().appending(imgDir).appending(category.image!))

        cell.lblEditTime.text = CategotyFactory.getEditTimeFromPlist(id: category.id)
        
        // TODO : 删除模式下抖动，非删除模式下取消抖动
        if longPressed {
            let pos  = collectionView.indexPathForItem(at: point!)?.item
            if pos == indexPath.item {
                //删除模式下抖动
              cell.btnDelete.isHidden = false
             //   cell.btnDelete.addTarget(self, action: #selector(delete(_:)), for: .touchUpInside)
             cell.btnDelete.addTarget(self, action: #selector(removeCategory), for: .touchUpInside)
             let anim = CABasicAnimation(keyPath: "transform.rotation")
                anim.toValue = -Double.pi / 50
                anim.fromValue = Double.pi / 50
                anim.duration = 0.15
                anim.repeatCount = MAXFLOAT
                anim.autoreverses = true
                cell.layer.add(anim, forKey: "SpringboardShake")
                
            }
           
        }else {
            //非删除模式取消抖动
              cell.btnDelete.isHidden = true // TODO:随普通模式和删除模式切换可见
              cell.layer.removeAllAnimations()
        }
      
        return cell
    }
    
    //删除
    @objc func removeCategory (){
        UIAlertController.showConfirm("确认删除吗？？", in: self, confirm: { _ in
            let index = self.collectionView.indexPathForItem(at: self.point!)
            let category = self.categories![index!.item]
            let (success, info) = try! self.factory.removeCategory(category:category)
            let fileManager = FileManager.default
            do{
            let path = NSHomeDirectory().appending(imgDir).appending(category.image!)
            try fileManager.removeItem(atPath: path)
            } catch {
            UIAlertController.showAlert("删除失败", in: self)
            }
            self.longPressed = false
           do{
            self.categories = try self.factory.getAllCategories()
                }catch DataError.readCollectionError(let info){
                    self.categories = [VMCategoty]()
                    UIAlertController.showALertAndDismiss(info, in: self)
                }catch{
                    self.categories = [VMCategoty]()
                }
              if !success {
                            UIAlertController.showALertAndDismiss(info!, in: self)
                            return
             }
        })
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == BooksSague {
            let destination = segue.destination as! BooksController
            if sender is Int {
                let me = categories?[sender as! Int]
                destination.category = me
            }
        }
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
