//
//  Scene.swift
//   
//
//  Created by Andrew McHugh on 10/27/21.
//

import Foundation
import SwiftUI
import RealityKit

struct ViewerScene: UIViewRepresentable {
    
    var arMode: ARView.CameraMode
    private var nonARGroundMaterial: ViewerMaterials.AvailableAssets
    
    public init(nonARGroundMaterial: ViewerMaterials.AvailableAssets){
        print("INIT SCENE")
        
        self.arMode = .nonAR
        self.nonARGroundMaterial = nonARGroundMaterial
    }
    
    func makeUIView(context: Context) -> ARView {
        print("MAKEUIVIEW SCENE")
        
        // Create the ARView
        let arView = SceneARView(cameraMode: arMode)
        arView.environment.lighting.resource = try! EnvironmentResource.load(named: "peppermint_powerplant_4k", in: nil)
        
        // Create root anchor for plane
        let rootAnchor = AnchorEntity(world: .zero)
        arView.scene.addAnchor(rootAnchor)
        
        // Create the plane
        let virtualGroundingPlane = ModelEntity(
            mesh: MeshResource.generatePlane(width: 100, depth: 100),
            materials: [ViewerMaterials(objectSize: [100, 100]).materialFor(.woodAssetCatalog)]
        )
        virtualGroundingPlane.name = "VirtualGroundingPlane"
        virtualGroundingPlane.generateCollisionShapes(recursive: false)
        
        rootAnchor.addChild(virtualGroundingPlane)
        arView.installGestures(.all, for: virtualGroundingPlane)
        
        // Add camera
        let virtualCamera = PerspectiveCamera()
        virtualCamera.camera.fieldOfViewInDegrees = 110
        rootAnchor.addChild(virtualCamera)
        let cameraMoveTo: SIMD3<Float> = [2,4,-3]
        virtualCamera.look(at: .zero, from: cameraMoveTo, relativeTo: nil)
        
        // Run session
        arView.session.run(arView.config)
        
        return arView
    }
    
    func updateUIView(_ arView: ARView, context: Context) {
        updateVirtualGroundingPlaneMaterial(to: nonARGroundMaterial, in: arView)
    }
    
    /// Finds the grounding plane and assigns new material to it.
    func updateVirtualGroundingPlaneMaterial(to materialType: ViewerMaterials.AvailableAssets, in arView: ARView){
        guard let model = arView.scene.findEntity(named: "VirtualGroundingPlane") else {return}
        guard let virtualGroundingPlane = model as? ModelEntity else {return}
        let extents = virtualGroundingPlane.model!.mesh.bounds.extents
        let newMaterial = ViewerMaterials.init(objectSize: [extents.x, extents.z]).materialFor(materialType)
        virtualGroundingPlane.model?.materials = [newMaterial]
    }
    
}
