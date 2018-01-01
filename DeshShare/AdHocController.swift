//
//  AdHocController.swift
//  DeshShare
//
//  Created by Ulrich Lang on 21.12.17.
//  Copyright © 2017 GENOBIS GmbH. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AdHocController: UIViewController {
    
    @IBOutlet weak var lbBooking: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbBuilding: UILabel!
    @IBOutlet weak var lbFloor: UILabel!
    @IBOutlet weak var lbDesk: UILabel!
    @IBOutlet weak var lbStart: UILabel!
    @IBOutlet weak var lbEnd: UILabel!
    
    @IBAction func adhoc(_ sender: Any) {
        print("pressed")
        getActualDesk(tokenid: "7")
    }
    //constants
    let token = ""
    let headers: HTTPHeaders = [
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjcsImlzcyI6ImxvY2FsaG9zdCIsInJvbGUiOiJhZG1pbiIsImlhdCI6MTUxNDIwNjI3MX0.dpOhxNgnNqza38fH97mm_phq-pUtMo5s0NPhlWFvIa8",
        
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
      
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Networking
    /**************************************************************/
    
    func getActualDesk(tokenid: String){

//        let date2 = Date()
//        let calendar = Calendar.current
//        let year = calendar.component(.year, from: date2)
//        let month = calendar.component(.month, from: date2)
//        let day = calendar.component(.day, from: date2)


        Alamofire.request("http://workplace.appwizzard.de:7777/api/users/7/bookings",headers: headers).responseJSON {
            response in
            if response.result.isSuccess {
                let deskJSON : JSON = JSON(response.result.value!)
                let workplaceID = deskJSON[0]["workplace_id"].stringValue
                self.getDeskInfo(deskid:workplaceID)
                
                //Datumsumwandlung
                let starttimenumber = deskJSON[0]["start_time"].doubleValue;
                let startdate = Date(timeIntervalSince1970:starttimenumber)
                let endtimenumber = deskJSON[0]["end_time"].doubleValue;
                let enddate = Date(timeIntervalSince1970:endtimenumber)
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "GMT+1") //Set timezone that you want
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "dd-MM-yyy HH:mm" //Specify your format that you want
                let startDate = dateFormatter.string(from: startdate)
                let endDate = dateFormatter.string(from:enddate)
 
                let now = Date()
                let todayDate = dateFormatter.string(from:now)
                print(todayDate)
                let daypart = todayDate.index(todayDate.startIndex, offsetBy: 2)

                let template = "<<<Hello>>>"
                let indexStartOfDatum = todayDate.index(todayDate.startIndex, offsetBy: 0)
                let indexEndOfDatum = todayDate.index(todayDate.endIndex, offsetBy: -6)
                
                // Swift 4
                let datum = todayDate[indexStartOfDatum..<indexEndOfDatum]  // "Hello>>>"
              //  let substring2 = template[..<indexEndOfText]    // "<<<Hello"
              //  let substring3 = template[indexStartOfText..<indexEndOfText] // "Hello"
                
                let stringDatum = String(datum)
                
                print(stringDatum)
                if stringDatum == startDate {
                    print("gleiches Datum")
                    self.lbStart.text = startDate
                    self.lbEnd.text = endDate
                    
                } else {
                    self.lbBooking.text = "keine Buchung"
                    self.lbLocation.text = ""
                    self.lbDesk.text = ""
                    self.lbFloor.text = ""
                    self.lbStart.text =  ""
                    self.lbEnd.text = ""
                    
                }
                

 
            }
            
        }
  
    }
    
    func getDeskInfo (deskid: String){
        Alamofire.request("http://workplace.appwizzard.de:7777/api/workplaces/"+deskid,headers: headers).responseJSON {
            response in
            if response.result.isSuccess {
                let deskJSON: JSON = JSON(response.result.value!)
                let location = deskJSON["location"]
                self.lbLocation.text = deskJSON["location"].stringValue
                self.lbBuilding.text = deskJSON["building"].stringValue
                self.lbFloor.text = deskJSON["floor"].stringValue
                self.lbDesk.text = deskJSON["name"].stringValue

                
            }
            
        }
        
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
