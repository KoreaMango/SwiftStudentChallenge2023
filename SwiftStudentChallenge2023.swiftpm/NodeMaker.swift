//
//  NodeMaker.swift
//  SwiftStudentChallenge2023
//
//  Created by 강민규 on 2023/04/17.
//

import Foundation
import ARKit

class NodeMaker {
    // 항아리 만들기
    static func makeJar() -> SCNNode {
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
    static func makeUnderJar() -> SCNNode {
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
    static func makeArrow(sceneView: ARSCNView) -> SCNNode {
        
        guard let myCamera = sceneView.session.currentFrame?.camera else { return SCNNode() }
        let camPosition = myCamera.transform.columns.3
        let camSCNVector = SCNVector3(camPosition.x, camPosition.y + 0.05, camPosition.z)
        
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
        
        return arrowNode
    }
}
