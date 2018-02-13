//
//  ViewController.swift
//  Whack a jellyfish
//
//  Created by Hermes Frangoudis on 2/13/18.
//  Copyright © 2018 iAmHermes. All rights reserved.
//

import UIKit
import ARKit
import Each

class ViewController: UIViewController {

    @IBOutlet weak var SceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var timerLabel: NSLayoutConstraint!
    
    var timer = Each(1).seconds
    var countDown = 10
    
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
        self.playBtn.isEnabled = false
    }
    
    @IBAction func resetAction(_ sender: Any) {
    }
    
    func addNode() {
        let jellyFishScene = SCNScene(named: "art.scnassets/Jellyfish.scn")
        let jellyFishNode = jellyFishScene?.rootNode.childNode(withName: "jellyFish", recursively: false)
        jellyFishNode?.position = SCNVector3(randomNumbers(firstNum: -1, secondNum: 1), randomNumbers(firstNum: -0.5, secondNum: 0.5), randomNumbers(firstNum: -1, secondNum: 1))
        self.SceneView.scene.rootNode.addChildNode(jellyFishNode!)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        if hitTest.isEmpty {
            print("didn't touch anything")
        } else {
            let hitResults = hitTest.first!
            let hitNode = hitResults.node
            if hitNode.animationKeys.isEmpty {
                SCNTransaction.begin()
                self.animateJellyFish(node: hitNode)
                SCNTransaction.completionBlock = {
                    hitNode.removeFromParentNode()
                    self.addNode()
                }
                SCNTransaction.commit()
            }
        }
    }
    
    func animateJellyFish(node: SCNNode){
        let vibrateAnim = CABasicAnimation(keyPath: "position")
        vibrateAnim.fromValue = node.presentation.position
        vibrateAnim.toValue = SCNVector3(node.presentation.position.x - 0.2, node.presentation.position.y - 0.2, node.presentation.position.z - 0.2)
        vibrateAnim.duration = 0.07
        vibrateAnim.autoreverses = true
        vibrateAnim.repeatCount = 5
        node.addAnimation(vibrateAnim, forKey: "position")
    }
    
}

func randomNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum,secondNum)
}


