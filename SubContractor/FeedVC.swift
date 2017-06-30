//
//  FeedVC.swift
//  SubContractor
//
//  Created by Justin Doan on 6/27/17.
//  Copyright © 2017 Justin Doan. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var openings: [Opening] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getOpenings()
    }

    func getOpenings() {
        var request = URLRequest(url: URL(string: URL_OPENINGS)!)
        request.httpMethod = "GET"
        //let postString = "username=\(username)&password=\(password)"
        //request.httpBody = postString.data(using: .utf8)
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
                
                let dicts = json as! [[String:Any]]
                
                for dict in dicts {
                    guard let id = dict["id"] as? Int, let contractor_id = dict["contractor_id"] as? Int, let time = dict["time"] as? TimeInterval, let title = dict["title"] as? String, let description = dict["description"] as? String, let type = dict["type"] as? String, let scope = dict["scope"] as? String, let structure = dict["structure"] as? String, let rate = dict["rate"] as? Double, let showRate = dict["showRate"] as? Bool, let open = dict["open"] as? Bool else {
                        
                        return
                    }
                    
                    let newOpening = Opening(id: id, contractor_id: contractor_id, time: time, title: title, description: description, type: type, scope: scope, structure: structure, rate: rate, showRate: showRate, open: open)
                    
                    self.openings.append(newOpening)
                }
            }
        }
        task.resume()
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        let opening = openings[indexPath.row]
        
        cell.textLabel?.text = opening.title
        cell.detailTextLabel?.text = opening.description
        
        return cell
    }

}
