//
//  ViewController.swift
//  Whack a jellyfish
//
//  Created by Hermes Frangoudis on 2/13/18.
//  Copyright © 2018 iAmHermes. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var SceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // scene initializer
        self.SceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin,
        ARSCNDebugOptions.showFeaturePoints]
        self.SceneView.session.run(configuration)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        self.SceneView.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playAction(_ sender: Any) {
        self.addNode()
    }
    
    @IBAction func resetAction(_ sender: Any) {
    }
    
    func addNode() {
        let node = SCNNode(geometry: SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0))
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        node.position = SCNVector3(0,0,-1)
        self.SceneView.scene.rootNode.addChildNode(node)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        if hitTest.isEmpty {
            print("didn't touch anything")
        } else {
            let hitResults = hitTest.first!
            let hitGeometry  = hitResults.node.geometry
            print("tapped on a box: \(String(describing: hitGeometry))")
        }
    }
    
}

