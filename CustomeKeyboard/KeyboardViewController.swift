//
//  KeyboardViewController.swift
//  CustomeKeyboard
//
//  Created by Shubh Chopra on 8/18/17.
//  Copyright © 2017 Shubh Chopra. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    var NumberPadView: UIView!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInterface()
    }
    func loadInterface() {
        // load the nib file
        var NumberPadNil = UINib(nibName: "NumberPad", bundle: nil)
        // instantiate the view
        NumberPadView = NumberPadNil.instantiate(withOwner: self, options: nil)[0] as! UIView
        // add the interface to the main view
        view.addSubview(NumberPadView)
        // copy the background color
        view.backgroundColor = NumberPadView.backgroundColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
    }

}
