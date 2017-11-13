//
//  ViewController.swift
//  World Tracking
//
//  Created by Macbook on 11/12/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // setup debug options for scene
        // shows if feature points are being descovered and if world origin is properly set
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.autoenablesDefaultLighting = true // adds default (omni directional) light source to the scene
        
        self.sceneView.session.run(configuration) // run session config
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // action for Add button within UIview
    @IBAction func addObject(_ sender: Any) {
        // pitch - rotate around y-axis
        // yaw - rotate around z-axis
        // roll - rotate around x-axis

        // roll example
//        let pyramid = SCNNode(geometry: SCNPyramid(width: 0.1, height: 0.1, length: 0.1))
//        pyramid.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
//        pyramid.position = SCNVector3(0,0,-0.3)
//        pyramid.eulerAngles = SCNVector3(Float(180.degreesToRadiens),0,0) // roll
//        self.sceneView.scene.rootNode.addChildNode(pyramid)

        // pitch example
        let plane = SCNNode(geometry: SCNPlane(width: 0.3, height: 0.3))
        plane.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        plane.position = SCNVector3(0,0,-0.3)
        plane.eulerAngles = SCNVector3(0,Float(90.degreesToRadiens),0)
        plane.geometry?.firstMaterial?.isDoubleSided = true // set both sides of the plane visible
        self.sceneView.scene.rootNode.addChildNode(plane)
        
        // yaw example
//        let cylinder = SCNNode(geometry: SCNCylinder(radius: 0.1, height: 0.3))
//        cylinder.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
//        cylinder.position = SCNVector3(0,0,-0.3)
//        cylinder.eulerAngles = SCNVector3(0,0,Float(90.degreesToRadiens))
//        self.sceneView.scene.rootNode.addChildNode(cylinder)
        
        
        // simple house from native geometeries
//        let doorNode = SCNNode(geometry: SCNPlane(width: 0.03, height: 0.06))
//        doorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.brown
//
//        let boxNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
//        boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
//
//        let node = SCNNode() // a node is a position in space (no size or shape)
//
//        node.geometry = SCNPyramid(width: 0.1, height: 0.1, length: 0.1) // add a pyramid
//
//        node.geometry?.firstMaterial?.specular.contents = UIColor.orange // specular describes color of light that reflects from surface
//        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red // set the box to blue
//
//        node.position = SCNVector3(0,0,-0.7) // set the position at location
//        boxNode.position = SCNVector3(0, -0.05, 0) // set position relative to pyramid
//        doorNode.position = SCNVector3(0,-0.02,0.053)
        
//        boxNode.addChildNode(doorNode) // add door as child to box
//        node.addChildNode(boxNode) // add box as a child of pyramid
//        self.sceneView.scene.rootNode.addChildNode(node) // add the newly created node to the scene
    }
    
    // action for the Reset button within the UIview
    @IBAction func resetBtnAction(_ sender: Any) {
        self.restartSession() //
    }
    
    func restartSession() {
        self.sceneView.session.pause() // pause the scene view session - stops keeping track of position/orientation
        // remove the box node from the scene
        self.sceneView.scene.rootNode.enumerateChildNodes { (child, _) in
            child.removeFromParentNode()
        }
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])// restart the tracking session, remove anchors
    }
    
    func randomNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum,secondNum)
    }
}

extension Int {
    var degreesToRadiens: Double { return Double(self) * .pi/180}
}

