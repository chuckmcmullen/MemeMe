//
//  ViewController.swift
//  MemeMe
//
//  Created by Chuck McMullen on 4/2/15.
//  Copyright (c) 2015 Chuck McMullen. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UITextFieldDelegate {
    @IBOutlet weak var memeMeImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var shareMemeButton: UIBarButtonItem!
    var modifiedMemeImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let memeTextAttributes = [
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -1,
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            
        ]
        
        self.topTextfield.defaultTextAttributes = memeTextAttributes
        self.bottomTextfield.defaultTextAttributes = memeTextAttributes
        
        self.topTextfield.text = "TOP"
        self.bottomTextfield.text = "BOTTOM"
        self.topTextfield.textAlignment = NSTextAlignment.Center
        self.bottomTextfield.textAlignment = NSTextAlignment.Center
        
        
        self.bottomTextfield.delegate = self
        self.topTextfield.delegate = self
        
        self.view.bringSubviewToFront(self.topTextfield)
        self.view.bringSubviewToFront(self.bottomTextfield)
        self.view.bringSubviewToFront(self.bottomToolBar)
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotifications()
        if(self.memeMeImage.image == nil)
        {
            self.shareMemeButton.enabled = false
        }
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    @IBAction func cancelButton(sendor: UIBarButtonItem)
    {
        self.presentSentMeme()
    }
    @IBAction func shareMemeButton(sendor: UIBarButtonItem)
    {
        
        self.modifiedMemeImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [self.modifiedMemeImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed{
                self.saveMeme()
                self.dismissViewControllerAnimated(true, completion: nil)
                self.presentSentMeme()
            }
        }
        self.presentViewController(activityController, animated: true, completion: nil)
    }
    func saveMeme()
    {
        var meme = Meme(topString: self.topTextfield.text, bottomString: self.bottomTextfield.text, orgImage: self.memeMeImage.image!, memeImage: self.modifiedMemeImage)
        (UIApplication.sharedApplication().delegate as AppDelegate).memes.append(meme)
    }
    @IBAction func pickImageButton(sendor: UIBarButtonItem)
    {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        self.presentViewController(pickerController,animated:true, completion: nil)
    }
    @IBAction func pickImageCameraButton (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.memeMeImage.image = image
            self.shareMemeButton.enabled = true;
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        if(textField.text == "TOP" || textField.text == "BOTTOM")
        {
            textField.text = ""
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    func keyboardWillShow(notification: NSNotification)
    {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    func keyboardWillHide(notification: NSNotification)
    {
        self.view.frame.origin.y = 0.0
    }
    
    func unsubscribeFromKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        if self.bottomTextfield.editing
        {
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue
            return keyboardSize.CGRectValue().height
        }else
        {
            return 0
        }
    }
    func generateMemedImage() -> UIImage
    {
        
        
        self.bottomToolBar.hidden = true
        self.navigationController?.navigationBar.hidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.bottomToolBar.hidden = false
        self.navigationController?.navigationBar.hidden = false
        return memedImage
    }
    func frameForImage(image: UIImage,imageView: UIImageView) -> CGRect
    {
        let imageRatio : CGFloat =  image.size.width / image.size.height
        let viewRatio : CGFloat = imageView.frame.size.width / imageView.frame.size.height
    
        if(imageRatio < viewRatio)
        {
            let scale : CGFloat = imageView.frame.size.height / image.size.height
            let width : CGFloat = scale * image.size.width
            let topLeftX : CGFloat = (imageView.frame.size.width - width) * 0.5
            return CGRectMake(topLeftX, 0, width, imageView.frame.size.height)
        }
        else
        {
            let  scale : CGFloat = imageView.frame.size.width / image.size.width;
            let  height : CGFloat = scale * image.size.height;
            let  topLeftY : CGFloat = (imageView.frame.size.height - height) * 0.5;
            return CGRectMake(0, topLeftY, imageView.frame.size.width, height);
        }
    }
    
    
    
    
    
    
    
    
    
    func presentSentMeme()
    {
//        var rvController: UITabBarController
//        rvController = self.storyboard?.instantiateViewControllerWithIdentifier("SentMemeTab") as UITabBarController
//        self.navigationController?.presentViewController(rvController, animated: true, completion: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

