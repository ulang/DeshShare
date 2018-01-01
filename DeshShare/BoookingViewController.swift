//
//  BoookingViewController.swift
//  DeshShare
//
//  Created by Ulrich Lang on 30.12.17.
//  Copyright © 2017 GENOBIS GmbH. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BoookingViewController: UIViewController, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    
    //vars
    var locations = [String]() //array zur speicherung aller lokationen
    
    
    
    //constants
    let token = ""
    let headers: HTTPHeaders = [
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjcsImlzcyI6ImxvY2FsaG9zdCIsInJvbGUiOiJhZG1pbiIsImlhdCI6MTUxNDIwNjI3MX0.dpOhxNgnNqza38fH97mm_phq-pUtMo5s0NPhlWFvIa8",
        
        ]

    @IBOutlet weak var locationTable: UITableView!
    
    @IBOutlet weak var locationPicker: UIPickerView!
    
    @IBOutlet weak var lbLocation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTable.dataSource = self
        locationPicker.dataSource = self
        locationPicker.delegate = self
        getLocation()
        
    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Networking
    /**************************************************************/
    
    func getLocation(){
        Alamofire.request("http://workplace.appwizzard.de:7777/api/locations",headers: headers).responseJSON {
            response in
            if response.result.isSuccess {
                let locationJSON : JSON = JSON(response.result.value!)
                print(locationJSON)
                print(locationJSON[0]["name"].stringValue)
                print(locationJSON.count)
                
                
                
                for location in locationJSON[].arrayValue {
                    print (location["name"].stringValue)
                    self.locations.append(location["name"].stringValue)
                }
                print(self.locations)
                self.locationTable.reloadData()
                self.locationPicker.reloadAllComponents()
                
               // let workplaceID = deskJSON[0]["workplace_id"].stringValue
               // self.getDeskInfo(deskid:workplaceID)
            }
        }
    }
    
    //MARK: . locationPicker
    //**************************************************************************
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locations[row]
    
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        lbLocation.text = locations[row]
    }
    
    // MARK: - locationTable
    //**************************************************************************
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       print (locations.count)
        return locations.count
    }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellLocation")!
        let text = locations[indexPath.row] //2.
        
        cell.textLabel?.text = text //3.
        
        
        return cell

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
