//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Chuck McMullen on 4/7/15.
//  Copyright (c) 2015 Chuck McMullen. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController {
    var memeImage: UIImage!
    @IBOutlet var memeMeImage: UIImageView!
        override func viewDidLoad() {
        super.viewDidLoad()

        self.memeMeImage.image = self.memeImage
        
    }
    override func viewWillAppear(animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 


}
