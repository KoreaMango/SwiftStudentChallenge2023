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

// Categories
let arrowCategory        : Int = 0x1 << 0
let jarCategory          : Int = 0x1 << 1

class ARViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, UIGestureRecognizerDelegate, SCNPhysicsContactDelegate {
    //MARK: - Properties
    // AR Scene View
    lazy var sceneView: ARSCNView = {
        let scene = ARSCNView()
        scene.delegate = self
        scene.session.delegate = self
        scene.scene.physicsWorld.contactDelegate = self
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
    
    var camSCNVector: SCNVector3?
    var myCamera: ARCamera?
    
    // AudioPlayer
    let soundManager = SoundManager()
    
    //MARK: - SceneKit
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        guard let nodeNameA = contact.nodeA.name else { return }
        guard let nodeNameB = contact.nodeB.name else { return }
        
        var arrowContactNode: SCNNode?
        
        if nodeNameA == "underJar" && nodeNameB == "arrow" {
            arrowContactNode = contact.nodeB
        }
                
        if let arrowNode = arrowContactNode {
            arrowNode.runAction(
                SCNAction.run({ node in
                    self.score += 1
                    
                    node.isPaused = true
                })
            )
        }
    }
    
    //MARK: - ARKit
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let cam = frame.camera
        let camPosition = cam.transform.columns.3
        
        myCamera = cam
        camSCNVector = SCNVector3(camPosition.x, camPosition.y + 0.05, camPosition.z)
        
    }

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
    // 항아리 만들기
    func makeJar() -> SCNNode {
        let jarNode = SCNNode()
        
        let outMaterial = SCNMaterial()
        let inMaterial = SCNMaterial()
        
        let jarOut = SCNTube(innerRadius: 0.16, outerRadius: 0.20, height: 0.50)
        
        // 튜브 중앙 뚫리는 옵션
        let shape = SCNPhysicsShape(geometry: jarOut,
                                    options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron])
        
        let jarPhysicsBody = SCNPhysicsBody(
            type: .static,
            shape: shape
        )
        
        outMaterial.diffuse.contents = UIImage(named: "TreeTexture")
        inMaterial.diffuse.contents = UIImage(named: "InnerTreeTexture")
        
        jarNode.name = "jar"
        jarNode.physicsBody = jarPhysicsBody
        jarNode.geometry = jarOut
        jarNode.geometry?.materials = [outMaterial, inMaterial]
        jarNode.position = SCNVector3(0, -2, -2)
        
        return jarNode
    }
    
    // 항아리 밑면
    func makeUnderJar() -> SCNNode {
        let underJarNode = SCNNode()
        
        let underMaterial = SCNMaterial()
        
        let jarUnder = SCNCylinder(radius: 0.16, height: 0.05)
        
        let jarPhysicsBody = SCNPhysicsBody(
            type: .static,
            shape: SCNPhysicsShape(geometry: jarUnder )
        )
        
        underMaterial.diffuse.contents = UIImage(named: "UnderTreeTexture")
        
        underJarNode.name = "underJar"
        underJarNode.physicsBody = jarPhysicsBody
        underJarNode.physicsBody?.categoryBitMask = jarCategory
        underJarNode.geometry = jarUnder
        underJarNode.geometry?.materials = [underMaterial]
        underJarNode.position = SCNVector3(0, -2.05, -2)
        
        return underJarNode
    }
    
    // 화살
    func makeArrow() -> SCNNode {
        guard let myCamera = myCamera else { return SCNNode() }
        guard let camSCNVector = camSCNVector else { return SCNNode() }
        guard let pointOfView = sceneView.pointOfView else {
            print("Error")
            return SCNNode()
        }

        // 1
        let arrowNode = SCNNode()
        
        let material = SCNMaterial()
        
        let arrow = SCNCylinder(radius: 0.015 , height: 0.8)
        
        let arrowPhysicsBody = SCNPhysicsBody(
            type: .dynamic,
            shape: SCNPhysicsShape(geometry: arrow)
        )
        
        material.diffuse.contents = UIImage(named: "arrowTexture")
        
        arrowNode.geometry = arrow
        arrowNode.geometry?.materials = [material]
        
        
        let angle = SCNVector3Make(.pi/3 + myCamera.eulerAngles.x, 0 +  myCamera.eulerAngles.y, .pi/2 +  myCamera.eulerAngles.z)
        arrowNode.eulerAngles = angle
        arrowPhysicsBody.mass = 1
        
        arrowNode.name = "arrow"
        arrowNode.physicsBody = arrowPhysicsBody
        arrowNode.physicsBody?.categoryBitMask = arrowCategory
        arrowNode.physicsBody?.collisionBitMask = arrowCategory | jarCategory
        arrowNode.physicsBody?.contactTestBitMask = arrowCategory | jarCategory
        
        arrowNode.position = camSCNVector
        
        let force = SCNVector3(pointOfView.simdWorldFront.x * 4
                               ,pointOfView.simdWorldFront.y * 4
                               ,pointOfView.simdWorldFront.z * 4)

        
        arrowNode.physicsBody?.applyForce(force, asImpulse: true)
        
        soundManager.playThrowSound()
        
        return arrowNode
    }
    
    // MARK: - Tap Action
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let arrow = makeArrow()
        sceneView.scene.rootNode.addChildNode(arrow)
        return true
    }
}

