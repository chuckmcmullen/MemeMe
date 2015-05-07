//
//  SentMemeTableViewController.swift
//  MemeMe
//
//  Created by Chuck McMullen on 4/6/15.
//  Copyright (c) 2015 Chuck McMullen. All rights reserved.
//

import UIKit

class SentMemeTableViewController: UITableViewController{
    var MyMeme :[Meme]!
    @IBOutlet weak var backToMeme: UIBarButtonItem!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
    }
    override func viewWillAppear(animated: Bool) {
        MyMeme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        self.tableView.reloadData()
    }
    override func viewDidAppear(animated: Bool) {
        if (MyMeme.count == 0) {
            openMemeEditor()
        }
    }
    func openMemeEditor()
    {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorView") as! UINavigationController
        self.navigationController?.presentViewController(controller, animated: true, completion: nil)
    }

    
    @IBAction func backToMemeEditor()
    {
        openMemeEditor()

    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let tabBarItemTable = self.tabBarController?.tabBar.items?[0] as? UITabBarItem
        let tabBarItemCollection = self.tabBarController?.tabBar.items?[1] as? UITabBarItem
        if(self.navigationItem.leftBarButtonItem?.title == "Edit")
        {
            self.backToMeme.enabled = true
            tabBarItemTable?.enabled = true
            tabBarItemCollection?.enabled = true
        }
        else
        {
            self.backToMeme.enabled = false
            tabBarItemTable?.enabled = false
            tabBarItemCollection?.enabled = false
        }
        return true
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if(editingStyle == UITableViewCellEditingStyle.Delete)
        {
            [MyMeme .removeAtIndex(indexPath.row)]
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes = MyMeme
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyMeme.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell", forIndexPath: indexPath) as! MemeTableViewCell
        cell.memeTextField.text = MyMeme[indexPath.row].topString + " " + MyMeme[indexPath.row].bottomString
        cell.memeImage.image = MyMeme[indexPath.row].memeImage
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var rvController: MemeViewController
        rvController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
        rvController.memeImage = MyMeme[indexPath.row].memeImage
        self.navigationController?.pushViewController(rvController, animated: true)
    }
   
}