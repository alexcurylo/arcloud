//
//  ViewController.swift
//  ARCloud
//
//  Created by Alex Curylo on 10/26/17.
//  Copyright © 2017 Trollwerks Inc. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class ViewController: UIViewController, ARSKViewDelegate {
    
    @IBOutlet var sceneView: ARSKView!
    
    // https://cloud.estimote.com/#/beacons
    let candyABox = "543062abae6c28558d71a081e2512d2e"
    let lemonAKey = "68abb64364c4d76374661c06a3badf12"
    let cloudManager = CloudManager()
    let proximityManager = ProximityManager()
    var beaconsInRange: Set<String> = []
    var zoneViewByBeaconIdentifier = [String: UIView]()

    let synthesizer = AVSpeechSynthesizer()
    let nothingHere = AVSpeechUtterance(string: "Nothing here")
    var foundBox = false
    let boxLocked = AVSpeechUtterance(string: "This box is locked")
    var foundKey = false
    let keyHere = AVSpeechUtterance(string: "There is a key here")
    let unlocks = AVSpeechUtterance(string: "The box unlocks and you find treasure!")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBeaconsInfo()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        // Load the SKScene from 'Scene.sks'
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSKViewDelegate
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        let labelNode: SKLabelNode
        if foundBox, foundKey, beaconsInRange.contains(candyABox){
            labelNode = SKLabelNode(text: "💰")
            synthesizer.speak(unlocks)
        } else if !foundBox, beaconsInRange.contains(candyABox){
            foundBox = true
            labelNode = SKLabelNode(text: "📦")
            synthesizer.speak(boxLocked)
        } else if !foundKey, beaconsInRange.contains(lemonAKey) {
            foundKey = true
            labelNode = SKLabelNode(text: "🗝")
            synthesizer.speak(keyHere)
        } else {
            synthesizer.speak(nothingHere)
            return nil
        }
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        return labelNode;
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

private extension ViewController { // Estimote
    
    func loadBeaconsInfo() {
        let beacons = [lemonAKey, candyABox]
        cloudManager.fetchColors(beaconIdentifiers: beacons) { result in
            
            switch result {
            case .error:
                self.presentFetchingColorsFailedAlert()
                return
                
            case .success(let colorByIdentifier):
                self.addBeaconZoneViews(colorByBeaconIdentifier: colorByIdentifier)
                self.proximityManager.delegate = self
                self.proximityManager.startMonitoringProximity(identifiers: beacons)
            }
        }
    }
    
    func presentFetchingColorsFailedAlert() {
        let alert = UIAlertController(title: "Fetching colors failed", message: "Check your internet connection, App ID and App Token.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentMonitoringFailedAlert() {
        let alert = UIAlertController(title: "Monitoring failed", message: "Make sure bluetooth is on and the app has permission to use it.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addBeaconZoneViews(colorByBeaconIdentifier: [String: UIColor]) {
        for (index, identifier) in colorByBeaconIdentifier.keys.enumerated() {
            let zoneView = UIView(frame: CGRect(x: index * 40, y: 0, width: 40, height: 40))
            zoneView.backgroundColor = colorByBeaconIdentifier[identifier]
            zoneViewByBeaconIdentifier[identifier] = zoneView
            zoneView.isHidden = true
            sceneView.addSubview(zoneView)
        }
    }

    func hideViewIfNeeded(view: UIView, shouldBeHidden hidden: Bool) {
        if view.isHidden != hidden {
            view.isHidden = hidden
        }
    }
}

extension ViewController: ProximityManagerDelegate {

    func proximityManager(_ proximityManager: ProximityManager,
                          didUpdateBeaconsInRange identifiers: Set<String>) {
        beaconsInRange = identifiers
        [lemonAKey, candyABox].forEach({ (identifier) in
            guard let zoneView = zoneViewByBeaconIdentifier[identifier] else { return }
            
            let identifierIsNotInRange: Bool = !identifiers.contains(identifier)
            hideViewIfNeeded(view: zoneView, shouldBeHidden: identifierIsNotInRange)
        })
    }
    
    func proximityManager(_ proximityManager: ProximityManager, didFailWithError: Error) {
        self.presentMonitoringFailedAlert()
    }
}
