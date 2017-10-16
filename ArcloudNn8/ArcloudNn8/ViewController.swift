//
// Please report any problems with this app template to contact@estimote.com
//

import UIKit

class ViewController: UIViewController {
    
    /** TODO: Make sure your beacons have Estimote Monitoring feature set enabled:
     https://community.estimote.com/hc/en-us/articles/226144728
     */
    
    let beaconIdentifiers = ["543062abae6c28558d71a081e2512d2e",
                             "68abb64364c4d76374661c06a3badf12",
                             "6e14f172e245fb549ceb296c819bbb38"]
    let cloudManager = CloudManager()
    let proximityManager = ProximityManager()
    var zoneViewByBeaconIdentifier = [String: UIView]()
    
    @IBOutlet weak var noBeaconsView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateBeaconZoneViews(beaconIdentifiersInRange: [])
        
        // Step 1: Pre-fetch content related to your beacons
        self.cloudManager.fetchColors(beaconIdentifiers: self.beaconIdentifiers) { (result) in
            
            switch result {
            case .error:
                self.presentFetchingColorsFailedAlert()
                return
                
            case .success(let colorByIdentifier):
                self.addBeaconZoneViews(colorByBeaconIdentifier: colorByIdentifier)
                
                // Step 2: Start monitoring proximity of your beacons
                self.proximityManager.delegate = self
                self.proximityManager.startMonitoringProximity(identifiers: self.beaconIdentifiers)
            }
        }
    }
}

extension ViewController: ProximityManagerDelegate {
    func proximityManager(_ proximityManager: ProximityManager, didUpdateBeaconsInRange identifiers: [String]) {
        
        // Step 3: Update UI dependant on which beacons are in range
        self.updateBeaconZoneViews(beaconIdentifiersInRange: identifiers)
    }
    
    func proximityManager(_ proximityManager: ProximityManager, didFailWithError: Error) {
        self.presentMonitoringFailedAlert()
    }
}
