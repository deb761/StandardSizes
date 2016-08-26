//
//  ViewController.swift
//  StandardSizes
//
//  Created by Deborah Engelmeyer on 8/26/16.
//  Copyright © 2016 The Inquisitive Introvert. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var sizes:Sizes!
    override func viewDidLoad() {
        super.viewDidLoad()

        sizes = Sizes()
        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

