//
//  AlertExtenslons.swift
//  Calculators
//
//  Created by 2017yd on 2019/9/26.
//  Copyright © 2019年 2017yd. All rights reserved.
//

import UIKit
extension UIAlertController{
    static func showAlert (_ message:String, in controller:UIViewController ){
        // 显示一个警告框
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
    static func showConfirm(_ message:String,in controller:UIViewController, confirm:((UIAlertAction) -> Void)?){
        // 显示一个对话框，确定按钮e可以执行confirm方法
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        //按钮
        let actionNo = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "确定", style: .default, handler: confirm)
        alert.addAction(action)
        alert.addAction(actionNo)
        controller.present(alert, animated: true, completion: nil)
    }
    static func showALertAndDismiss(_ message:String, in controller:UIViewController){
        // 显示一个警告框，几秒后自动关闭
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
       controller.present(alert, animated: true, completion: nil)
       DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {() ->Void in
        controller.presentedViewController?.dismiss(animated: true, completion: nil)
       })
    }
    static func showALertAndDismiss(_ message:String, in controller:UIViewController, completion:(() -> Void)? = nil){
        // 显示一个警告框，几秒后自动关闭,具有dismiss的回调方法
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        controller.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {() ->Void in
            controller.presentedViewController?.dismiss(animated: true, completion: completion)
             })
    }
}
