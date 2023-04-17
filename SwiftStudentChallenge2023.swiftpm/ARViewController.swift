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
    
    // 투호 개수
    private var count: Int = 10 {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                self.countLabel.text = "\(self.count)"
            }
        }
    }
    
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
    
    // 카운트 Label
    private let countLabel = UILabel(frame: CGRect(x: 0,
                                                   y: 100,
                                                   width: UIScreen.main.bounds.width - 20,
                                                   height: 40))
    
    // 남은 화살 카운트 Label
    private let countTextLabel = UILabel(frame: CGRect(x: 0,
                                                   y: 60,
                                                   width: UIScreen.main.bounds.width - 20,
                                                   height: 40))
    
    // ARSession에 적용할 월드 트래킹 설정
    let configuration = ARWorldTrackingConfiguration()
    
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
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make Jar Object
        let jar = NodeMaker.makeJar()
        let underJar = NodeMaker.makeUnderJar()
        
        // Tap Recognizer
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.delegate = self
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        // SceneView
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
        
        
        // 외곽선
        let attrString = NSAttributedString(
            string: "외곽선 라벨",
            attributes: [
                NSAttributedString.Key.strokeColor: UIColor.black,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.strokeWidth: -3.0,
            ]
        )
        countTextLabel.attributedText = attrString
        countLabel.attributedText = attrString
        scoreLabel.attributedText = attrString
        
        // 점수 Label 설정
        score = 0
        scoreLabel.font = UIFont(name: "HelveticaNeue", size: 80.0)
        scoreLabel.textColor = .white
        scoreLabel.textAlignment = .center
        
        sceneView.addSubview(scoreLabel)
  
        
        // 카운트 Label 설정
        count = 10
        countLabel.font = UIFont(name: "HelveticaNeue", size: 40.0)
        countLabel.textAlignment = .right
        
        sceneView.addSubview(countLabel)
        
        // 카운트 설명 Label
        countTextLabel.text = "arrows left"
        countTextLabel.font = UIFont(name: "HelveticaNeue", size: 30.0)
        countTextLabel.textAlignment = .right
        
        sceneView.addSubview(countTextLabel)
    }

    
    // MARK: - Tap Action
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let arrow = NodeMaker.makeArrow(sceneView: sceneView)
        sceneView.scene.rootNode.addChildNode(arrow)
        soundManager.playThrowSound()
        count -= 1
        return true
    }
}

