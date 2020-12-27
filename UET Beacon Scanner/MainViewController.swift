//
//  MainViewController.swift
//  UET Beacon Scanner
//
//  Created by Duong Son on 11/12/17.
//  Copyright © 2017 Duong Son. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.beacons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as! CustomTableViewCell
        let row: Int = indexPath.row
        let beacon: CLBeacon = self.beacons[row]
        //let beaconUUID: String = "\(beacon.proximityUUID)"
        let beaconUUID: String = "\(beacon.proximityUUID)"
        let beaconMajor: String = "\(beacon.major)"
        let beaconMinor: String = "\(beacon.minor)"
        let beaconRSSI: String = "\(beacon.rssi)"
        let beaconProximity: String = "\(beacon.accuracy)"
        //cell?.textLabel?.text = beaconUUID
        // Tra ve ket qua tren Label
        cell.uuidLabel.text         =   beaconUUID
        cell.majorLabel.text        =   beaconMajor
        cell.minorLabel.text        =   beaconMinor
        cell.rssiLabel.text         =   beaconRSSI
        cell.proximityLabel.text    =   beaconProximity
        return cell
    }
    
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "hjghjgj")
    let locationManager : CLLocationManager = CLLocationManager()
    @IBOutlet weak var myTable: UITableView!
    var beacons:[CLBeacon] = []
    var measurements = [0,0,0,0,0] // Day tin hieu nhan duoc vao mang nay
    var filter = KalmanFilter(stateEstimatePrior: 0.0, errorCovariancePrior: 1)
    
    override func viewDidLoad() {
        appendLog(s: "Major, Minor, RSSI", fileName: "logData.csv")
        super.viewDidLoad()
        self.myTable.rowHeight = 100
        locationManager.delegate = self
        myTable.dataSource = self
        myTable.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startRangingBeacons(in: region)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        self.beacons = beacons
        self.myTable.reloadData()
        let input1 = beacons.last?.rssi
        let input2 = beacons.first?.major
        let input3 = beacons.first?.minor
        
        if input1 != nil {
            measurements.remove(at: 0)      // xem Queue.swift
            measurements.append(input1!)    // xem Queue.swift
            //print(measurements)
            
            print("Major: \(input2!), Minor: \(input3!), RSSI: \(input1!)")
            appendLog(s: "\(input2!), \(input3!), \(input1!)", fileName: "logData.csv")
        }
        for measurement in measurements {
            let prediction = filter.predict(stateTransitionModel: 1, controlInputModel: 0, controlVector: 0, covarianceOfProcessNoise: 0)
            let update = prediction.update(measurement: Double(measurement), observationModel: 1, covarienceOfObservationNoise: 0.1)

            filter = update
            print(update)
        }
//        let fileName = "logx.csv"
//        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
//        var csvText = "Major,RSSI\n"
//        for knownBeacon in beacons{
//            let newLine = "\(knownBeacon.major),\(knownBeacon.rssi)"
//            csvText.append(newLine)
//        }
//        do {
//            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
//        } catch {
//            print("Failed to create file")
//            print("\(error)")
//        }
//        print(path ?? "not found")
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
