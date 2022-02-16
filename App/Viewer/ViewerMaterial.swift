//
//  ViewerMaterial.swift
//   
//
//  Created by Andrew McHugh on 2/8/22.
//

import Foundation
import RealityKit
import simd

/// Struct for constructing PBR materials.
struct ViewerMaterials {
    enum AvailableAssets: String, CaseIterable {
        case marbleInlay, invisible, woodFolder, woodAssetCatalog
    }
    
    /// Configuration for a material.
    struct ViewerMaterial {
        let name: AvailableAssets
        var texturePrefix: String = ""
        var textureSuffix: String = ""
        var textureRaw: String = ""
        var naturalScale: SIMD2<Float> = [1,1]
        var offset: SIMD2<Float> = [0,0]
        var rotation: Float = 0
        var isAllTextures: Bool = true
        
        func textureName(_ textureType: ViewerMaterials.TextureType) -> String{
            return texturePrefix + textureType.rawValue + textureSuffix
        }
        func textureScale(objectSize: SIMD2<Float>) -> SIMD2<Float>{
            return objectSize / naturalScale
        }
        func textureFor(_ type: TextureType) -> MaterialParameters.Texture? {
            let name: String = textureName(type)
            let resource = try? TextureResource.load(named: name)
            guard let resource = resource else {
                print("Didn't load \(type.rawValue)")
                return nil
            }
            return MaterialParameters.Texture(resource)
        }
    }
    
    enum TextureType: String {
        case Albedo, AO, Normal, Roughness, Metalness
    }
    
    private let materials = [
        ViewerMaterial(name: .woodFolder, texturePrefix: "wood_table_001_", naturalScale: [10,10]),
        ViewerMaterial(name: .woodAssetCatalog, texturePrefix: "wood_table_catalog/", naturalScale: [10,10]),
        ViewerMaterial(name: .invisible, isAllTextures: false)
    ]
    
    var objectSize: SIMD2<Float> = [1,1]
    
    /// Searches the materials config array. Always returns a valid PBR material.
    func materialFor(_ asset: AvailableAssets) -> PhysicallyBasedMaterial {
        guard let viewerMaterial = materials.first(where: {$0.name == asset}) else {
            print("Couldn't generate a material for the asset. Returning default material.")
            return PhysicallyBasedMaterial()
        }
        return createMaterial(viewerMaterial: viewerMaterial)
    }
    
    /// Creates a PBR material from a given configuration.
    private func createMaterial(viewerMaterial: ViewerMaterial) -> PhysicallyBasedMaterial {
        var material = PhysicallyBasedMaterial()
        if viewerMaterial.isAllTextures {
            if let albedo = viewerMaterial.textureFor(.Albedo){
                material.baseColor = PhysicallyBasedMaterial.BaseColor(texture: albedo)
            }
            if let ao = viewerMaterial.textureFor(.AO){
                material.ambientOcclusion = PhysicallyBasedMaterial.AmbientOcclusion(texture: ao)
            }
            if let normal = viewerMaterial.textureFor(.Normal){
                material.normal = PhysicallyBasedMaterial.Normal(texture: normal)
            }
            if let metalness = viewerMaterial.textureFor(.Metalness){
                material.metallic = PhysicallyBasedMaterial.Metallic(texture: metalness)
            }
            if let roughness = viewerMaterial.textureFor(.Roughness){
                material.roughness = PhysicallyBasedMaterial.Roughness(texture: roughness)
            }
        } else if viewerMaterial.name == .invisible {
            material.blending = .transparent(opacity: .init(floatLiteral: 0))
        }
        
        material.textureCoordinateTransform = .init(offset: viewerMaterial.offset, scale: viewerMaterial.textureScale(objectSize: objectSize), rotation: viewerMaterial.rotation)
        
        return material
    }
}



