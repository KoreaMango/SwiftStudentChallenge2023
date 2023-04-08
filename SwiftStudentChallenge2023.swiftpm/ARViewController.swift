//
//  ARViewController.swift
//  SwiftStudentChallenge2023
//
//  Created by 강민규 on 2023/04/04.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, UIGestureRecognizerDelegate {
    //MARK: - Properties
    // AR Scene View
    lazy var sceneView: ARSCNView = {
        let scene = ARSCNView()
        scene.delegate = self
        scene.session.delegate = self
        scene.showsStatistics = false
        
        return scene
    }()
    
    // 투호 점수
    private var score: UInt = 0 {
           didSet {
               DispatchQueue.main.async { [unowned self] in
                   self.scoreLabel.text = "\(self.score)"
                   
               }
           }
       }
    
    // 점수 Label
    private let scoreLabel = UILabel(frame: CGRect(x: 0,
                                                   y: UIScreen.main.bounds.height / 8,
                                                   width: UIScreen.main.bounds.width,
                                                   height: 100))
    
    // ARSession에 적용할 월드 트래킹 설정
    let configuration = ARWorldTrackingConfiguration()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make Jar Object
        let jar = makeJar()
        let underJar = makeUnderJar()
        
        // Tap Recognizer
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.delegate = self
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)

        self.view.addSubview(sceneView)
        sceneView.scene.rootNode.addChildNode(jar)
        sceneView.scene.rootNode.addChildNode(underJar)
       
        // Layout
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // configuration 세부 설정
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        
        // config 적용후 실행
        sceneView.session.run(configuration)
        
        score = 0
        scoreLabel.font = UIFont(name: "HelveticaNeue", size: 100.0)
        scoreLabel.textColor = .white
        scoreLabel.textAlignment = .center
        
        sceneView.addSubview(scoreLabel)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: - Scene Function
    func makeJar() -> SCNNode {
        let jarNode = SCNNode()

        let outMaterial = SCNMaterial()
        let inMaterial = SCNMaterial()
        
        let jarOut = SCNTube(innerRadius: 0.08, outerRadius: 0.10, height: 0.25)
        
        let jarPhysicsBody = SCNPhysicsBody(
            type: .static,
            shape: SCNPhysicsShape(geometry:  SCNTube(innerRadius: 0.08, outerRadius: 0.10, height: 0.25))
        )
        
        outMaterial.diffuse.contents = UIImage(named: "TreeTexture")
        inMaterial.diffuse.contents = UIImage(named: "InnerTreeTexture")
        
        jarNode.physicsBody = jarPhysicsBody
        jarNode.geometry = jarOut
        jarNode.geometry?.materials = [outMaterial, inMaterial]
        jarNode.position = SCNVector3(0, -1, -1)
        
        return jarNode
    }
    
    func makeUnderJar() -> SCNNode {
        let underJarNode = SCNNode()
        
        let underMaterial = SCNMaterial()
        
        let jarUnder = SCNCylinder(radius: 0.08, height: 0.05)
        
        let jarPhysicsBody = SCNPhysicsBody(
            type: .static,
            shape: SCNPhysicsShape(geometry: SCNCylinder(radius: 0.08, height: 0.05))
        )
        
        underMaterial.diffuse.contents = UIImage(named: "UnderTreeTexture")
        
        underJarNode.physicsBody = jarPhysicsBody
        underJarNode.geometry = jarUnder
        underJarNode.geometry?.materials = [underMaterial]
        underJarNode.position = SCNVector3(0, -1.05, -1)
        
        return underJarNode
    }
    
    func makeArrow() -> SCNNode {
        // 1
        let arrowNode = SCNNode()
        
        let material = SCNMaterial()
        
        let arrow = SCNCylinder(radius: 0.01, height: 0.3)
        
        let arrowPhysicsBody = SCNPhysicsBody(
            type: .dynamic,
            shape: SCNPhysicsShape(geometry: SCNCylinder(radius: 0.01, height: 0.3))
        )
        
        material.diffuse.contents = UIColor.red
        
        arrowNode.geometry = arrow
        arrowNode.geometry?.materials = [material]
        
        arrowPhysicsBody.mass = 1
        arrowPhysicsBody.friction = 2
        arrowPhysicsBody.contactTestBitMask = 1

        arrowNode.physicsBody = arrowPhysicsBody
        arrowNode.position = SCNVector3(0, 0, -1)
      
        // 2
        //currentBallNode = ballNode
        return arrowNode
    }
    
    // MARK: - Tap Action
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let arrow = makeArrow()
        sceneView.scene.rootNode.addChildNode(arrow)
        return true
    }
   
}

