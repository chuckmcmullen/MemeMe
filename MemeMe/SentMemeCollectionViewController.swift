//
//  SentMemeCollectionViewController.swift
//  MemeMe
//
//  Created by Chuck McMullen on 4/7/15.
//  Copyright (c) 2015 Chuck McMullen. All rights reserved.
//

import UIKit

class SentMemeCollectionViewController: UICollectionViewController{
    var MyMeme: [Meme]!
    @IBOutlet weak var backToMeme: UIBarButtonItem!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        var barBack = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "editButton")
        self.navigationItem.leftBarButtonItem = barBack
    }
    func editButton()
    {
        let tabBarItemTable = self.tabBarController?.tabBar.items?[0] as? UITabBarItem
        let tabBarItemCollection = self.tabBarController?.tabBar.items?[1] as? UITabBarItem
        if(self.navigationItem.leftBarButtonItem?.title == "Edit")
        {
            self.navigationItem.leftBarButtonItem?.title = "Done"
            self.backToMeme.enabled = false
            tabBarItemTable?.enabled = false
            tabBarItemCollection?.enabled = false
        }
        else
        {
            self.navigationItem.leftBarButtonItem?.title = "Edit"
            self.backToMeme.enabled = true
            tabBarItemTable?.enabled = true
            tabBarItemCollection?.enabled = true
        }
    }
    override func viewWillAppear(animated: Bool) {
        MyMeme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        self.collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MyMeme.count
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        cell.backgroundColor = UIColor.blackColor()
        cell.memeImage.image = MyMeme[indexPath.row].memeImage
        return cell
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if(self.navigationItem.leftBarButtonItem?.title == "Edit")
        {
            var rvController: MemeViewController
            rvController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
            
            rvController.memeImage = MyMeme[indexPath.row].memeImage
            self.navigationController?.pushViewController(rvController, animated: true)
        }
        else
        {
            //**********
            //alertView source code example stackOverflow
            //http://stackoverflow.com/questions/25511945/swift-alert-view-ios8-with-ok-and-cancel-button-which-button-tapped
            //**********
            let alertView = UIAlertController(title: "MeMeme", message: "Remove this Meme?", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (alertAction) -> Void in
                [self.MyMeme .removeAtIndex(indexPath.row)]
                (UIApplication.sharedApplication().delegate as! AppDelegate).memes = self.MyMeme
                self.collectionView?.deleteItemsAtIndexPaths([indexPath])
            }))
            alertView.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            presentViewController(alertView, animated: true, completion: nil)
            
            
            
        }
    }
     @IBAction func backToMemeEditor()
    {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorView") as! UINavigationController
        self.navigationController?.presentViewController(controller, animated: true, completion: nil)

    }
}