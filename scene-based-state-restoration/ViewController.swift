//
//  ViewController.swift
//  scene-based-state-restoration
//
//  Created by Kamal Bogahagedara on 2022-10-26.
//

import UIKit

class ViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var txtViewData: UITextView!
    @IBOutlet weak var txtData: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtViewData.delegate = self;

        //Looks for single or multiple taps.
         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
        
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {

        var currentUserActivity = view.window?.windowScene?.userActivity
        if currentUserActivity == nil {
            currentUserActivity = NSUserActivity(activityType: "ViewController")
        }
        
        // Saving state data.
        currentUserActivity?.addUserInfoEntries(from: ["text": txtViewData.text!])
    
        view.window?.windowScene?.userActivity = currentUserActivity
       }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let activityUserInfo = view.window?.windowScene?.userActivity?.userInfo {

            if activityUserInfo["text"] != nil {
                
                // Restore the preserved data for the textfield.
                txtViewData.text = activityUserInfo["text"] as? String
  
            }
        }
        
    }

}

