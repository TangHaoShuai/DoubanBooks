//
//  AddCategoryController.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/19.
//  Copyright © 2019年 2017yd. All rights reserved.
//

import UIKit
let imgDir = "/Documents/"
let notiCategory = "AddCategoryController.notiCategory"
class AddCategoryController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var textName: UITextField!
    
    var seletedImage:UIImage?
    let factory = CategotyFactory.getInstance(UIApplication.shared.delegate as! AppDelegate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(selectPicture) )
                imgCover.addGestureRecognizer(recognizer)
                imgCover.isUserInteractionEnabled = true

    }
    
    @objc func selectPicture() {
        let imgController = UIImagePickerController()
        imgController.sourceType = .photoLibrary
        imgController.delegate = self
        present(imgController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imga = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imgCover.image = imga
        seletedImage = imga
        dismiss(animated: true, completion: nil)
    }
    
    func saveImage(imag: UIImage, fileName: String){
        if  let imagData = imag.jpegData(compressionQuality: 1) as NSData? {
            let path = NSHomeDirectory().appending(imgDir).appending(fileName)
            imagData.write(toFile: path, atomically: true)
        }
    }
    
    @IBAction func saveCategory() {
        let name = textName.text
        //TODO: 1.检查数据完整性
        if name == nil || name!.count == 0 {
            UIAlertController.showALertAndDismiss("类别名称不能为空", in: self)
        }
        
        let category = VMCategoty()
        category.name = name
        category.image = category.id.uuidString + ".jpg"
        
        
        let (success, info) = factory.addCategory(cattegory: category)
        if !success {
            UIAlertController.showALertAndDismiss(info!, in: self)
            return
        }
        saveImage(imag: seletedImage!, fileName: category.image!)
        CategotyFactory.updateEditTime(id: category.id)
        /// NotificationCenter：通知中心,default: 整个应用默认的通知中心
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notiCategory), object: nil, userInfo: ["name":category.name!])
    }
    
    
//    @IBAction func pickFromPhotoLibrary(_ sender: Any) {
//        let imgController = UIImagePickerController()
//        imgController.sourceType = .photoLibrary
//        imgController.delegate = self
//        present(imgController, animated: true, completion: nil)
//    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
