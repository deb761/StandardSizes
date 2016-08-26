//
//  ViewController.swift
//  StandardSizes
//
//  Created by Deborah Engelmeyer on 8/26/16.
//  Copyright © 2016 The Inquisitive Introvert. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var nameField: NSTextField!
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


    @IBAction func saveData(sender: AnyObject) {
        // get the values from the name and data fields
        let docName = nameField.stringValue
        //let docDataTextView = dataScrollView.contentView.documentView as! NSTextView
        //let docData = docDataTextView.string!
        
        // create a Save Panel to choose a file path to save to
        let dlg = NSSavePanel()
        // use the name fields value to suggest a name for the file
        dlg.nameFieldStringValue = docName
        // run the Save Panel and handle an OK selection
        if (dlg.runModal() == NSFileHandlingPanelOKButton) {
            // get the URL of the selected file path
            let saveUrl = dlg.URL
            let fileUrlWithExt = saveUrl?.URLByAppendingPathExtension("csv")
            sizes.saveAreas(fileUrlWithExt!)
        }
    }
}

