//
//  Meme.swift
//  MemeMe
//
//  Created by Chuck McMullen on 4/3/15.
//  Copyright (c) 2015 Chuck McMullen. All rights reserved.
//

import Foundation
import UIKit

class Meme: NSObject {
    var topString:String!
    var bottomString:String!
    var orgImage: UIImage!
    var memeImage: UIImage!
    init(topString:String, bottomString:String,orgImage: UIImage,memeImage: UIImage){
        self.topString = topString
        self.bottomString = bottomString
        self.orgImage = orgImage
        self.memeImage = memeImage
    }
}