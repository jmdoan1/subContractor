//
//  LoginVC.swift
//  SubContractor
//
//  Created by Justin Doan on 6/26/17.
//  Copyright © 2017 Justin Doan. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class LoginVC: UIViewController {

    @IBOutlet var tfUsername: UITextField!
    @IBOutlet var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for subView in view.subviews {
            if let btn = subView as? UIButton {
                btn.layer.cornerRadius = btn.frame.height / 2
            }
            
            if let tf = subView as? UITextField {
                tf.layer.cornerRadius = tf.frame.height / 2
                tf.layer.borderWidth = 2.5
                tf.layer.borderColor = UIColor.red.cgColor
            }
        }

    }
    
    @IBAction func login(_ sender: Any) {
        guard let username = tfUsername.text, let password = tfPassword.text else {
            
            let banner = NotificationBanner(title: "Oops :(", subtitle: "Please enter your username and password", style: .danger)
            banner.show()
            
            return
        }
        
        if username != "", password != "" {
            
            var request = URLRequest(url: URL(string: URL_LOGIN)!)
            request.httpMethod = "POST"
            let postString = "username=\(username)&password=\(password)"
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil && data != nil else {
                    // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {
                    // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    let responseString = String(data: data!, encoding: String.Encoding.utf8)
                    print("Response: " + responseString!)
                    let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    let dict = json as! [String:Any]
                    let message = dict["message"] as! String
                    print("Message: \(message)")
                    
                    let banner = NotificationBanner(title: "Oops :(", subtitle: message, style: .danger)
                    banner.show()
                    
                } else {
                    let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    print(json)
                    
                    let dict = json as! [String:Any]
                    
                    if dict["username"] as! String == username {
                        DispatchQueue.main.async {
                            print("Success! - " + String(dict["username"] as! String))
                            self.performSegue(withIdentifier: "loggedIn", sender: self)
                            prefs.setValue(username, forKey: PREFS_MY_USERNAME)
                            prefs.setValue(password, forKey: PREFS_MY_PASSWORD)
                            
                            let banner = NotificationBanner(title: "Success :D", subtitle: "You are logged in", style: .success)
                            banner.show()
                        }
                    }
                }
            }
            task.resume()
        } else {
            
            let banner = NotificationBanner(title: "Oops :(", subtitle: "Please enter your username and password", style: .danger)
            banner.show()
        }
    }
    
    @IBAction func register(_ sender: Any) {
        guard let username = tfUsername.text, let password = tfPassword.text else {
            
            let banner = NotificationBanner(title: "Oops :(", subtitle: "Please enter your username and password", style: .danger)
            banner.show()
            
            return
        }
        
        if username != "", password != "" {
            
            var request = URLRequest(url: URL(string: URL_REGISTER)!)
            request.httpMethod = "POST"
            let postString = "username=\(username)&password=\(password)"
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil && data != nil else {
                    // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {
                    // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    let responseString = String(data: data!, encoding: String.Encoding.utf8)
                    print("Response: " + responseString!)
                    let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    let dict = json as! [String:Any]
                    let message = dict["message"] as! String
                    print("Message: \(message)")
                    
                    let banner = NotificationBanner(title: "Oops :(", subtitle: message, style: .danger)
                    banner.show()
                } else {
                    let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    let dict = json as! [String:Any]
                    
                    print(dict)
                    
                    if dict["username"] as! String == username {
                        DispatchQueue.main.async {
                            print("Success! - " + String(dict["username"] as! String))
                            self.performSegue(withIdentifier: "loggedIn", sender: self)
                            prefs.setValue(username, forKey: PREFS_MY_USERNAME)
                            prefs.setValue(password, forKey: PREFS_MY_PASSWORD)
                            
                            let banner = NotificationBanner(title: "Success :D", subtitle: "You are registered", style: .success)
                            banner.show()
                        }
                    }
                }
            }
            task.resume()
        } else {
            
            let banner = NotificationBanner(title: "Oops :(", subtitle: "Please enter your username and password", style: .danger)
            banner.show()
        }
    }

}
