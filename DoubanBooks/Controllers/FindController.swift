//
//  FindController.swift
//  DoubanBooks
//
//  Created by 2017yd2 on 2019/10/25.
//  Copyright © 2019 2017yd. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
private let reuseIdentifier = "bookItemCell"

class FindController: UICollectionViewController,EmptyViewDelegate ,UISearchBarDelegate  {
    var categorie = VMCategoty()
    var books:[VMBook]?
    
    var isEmpty: Bool{
        get {
            if let data = books {
                return data.count == 0
            }
            return true
        }
    }
    
    var imgEmpty: UIImageView?
    
    func createEmptyView() -> UIView? {
        if let empty = imgEmpty {
            return empty
        }
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let barHeight = navigationController?.navigationBar.frame.height
        let img = UIImageView(frame: CGRect(x: (w-139)/2, y: (h-128)/2 - (barHeight ?? 0), width: 139, height: 128))
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "no_data")
        imgEmpty = img
        return img
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            //  books = try factory.getBooksOf(category: category!.id)
            books = nil
        } catch DataError.readCollectionError(let info) {
            books = [VMBook]()
            UIAlertController.showALertAndDismiss(info, in: self, completion: {
                self.navigationController?.popViewController(animated: true)
            })
        } catch {
            books = [VMBook]()
            UIAlertController.showALertAndDismiss(error.localizedDescription, in: self, completion: {
                self.navigationController?.popViewController(animated: true)
            })
        }
           books?.append(VMBook())
           collectionView.setEmtpyCollectionViewDelegate(target: self)
     
    //   self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind:
        String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "searchHeader", for: indexPath)
        as! SearchHeader
        header.searchHeader.delegate = self
        return header
    }
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         if let kw = searchBar.text {
                     tabBarController!.viewControllers![1].tabBarItem.badgeValue = kw
                 }
    }
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return books?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
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
